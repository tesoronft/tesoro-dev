// import 'dart:developer';

// import 'package:flutter/material.dart';

// import 'package:google_navigation_flutter/google_navigation_flutter.dart';
// import 'package:provider/provider.dart';
// import 'package:tesoro_nft_app/custom_widgets/custom_snackbar.dart';
// import 'package:tesoro_nft_app/enums/snack_bar_enums.dart';
// import 'package:tesoro_nft_app/models/treasures/treasure_get_model.dart';
// import 'package:tesoro_nft_app/providers/preferences_provider.dart';

// import '../custom_widgets/dialogs/just_actions_dialogs.dart';

// class RoutesNavigation {
//   static Future<void> startMapsNavigation(
//       BuildContext context, TreasureGetModel treasure) async {
//     log(treasure.location!.coordinates.toString());
//     try {
//       await GoogleMapsNavigator.initializeNavigationSession(
//           taskRemovedBehavior: TaskRemovedBehavior.continueService);
//       await GoogleMapsNavigator.setDestinations(Destinations(
//           waypoints: [
//             NavigationWaypoint(
//               title: treasure.location?.address ?? '',
//               target: LatLng(
//                 latitude: treasure.location?.coordinates?[1],
//                 longitude: treasure.location?.coordinates?[0],
//               ),
//             ),
//           ],
//           displayOptions:
//               NavigationDisplayOptions(showDestinationMarkers: true)));
//       await GoogleMapsNavigator.startGuidance();

//       GoogleMapsNavigator.setOnArrivalListener((event) async {
//         await GoogleMapsNavigator.stopGuidance();
//         await showAllDialogs(context,
//             context.read<PreferencesProvider>().userId ?? '', treasure);
//       });
//     } on MapStyleException catch (e) {
//       CustomSnackbar()
//           .showSnackbar(SnackBarEnums.failed, e.toString(), context);
//       log('Error: ${e.toString()}');
//     }
//   }
// }
