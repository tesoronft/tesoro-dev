import 'dart:developer';
import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_navigation_flutter/google_navigation_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/consts/app_images.dart';
import 'package:tesoro_nft_app/consts/app_text_styles.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_snackbar.dart';
import 'package:tesoro_nft_app/custom_widgets/dialogs/treasure_preview.dart';
import 'package:tesoro_nft_app/custom_widgets/home_center_arrow.dart';
import 'package:tesoro_nft_app/custom_widgets/loader_widget.dart';
import 'package:tesoro_nft_app/enums/api_enums.dart';
import 'package:tesoro_nft_app/enums/snack_bar_enums.dart';
import 'package:tesoro_nft_app/providers/api_provider.dart';
import 'package:tesoro_nft_app/providers/dashboard_provider.dart';
import 'package:tesoro_nft_app/providers/preferences_provider.dart';
import 'package:tesoro_nft_app/routes/routes.dart';
import '../../../custom_widgets/permission_enable_component.dart';
import '../../../utils/app_permissions.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with WidgetsBindingObserver {
  double? longitude, latitude;
  final ValueNotifier<List<Marker?>?> allmarkers =
      ValueNotifier<List<Marker?>?>([]);
  GoogleMapViewController? _controller;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    //WidgetsBinding.instance.addPostFrameCallback((_) async {});
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) async {
  //   if (state == AppLifecycleState.hidden) return;

  //   final geoLocation = Provider.of<AppPermissions>(context, listen: false);
  //   log('Checking location permissions on app resume');
  //   if (geoLocation.isLocationAllowed == false) {
  //     final position = await geoLocation.getCurrentPosition();
  //     await geoLocation.getCurrentPlacemark();

  //     if (!mounted) return;

  //     await _controller?.animateCamera(
  //       CameraUpdate.newLatLng(
  //         LatLng(
  //           latitude: position?.latitude ?? 0.0,
  //           longitude: position?.longitude ?? 0.0,
  //         ),
  //       ),
  //     );
  //   }
  // }

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
          leading: InkWell(
            onTap: () => context.read<DashboardProvider>().updateIndex(2),
            child: Container(
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
                style:
                    AppTextStyles.bodyLarge.copyWith(color: Color(0xff666666)),
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
                      10);
                  await _controller
                      ?.animateCamera(CameraUpdate.newLatLng(LatLng(
                    longitude: permissions.position?.longitude ?? 0.0,
                    latitude: permissions.position?.latitude ?? 0.0,
                  )));
                },
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
                        zoom: 15,
                      ),
                      initialMinZoomPreference: 2,
                      initialMaxZoomPreference: 21.0,
                      onCameraIdle: (position) async {
                        double currentZoom = position.zoom;
                        final currentPage =
                            api.allMarkers?.pagination?.page ?? 1;

                        final nextPage =
                            api.allMarkers?.pagination?.totalPages ?? 1;
                        final latDiff =
                            (position.target.latitude - (latitude ?? 0.0))
                                .abs();
                        final lngDiff =
                            (position.target.longitude - (longitude ?? 0.0))
                                .abs();
                        double dynamicThreshold =
                            0.1 / Math.pow(2, currentZoom - 10);

                        if ((latDiff > dynamicThreshold ||
                                lngDiff > dynamicThreshold) &&
                            currentPage < nextPage) {
                          debugPrint(
                              "Threshold met: Moving from Gulshan-e-Ravi towards Samanabad area.");

                          latitude = position.target.latitude;
                          longitude = position.target.longitude;
                          // await Future.wait([
                          //   api.getMarkers(
                          //     prefs.accessToken ?? '',
                          //     (api.allMarkers?.pagination?.page ?? 0) + 1,
                          //     position.target.longitude,
                          //     position.target.latitude,
                          //     10,
                          //   ),
                          //   rootBundle.load(AppImages.mark),
                          // ]);

                          // await updateMapMarkers(api, position.target.latitude,
                          //     position.target.longitude);
                        }
                      },
                      onMarkerClicked: (markerId) async {
                        log(markerId);

                        String numericId =
                            markerId.replaceAll(RegExp(r'[^0-9]'), '');
                        int index = int.parse(numericId);

                        final clickedMarker =
                            api.allMarkers?.markersModel?[index];

                        final result = await api.getTreasureData(
                            clickedMarker?.id ?? '', prefs.accessToken ?? '');
                        if (result == ApiEnums.success) {
                          CustomSnackbar().showSnackbar(
                              SnackBarEnums.success,
                              api.responseTxt,
                              navigatorKey.currentContext ?? context);

                          showDialog(
                              context: navigatorKey.currentContext ?? context,
                              builder: (context) => TreasurePreview(
                                  treasure: api.treasureGetModel!));
                        } else {
                          CustomSnackbar().showSnackbar(
                              SnackBarEnums.failed,
                              api.responseTxt,
                              navigatorKey.currentContext ?? context);
                        }
                      },
                      onMyLocationButtonClicked: (events) => false,
                      onViewCreated: (controller) async {
                        try {
                          await permissions.getCurrentPosition();

                          await Future.wait([
                            api.getMarkers(
                              prefs.accessToken ?? '',
                              1,
                              permissions.position?.longitude ?? 0.0,
                              permissions.position?.latitude ?? 0.0,
                              10,
                            ),
                            rootBundle.load(AppImages.mark),
                          ]);

                          _controller = controller;
                          await _controller?.setMyLocationEnabled(true);

                          await updateMapMarkers(
                              api,
                              permissions.position?.latitude,
                              permissions.position?.longitude);

                          await _controller?.moveCamera(CameraUpdate.newLatLng(
                            LatLng(
                              longitude: permissions.position?.longitude ?? 0.0,
                              latitude: permissions.position?.latitude ?? 0.0,
                            ),
                          ));
                        } catch (e) {
                          debugPrint("Error initializing map: $e");
                          CustomSnackbar().showSnackbar(
                              SnackBarEnums.failed, e.toString(), context);
                        }
                      },
                    ),
                  );
                }),
            Align(
                alignment: Alignment.centerRight,
                child: HomeCenterArrow(
                  isForHome: true,
                )),
            !permissions.isLocationAllowed
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

  Future<void> updateMapMarkers(
      ApiProvider api, double? newLat, double? newLong) async {
    final customMarker = await registerBitmapImage(
      bitmap: await rootBundle.load(AppImages.mark),
      height: 30,
      width: 30,
    );
    if (_controller == null || customMarker.registeredImageId == null) return;

    final markers = List.generate(
      api.allMarkers?.markersModel?.length ?? 0,
      (index) => MarkerOptions(
        icon: ImageDescriptor(
          registeredImageId: customMarker.registeredImageId!,
          imagePixelRatio: 46,
          width: 30,
          height: 30,
        ),
        position: LatLng(
          latitude: api.allMarkers?.markersModel?[index].coordinated?[1] ?? 0.0,
          longitude:
              api.allMarkers?.markersModel?[index].coordinated?[0] ?? 0.0,
        ),
      ),
    );

    allmarkers.value = await _controller?.addMarkers(markers);
  }
}
