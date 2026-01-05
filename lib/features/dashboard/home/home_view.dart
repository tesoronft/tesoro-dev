import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_navigation_flutter/google_navigation_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_scaffold.dart';
import 'package:tesoro_nft_app/custom_widgets/loader_widget.dart';
import 'package:tesoro_nft_app/providers/api_provider.dart';
import 'package:tesoro_nft_app/providers/preferences_provider.dart';
import '../../../custom_widgets/permission_enable_component.dart';
import '../../../utils/app_permissions.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  double? longitude, latitude;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final geoLocation = Provider.of<AppPermissions>(context, listen: false);
      final markers = Provider.of<ApiProvider>(context, listen: false);

      final lat = await geoLocation.getCurrentPosition();
      log(lat?.latitude.toString() ?? '');
      log(lat?.longitude.toString() ?? '');
      await geoLocation.getCurrentPlacemark();
      await markers.getMarkers(
          context.read<PreferencesProvider>().accessToken ?? '',
          1,
          lat?.longitude ?? 0.0,
          lat?.latitude ?? 0.0,
          10);
    });
  }

  GoogleMapViewController? _controller;

//AIzaSyCFTwfbaMCWckrykb-e5U4ki0Wm4RFm6po
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: SafeArea(
        child: Consumer2<AppPermissions, ApiProvider>(
          builder: (context, permissions, api, child) => Stack(
            children: [
              GoogleMapsMapView(
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    longitude: permissions.position?.longitude ?? 0.0,
                    latitude: permissions.position?.latitude ?? 0.0,
                  ),
                  zoom: 12,
                ),
                //  initialMapType: MapType.hybrid,
                initialMinZoomPreference: 2.0,
                initialMaxZoomPreference: 21.0,
                onMarkerClicked: (markerId) {
                  log(markerId);
                },
                onMyLocationButtonClicked: (events) => false,
                onViewCreated: (controller) async {
                  _controller = controller;

                  await _controller?.setMyLocationEnabled(true);
                  final marker = await _controller!.addMarkers(List.generate(
                      api.allMarkers?.markersModel?.length ?? 0,
                      (index) => MarkerOptions(
                              position: LatLng(
                            latitude: api.allMarkers?.markersModel?[index]
                                    .coordinated?[0] ??
                                0.0,
                            longitude: api.allMarkers?.markersModel?[index]
                                    .coordinated?[1] ??
                                0.0,
                          ))));
                },
              ),
              permissions.placemark == null || permissions.position == null
                  ? Align(
                      alignment: Alignment.bottomCenter,
                      child: PermissionEnableComponent())
                  : SizedBox.shrink(),
              if (api.isLoading) Center(child: LoaderWidget())
            ],
          ),
        ),
      ),
    );
  }
}
