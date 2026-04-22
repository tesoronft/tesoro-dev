import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/models/treasures/treasure_get_model.dart';
import 'package:tesoro_nft_app/utils/routes_navigation.dart';

class NavigationRoutingService {
  Future<RouteInfo> fetchRoute({
    required LatLng origin,
    required LatLng destination,
  }) {
    return RoutesNavigation.fetchDrivingRoute(
      origin: origin,
      destination: destination,
    );
  }

  Set<Polyline> buildRoutePolylines(List<LatLng> routePoints) {
    return {
      Polyline(
        polylineId: const PolylineId('journey_route'),
        points: routePoints,
        width: 6,
        color: AppColors.dialogBtn,
      ),
    };
  }

  Set<Marker> buildMarkers({
    required TreasureGetModel treasure,
    required LatLng destination,
    LatLng? currentPosition,
  }) {
    final markers = <Marker>{
      Marker(
        markerId: const MarkerId('destination'),
        position: destination,
        infoWindow: InfoWindow(
          title: treasure.title ?? 'Destination',
          snippet: treasure.location?.address ?? '',
        ),
      ),
    };

    if (currentPosition != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('current_position'),
          position: currentPosition,
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          infoWindow: const InfoWindow(title: 'You'),
        ),
      );
    }

    return markers;
  }

  double remainingDistanceMeters({
    required LatLng current,
    required List<LatLng> routePoints,
  }) {
    return RoutesNavigation.remainingDistanceMeters(current, routePoints);
  }

  Duration estimateRemainingDuration({
    required int totalDurationSeconds,
    required int totalDistanceMeters,
    required double remainingDistanceMeters,
  }) {
    return RoutesNavigation.estimateRemainingDuration(
      totalDurationSeconds: totalDurationSeconds,
      totalDistanceMeters: totalDistanceMeters,
      remainingDistanceMeters: remainingDistanceMeters,
    );
  }

  bool hasReachedDestination({
    required LatLng current,
    required LatLng destination,
  }) {
    return RoutesNavigation.hasReachedDestination(current, destination);
  }

  double distanceFromRouteMeters({
    required LatLng current,
    required List<LatLng> routePoints,
  }) {
    return RoutesNavigation.distanceFromRouteMeters(current, routePoints);
  }

  RouteStep? pickNextStep({
    required LatLng current,
    required List<RouteStep> routeSteps,
  }) {
    if (routeSteps.isEmpty) return null;

    int selectedIndex = 0;
    for (int i = 0; i < routeSteps.length; i++) {
      final distanceToEnd = Geolocator.distanceBetween(
        current.latitude,
        current.longitude,
        routeSteps[i].endLocation.latitude,
        routeSteps[i].endLocation.longitude,
      );
      if (distanceToEnd > 10) {
        selectedIndex = i;
        break;
      }
      selectedIndex = i;
    }
    return routeSteps[selectedIndex];
  }

  double distanceToStepStartMeters({
    required LatLng current,
    required RouteStep? nextStep,
  }) {
    if (nextStep == null) return 0.0;

    return Geolocator.distanceBetween(
      current.latitude,
      current.longitude,
      nextStep.startLocation.latitude,
      nextStep.startLocation.longitude,
    );
  }

  String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final mins = duration.inMinutes.remainder(60);
    if (hours <= 0) return '${duration.inMinutes} min';
    return '${hours}h ${mins}m';
  }

  String formatDistance(double meters) {
    if (meters < 1000) return '${meters.round()} m';
    return '${(meters / 1000).toStringAsFixed(1)} km';
  }

  String formatEta(Duration remainingDuration) {
    return DateFormat('h:mm a').format(DateTime.now().add(remainingDuration));
  }

  LatLngBounds? computeBounds(List<LatLng> routePoints) {
    if (routePoints.isEmpty) return null;

    double minLat = routePoints.first.latitude;
    double maxLat = routePoints.first.latitude;
    double minLng = routePoints.first.longitude;
    double maxLng = routePoints.first.longitude;

    for (final point in routePoints) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }
}
