import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_navigation_flutter/google_navigation_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/consts/app_images.dart';
import 'package:tesoro_nft_app/consts/app_text_styles.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_snackbar.dart';
import 'package:tesoro_nft_app/custom_widgets/loader_widget.dart';
import 'package:tesoro_nft_app/enums/api_enums.dart';
import 'package:tesoro_nft_app/enums/snack_bar_enums.dart';
import 'package:tesoro_nft_app/providers/api_provider.dart';
import 'package:tesoro_nft_app/providers/preferences_provider.dart';
import 'package:tesoro_nft_app/routes/routes.dart';
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
      final prefs = Provider.of<PreferencesProvider>(context, listen: false);
      if (markers.userProfile == null) {
        final result = await markers.getUserData(prefs.accessToken ?? '');
      }

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

  final ValueNotifier<List<Marker?>?> allmarkers =
      ValueNotifier<List<Marker?>?>([]);
  GoogleMapViewController? _controller;

//AIzaSyCFTwfbaMCWckrykb-e5U4ki0Wm4RFm6po
  @override
  Widget build(BuildContext context) {
    return Consumer3<AppPermissions, ApiProvider, PreferencesProvider>(
      builder: (context, permissions, api, prefs, child) => Scaffold(
        backgroundColor: AppColors.light,
        appBar: AppBar(
          toolbarHeight: 90,
          backgroundColor: AppColors.light,
          title: Image.asset(
            AppImages.logo,
            height: 70,
            width: 70,
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leadingWidth: 100,
          leading: Container(
            decoration: BoxDecoration(
                border: Border.all(
                    color: Color(
                      0xff666666,
                    ),
                    width: 0)),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 2),
            margin: EdgeInsets.symmetric(vertical: 25, horizontal: 5),
            child: Text(
              '\$ ${api.userProfile?.tipReceived}',
              style: AppTextStyles.bodyLarge.copyWith(color: Color(0xff666666)),
            ),
          ),
          actions: [
            InkWell(
                onTap: () =>
                    _controller?.moveCamera(CameraUpdate.newLatLng(LatLng(
                      longitude: permissions.position?.longitude ?? 0.0,
                      latitude: permissions.position?.latitude ?? 0.0,
                    ))),
                child: Card(
                    color: AppColors.light,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Icon(Icons.loop),
                    )))
          ],
        ),
        body: Stack(
          children: [
            ValueListenableBuilder(
                valueListenable: allmarkers,
                builder: (context, mark, child) {
                  return Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),
                    clipBehavior: Clip.antiAlias,
                    child: GoogleMapsMapView(
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
                      onMarkerClicked: (markerId) async {
                        log(markerId);
                        // final marker = allmarkers.value?.firstWhere(
                        //     (marker) => markerId == marker?.markerId);
                        String numericId =
                            markerId.replaceAll(RegExp(r'[^0-9]'), '');
                        int index = int.parse(numericId);

                        final clickedMarker =
                            api.allMarkers?.markersModel?[index];
                        final result = await api.getTreasureData(
                            clickedMarker?.id ?? '', prefs.accessToken ?? '');
                        if (result == ApiEnums.success) {
                          CustomSnackbar().showSnackbar(
                              SnackBarEnums.success, api.responseTxt, context);
                          context.push(Routes.treasureDetails,
                              extra: api.treasureGetModel);
                        } else {
                          CustomSnackbar().showSnackbar(
                              SnackBarEnums.failed, api.responseTxt, context);
                        }
                      },
                      onMyLocationButtonClicked: (events) => false,
                      onViewCreated: (controller) async {
                        _controller = controller;

                        await _controller?.setMyLocationEnabled(true);

                        allmarkers.value = await _controller?.addMarkers(
                            List.generate(
                                api.allMarkers?.markersModel?.length ?? 0,
                                (index) => MarkerOptions(
                                    icon: ImageDescriptor(
                                        registeredImageId: AppImages.mark),
                                    position: LatLng(
                                      latitude: api
                                              .allMarkers
                                              ?.markersModel?[index]
                                              .coordinated?[1] ??
                                          31.5357,
                                      longitude: api
                                              .allMarkers
                                              ?.markersModel?[index]
                                              .coordinated?[0] ??
                                          74.2985,
                                    ))));
                      },
                    ),
                  );
                }),
            permissions.placemark == null || permissions.position == null
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: PermissionEnableComponent())
                : SizedBox.shrink(),
            if (api.isLoading) Center(child: LoaderWidget())
          ],
        ),
      ),
    );
  }
}
