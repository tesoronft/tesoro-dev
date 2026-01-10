import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_navigation_flutter/google_navigation_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_scaffold.dart';
import 'package:tesoro_nft_app/custom_widgets/popup_button.dart';
import 'package:tesoro_nft_app/routes/routes.dart';
import 'package:tesoro_nft_app/utils/app_permissions.dart';
import 'package:tesoro_nft_app/utils/routes_navigation.dart';

class TreasureNavigation extends StatefulWidget {
  const TreasureNavigation({super.key, required this.lating});
  final List<dynamic> lating;

  @override
  State<TreasureNavigation> createState() => _TreasureNavigationState();
}

class _TreasureNavigationState extends State<TreasureNavigation> {
  GoogleNavigationViewController? _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // await RoutesNavigation.startMapsNavigation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppPermissions>(
      builder: (context, permissions, child) => CustomScaffold(
        backgroundColor: AppColors.light,
        child: Column(
          children: [
            Container(
                height: 50,
                //width: 100,
                decoration: BoxDecoration(color: AppColors.light),
                alignment: Alignment.bottomLeft,
                padding: EdgeInsets.only(left: 20),
                child: SafeArea(
                    child: IconButton(
                        onPressed: () async {
                          await GoogleMapsNavigator.stopGuidance();
                          await GoogleMapsNavigator.clearDestinations();
                          context.go(Routes.dashboard);
                        },
                        icon: Icon(Icons.arrow_back)))),
            Expanded(
              child: SafeArea(
                child: GoogleMapsNavigationView(
                  initialCameraPosition: CameraPosition(
                      target: LatLng(
                    latitude: permissions.position?.latitude ?? 0.0,
                    longitude: permissions.position?.longitude ?? 0.0,
                  )),
                  onViewCreated: (controller) async {
                    _controller = controller;

                    await _controller?.setMyLocationEnabled(true);
                    await RoutesNavigation.startMapsNavigation(
                        context, widget.lating);
                  },
                  initialNavigationUIEnabledPreference:
                      NavigationUIEnabledPreference.automatic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
