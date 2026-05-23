import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/consts/app_text_styles.dart';
import 'package:tesoro_nft_app/controllers/treasure_navigation_controller.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_scaffold.dart';
import 'package:tesoro_nft_app/custom_widgets/dialogs/just_actions_dialogs.dart';
import 'package:tesoro_nft_app/custom_widgets/loader_widget.dart';
import 'package:tesoro_nft_app/custom_widgets/permission_enable_component.dart';
import 'package:tesoro_nft_app/models/treasures/treasure_get_model.dart';
import 'package:tesoro_nft_app/providers/preferences_provider.dart';
import 'package:tesoro_nft_app/utils/app_permissions.dart';

class TreasureNavigation extends StatefulWidget {
  const TreasureNavigation({
    super.key,
    required this.treasureGetModel,
  });

  final TreasureGetModel treasureGetModel;

  @override
  State<TreasureNavigation> createState() => _TreasureNavigationState();
}

class _TreasureNavigationState extends State<TreasureNavigation>
    with WidgetsBindingObserver {
  late final TreasureNavigationController _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _controller = TreasureNavigationController(
      treasure: widget.treasureGetModel,
      onArrived: _showArrivalDialogs,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.initializeNavigation(context.read<AppPermissions>());
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _controller.onLifecycleChanged(state);
  }

  Future<void> _showArrivalDialogs() async {
    if (!mounted) return;
    await showAllDialogs(
      context,
      context.read<PreferencesProvider>().userId ?? '',
      widget.treasureGetModel,
    );
  }

  Future<void> _exitScreen() async {
    await _controller.stopNavigationSession(clearMapState: false);
    if (!mounted) return;
    context.pop();
  }

  Future<bool> _onWillPop() async {
    await _controller.stopNavigationSession(clearMapState: false);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TreasureNavigationController>.value(
      value: _controller,
      child: Consumer<TreasureNavigationController>(
        builder: (context, controller, _) {
          final summaryDistance = controller.isNavigationStarted
              ? controller.remainingDistanceText
              : controller.totalDistanceText;
          final summaryDuration = controller.isNavigationStarted
              ? controller.remainingDurationText
              : controller.totalDurationText;
          final summaryLabel =
              controller.isNavigationStarted ? 'Remaining' : 'Total';

          return CustomScaffold(
            backgroundColor: AppColors.light,
            child: WillPopScope(
              onWillPop: _onWillPop,
              child: Stack(
                children: [
                  if (controller.isLocationAllowed)
                    GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target:
                            controller.currentPosition ?? const LatLng(0, 0),
                        zoom: 17,
                        tilt: 45,
                      ),
                      padding: EdgeInsets.only(
                        top: 150,
                        bottom: controller.isNavigationStarted ? 150 : 220,
                      ),
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      compassEnabled: true,
                      markers: controller.markers,
                      polylines: controller.polylines,
                      onMapCreated: controller.onMapCreated,
                    ),
                  if (controller.isLocationAllowed)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: SafeArea(
                        bottom: false,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Material(
                                    color: AppColors.light,
                                    borderRadius: BorderRadius.circular(12),
                                    child: IconButton(
                                      onPressed: _exitScreen,
                                      icon: const Icon(Icons.arrow_back),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: AppColors.light,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x22000000),
                                      blurRadius: 12,
                                      offset: Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      controller.isNavigationStarted
                                          ? 'Next turn'
                                          : 'Route preview',
                                      style: AppTextStyles.labelMedium.copyWith(
                                        color: AppColors.dialogBtn,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      controller.nextInstruction,
                                      style:
                                          AppTextStyles.headingMedium.copyWith(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.lightPrimary,
                                            borderRadius:
                                                BorderRadius.circular(999),
                                          ),
                                          child: Text(
                                            controller.nextTurnDistanceText,
                                            style: AppTextStyles.bodySmall
                                                .copyWith(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          'to next turn',
                                          style: AppTextStyles.bodySmall,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  if (controller.isLocationAllowed)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: SafeArea(
                        top: false,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.light,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x22000000),
                                  blurRadius: 12,
                                  offset: Offset(0, -2),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '$summaryLabel distance',
                                      style: AppTextStyles.labelMedium.copyWith(
                                        color: AppColors.dark,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      summaryDistance,
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '$summaryLabel time',
                                      style: AppTextStyles.labelMedium.copyWith(
                                        color: AppColors.dark,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      summaryDuration,
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'ETA',
                                      style: AppTextStyles.labelMedium.copyWith(
                                        color: AppColors.dark,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      controller.etaText,
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                if (controller.isReadyToStart &&
                                    !controller.isNavigationStarted) ...[
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: controller.startNavigation,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.dialogBtn,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        shape: const StadiumBorder(),
                                      ),
                                      child: Text(
                                        'Start',
                                        style: AppTextStyles.bodyLarge.copyWith(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (controller.isRerouting)
                    Positioned(
                      top: 200,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            'Re-routing...',
                            style: AppTextStyles.labelMedium.copyWith(
                              color: AppColors.dark,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (!controller.isLocationAllowed)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: PermissionEnableComponent(
                        txt: 'Location permission is required for navigation',
                        buttonText: 'Enable',
                        onTap: () => controller.requestPermissionAndRestart(
                          context.read<AppPermissions>(),
                        ),
                      ),
                    ),
                  if (controller.isLoading)
                    const Center(
                      child: LoaderWidget(),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
