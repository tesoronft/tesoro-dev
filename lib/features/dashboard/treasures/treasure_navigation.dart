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
                        zoom: 15,
                      ),
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      compassEnabled: true,
                      markers: controller.markers,
                      polylines: controller.polylines,
                      onMapCreated: controller.onMapCreated,
                    ),
                  SafeArea(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          child: Row(
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
                        ),
                        if (controller.isLocationAllowed)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.light,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x22000000),
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controller.nextInstruction,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Next turn in ${controller.nextTurnDistanceText}',
                                    style: AppTextStyles.bodySmall,
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 12,
                                    runSpacing: 4,
                                    children: [
                                      Text(
                                        'Distance: ${controller.remainingDistanceText}',
                                        style: AppTextStyles.bodySmall,
                                      ),
                                      Text(
                                        'Time: ${controller.remainingDurationText}',
                                        style: AppTextStyles.bodySmall,
                                      ),
                                      Text(
                                        'ETA: ${controller.etaText}',
                                        style: AppTextStyles.bodySmall,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (controller.isRerouting)
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
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
                      ],
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
