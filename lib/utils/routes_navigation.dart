import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:google_navigation_flutter/google_navigation_flutter.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_snackbar.dart';
import 'package:tesoro_nft_app/enums/snack_bar_enums.dart';

class RoutesNavigation {
  static Future<void> startMapsNavigation(
      BuildContext context, List<dynamic> lating) async {
    try {
      await GoogleMapsNavigator.initializeNavigationSession(
          taskRemovedBehavior: TaskRemovedBehavior.continueService);
      await GoogleMapsNavigator.setDestinations(Destinations(
          waypoints: [
            NavigationWaypoint(
              title: 'Samanabad',
              target: LatLng(latitude: lating[0], longitude: lating[1]),
            ),
            // NavigationWaypoint(
            //   title: 'Samanabad',
            //   target: LatLng(latitude: 31.5498764, longitude: 74.2903985),
            // ),
          ],
          displayOptions:
              NavigationDisplayOptions(showDestinationMarkers: true)));
      await GoogleMapsNavigator.startGuidance();
      // await GoogleMapsNavigator.setOnArrivalListener(OnArrivalEventCallback())
    } on MapStyleException catch (e) {
      CustomSnackbar()
          .showSnackbar(SnackBarEnums.failed, e.toString(), context);
      log('Error: ${e.toString()}');
    }
  }
}
