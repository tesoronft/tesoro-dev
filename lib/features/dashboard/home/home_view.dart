import 'dart:developer';

import 'package:flutter/material.dart';

// import 'package:google_navigation_flutter/google_navigation_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/consts/app_images.dart';
import 'package:tesoro_nft_app/consts/app_text_styles.dart';
import 'package:tesoro_nft_app/custom_widgets/home_center_arrow.dart';
import 'package:tesoro_nft_app/custom_widgets/loader_widget.dart';
import 'package:tesoro_nft_app/enums/api_enums.dart';
import 'package:tesoro_nft_app/enums/permission_state_enums.dart';
import 'package:tesoro_nft_app/providers/api_provider.dart';
import 'package:tesoro_nft_app/providers/dashboard_provider.dart';
import 'package:tesoro_nft_app/providers/preferences_provider.dart';
import '../../../custom_widgets/custom_snackbar.dart';
import '../../../custom_widgets/dialogs/treasure_preview.dart';
import '../../../custom_widgets/permission_enable_component.dart';
import '../../../enums/snack_bar_enums.dart';
import '../../../routes/routes.dart';
import '../../../utils/app_permissions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with WidgetsBindingObserver {
  double? longitude, latitude;
  GoogleMapController? _controller; // Official controller
  bool _isPermissionResolved = false;

  Future<void> _initializeHomeData() async {
    final permissions = context.read<AppPermissions>();
    final api = context.read<ApiProvider>();
    final prefs = context.read<PreferencesProvider>();

    await permissions.checkLocationPermission();

    if (permissions.isLocationAllowed) {
      final position = await permissions.getCurrentPosition();
      if (position != null) {
        await api.getMarkers(
          prefs.accessToken ?? '',
          1,
          position.longitude,
          position.latitude,
          10,
        );
      }
    }

    if (!mounted) return;
    setState(() => _isPermissionResolved = true);
  }

  double? _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  List<Marker> _buildMarkers(ApiProvider api, PreferencesProvider prefs) {
    final fetchedMarkers = api.allMarkers?.markersModel ?? [];

    return fetchedMarkers
        .map((markerData) {
          final coordinates = markerData.coordinated;
          if (coordinates == null || coordinates.length < 2) return null;

          // Backend provides [longitude, latitude]
          final longitude = _toDouble(coordinates[0]);
          final latitude = _toDouble(coordinates[1]);

          if (longitude == null || latitude == null) return null;

          final markerIdValue = markerData.id ?? '${latitude}_$longitude';
          return Marker(
            icon: AssetMapBitmap(AppImages.mark, width: 30, height: 30),
            markerId: MarkerId(markerIdValue),
            position: LatLng(latitude, longitude),
            onTap: () async {
              log(markerIdValue);
              log(markerData.id ?? '');
              final result = await api.getTreasureData(
                  markerData.id ?? '', prefs.accessToken ?? '');
              if (result == ApiEnums.success) {
                CustomSnackbar().showSnackbar(SnackBarEnums.success,
                    api.responseTxt, navigatorKey.currentContext ?? context);

                showDialog(
                    context: navigatorKey.currentContext ?? context,
                    builder: (context) =>
                        TreasurePreview(treasure: api.treasureGetModel!));
              } else {
                CustomSnackbar().showSnackbar(SnackBarEnums.failed,
                    api.responseTxt, navigatorKey.currentContext ?? context);
              }
            },
          );
        })
        .whereType<Marker>()
        .toList();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeHomeData();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final permissions = context.watch<AppPermissions>();
    final api = context.watch<ApiProvider>();
    final prefs = context.watch<PreferencesProvider>();
    final mapMarkers = _buildMarkers(api, prefs);

    final showPermissionBanner =
        _isPermissionResolved && !permissions.isLocationAllowed;
    final showMap = _isPermissionResolved && permissions.isLocationAllowed;

    return Scaffold(
      backgroundColor: AppColors.light,
      appBar: AppBar(
        toolbarHeight: 90,
        backgroundColor: AppColors.primary,
        title: Image.asset(AppImages.transparantLogo, height: 60, width: 60),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leadingWidth: 100,
        leading: InkWell(
          onTap: () => context.read<DashboardProvider>().updateIndex(2),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.light,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 3,
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            margin: const EdgeInsets.symmetric(vertical: 25, horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.paid, color: AppColors.primary, size: 24),
                Text(
                  ' ${api.userProfile?.tipReceived}',
                  style: AppTextStyles.bodyLarge
                      .copyWith(color: const Color(0xff666666)),
                ),
              ],
            ),
          ),
        ),
        actions: [
          InkWell(
            onTap: () async {
              await api.getMarkers(
                prefs.accessToken ?? '',
                1,
                permissions.position?.longitude ?? 0.0,
                permissions.position?.latitude ?? 0.0,
                10,
              );

              await _controller?.animateCamera(
                CameraUpdate.newLatLng(
                  LatLng(
                    permissions.position?.latitude ?? 0.0,
                    permissions.position?.longitude ?? 0.0,
                  ),
                ),
              );
            },
            child: Card(
              color: AppColors.light,
              elevation: 2,
              child: Padding(
                padding: EdgeInsets.all(6.0),
                child: Icon(Icons.loop),
              ),
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          if (showMap) ...[
            StableGoogleMap(
              controllerCallback: (c) => _controller = c,
              markers: mapMarkers,
            ),
            const Align(
              alignment: Alignment.centerRight,
              child: HomeCenterArrow(isForHome: true),
            ),
          ],
          if (showPermissionBanner)
            Align(
              alignment: Alignment.bottomCenter,
              child: PermissionEnableComponent(
                onTap: () async {
                  final status = await context
                      .read<AppPermissions>()
                      .requestLocationPermission();

                  if (status == PermissionState.granted) {
                    if (!mounted) return;
                    setState(() => _isPermissionResolved = false);
                    await _initializeHomeData();
                    return;
                  }

                  await context.read<AppPermissions>().openLocationSettings();
                },
              ),
            ),
          if (!_isPermissionResolved) const Center(child: LoaderWidget()),
          Selector<ApiProvider, bool>(
            selector: (_, a) => a.isMarkerLoaded || a.getIsTreasureLoading,
            builder: (_, loading, __) => loading
                ? const Center(child: LoaderWidget())
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class StableGoogleMap extends StatefulWidget {
  final Function(GoogleMapController) controllerCallback;
  final List<Marker> markers;

  const StableGoogleMap({
    super.key,
    required this.controllerCallback,
    required this.markers,
  });

  @override
  State<StableGoogleMap> createState() => _StableGoogleMapState();
}

class _StableGoogleMapState extends State<StableGoogleMap> {
  bool _mapInitialized = false;
  LatLng? _initialPosition;

  @override
  void initState() {
    super.initState();
    final permissions = context.read<AppPermissions>();
    _initialPosition = LatLng(
      permissions.position?.latitude ?? 0.0,
      permissions.position?.longitude ?? 0.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: _initialPosition ?? const LatLng(0, 0),
        zoom: 15,
      ),
      // Convert List to Set for the official package
      markers: widget.markers.toSet(),
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      onMapCreated: (GoogleMapController controller) {
        if (_mapInitialized) return;
        _mapInitialized = true;
        widget.controllerCallback(controller);
      },
    );
  }
}
