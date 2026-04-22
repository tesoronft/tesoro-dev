// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:google_navigation_flutter/google_navigation_flutter.dart';
// import 'package:provider/provider.dart';
// import 'package:tesoro_nft_app/consts/app_colors.dart';
// import 'package:tesoro_nft_app/custom_widgets/custom_scaffold.dart';
// import 'package:tesoro_nft_app/models/treasures/treasure_get_model.dart';
// import 'package:tesoro_nft_app/utils/app_permissions.dart';
// import 'package:tesoro_nft_app/utils/routes_navigation.dart';

// class TreasureNavigation extends StatefulWidget {
//   const TreasureNavigation({
//     super.key,
//     required this.treasureGetModel,
//   });

//   final TreasureGetModel treasureGetModel;

//   @override
//   State<TreasureNavigation> createState() => _TreasureNavigationState();
// }

// class _TreasureNavigationState extends State<TreasureNavigation>
//     with WidgetsBindingObserver {
//   GoogleNavigationViewController? _controller;
//   bool _navigationStarted = false;
//   bool _navigationStopped = false; // ✅ prevent double-stop
//   LatLng? _initialPosition; // ✅ captured once
//   late final Widget _navigationView; // ✅ built once

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);

//     // ✅ Capture position once — never read live GPS again
//     final permissions = context.read<AppPermissions>();
//     _initialPosition = LatLng(
//       latitude: permissions.position?.latitude ?? 0.0,
//       longitude: permissions.position?.longitude ?? 0.0,
//     );

//     // ✅ Build the navigation view once and cache it
//     _navigationView = GoogleMapsNavigationView(
//       initialCameraPosition: CameraPosition(
//         target: _initialPosition!,
//       ),
//       initialNavigationUIEnabledPreference:
//           NavigationUIEnabledPreference.automatic,
//       onViewCreated: (controller) async {
//         _controller = controller;
//         await _controller?.setMyLocationEnabled(true);

//         if (_navigationStarted) return;
//         _navigationStarted = true;

//         await RoutesNavigation.startMapsNavigation(
//           context,
//           widget.treasureGetModel,
//         );
//       },
//     );
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.paused ||
//         state == AppLifecycleState.inactive) {
//       _stopNavigation();
//     }
//     // ✅ Resume guidance when app comes back to foreground
//     if (state == AppLifecycleState.resumed && _navigationStarted) {
//       GoogleMapsNavigator.startGuidance().catchError(
//         (e) => debugPrint("Resume guidance error: $e"),
//       );
//     }
//   }

//   Future<void> _stopNavigation() async {
//     // ✅ Guard against double-stop
//     if (_navigationStopped) return;
//     _navigationStopped = true;

//     try {
//       await GoogleMapsNavigator.stopGuidance();
//       await GoogleMapsNavigator.clearDestinations();
//     } catch (e) {
//       debugPrint("Navigation stop error: $e");
//     }
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     // ✅ Still call it but guarded by _navigationStopped flag
//     _stopNavigation();
//     _controller = null;
//     super.dispose();
//   }

//   Future<void> _onBackPressed() async {
//     await _stopNavigation();
//     if (mounted) context.pop();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // ✅ No Consumer wrapping the whole screen
//     // ✅ No live GPS flowing into build
//     return CustomScaffold(
//       backgroundColor: AppColors.light,
//       child: Column(
//         children: [
//           Container(
//             height: 50,
//             width: double.infinity,
//             alignment: Alignment.bottomLeft,
//             padding: const EdgeInsets.only(left: 20),
//             child: IconButton(
//               onPressed: _onBackPressed,
//               icon: const SafeArea(
//                 child: Icon(Icons.arrow_back, size: 28),
//               ),
//             ),
//           ),

//           // ✅ Cached map widget — never rebuilt
//           Expanded(
//             child: SafeArea(
//               child: _navigationView,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
