import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class RouteStep {
  RouteStep({
    required this.instruction,
    required this.maneuver,
    required this.distanceText,
    required this.durationText,
    required this.distanceMeters,
    required this.durationSeconds,
    required this.startLocation,
    required this.endLocation,
  });

  final String instruction;
  final String maneuver;
  final String distanceText;
  final String durationText;
  final int distanceMeters;
  final int durationSeconds;
  final LatLng startLocation;
  final LatLng endLocation;
}

class RouteInfo {
  RouteInfo({
    required this.polylinePoints,
    required this.steps,
    required this.distanceText,
    required this.durationText,
    required this.distanceMeters,
    required this.durationSeconds,
  });

  final List<LatLng> polylinePoints;
  final List<RouteStep> steps;
  final String distanceText;
  final String durationText;
  final int distanceMeters;
  final int durationSeconds;
}

class RoutesNavigation {
  static const String _directionsApiKey = String.fromEnvironment(
    'GOOGLE_MAPS_API_KEY',
    defaultValue: 'AIzaSyBQkY_W4n-xFQZDb5NWXXYY99RM7vm-NaY',
  );

  static Future<RouteInfo> fetchDrivingRoute({
    required LatLng origin,
    required LatLng destination,
  }) async {
    final uri = Uri.https('maps.googleapis.com', '/maps/api/directions/json', {
      'origin': '${origin.latitude},${origin.longitude}',
      'destination': '${destination.latitude},${destination.longitude}',
      'mode': 'driving',
      'alternatives': 'false',
      'key': _directionsApiKey,
    });

    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Directions request failed: ${response.statusCode}');
    }

    final payload = jsonDecode(response.body) as Map<String, dynamic>;
    final status = payload['status']?.toString() ?? '';
    if (status != 'OK') {
      throw Exception(payload['error_message']?.toString() ?? status);
    }

    final routes = payload['routes'] as List<dynamic>;
    if (routes.isEmpty) {
      throw Exception('No route found');
    }

    final route = routes.first as Map<String, dynamic>;
    final legs = route['legs'] as List<dynamic>;
    if (legs.isEmpty) {
      throw Exception('No route leg found');
    }
    final leg = legs.first as Map<String, dynamic>;

    final steps = (leg['steps'] as List<dynamic>)
        .map((rawStep) => _parseStep(rawStep as Map<String, dynamic>))
        .toList();

    final encodedPolyline =
        (route['overview_polyline'] as Map<String, dynamic>)['points']
            .toString();

    final distance = leg['distance'] as Map<String, dynamic>;
    final duration = leg['duration'] as Map<String, dynamic>;

    return RouteInfo(
      polylinePoints: _decodePolyline(encodedPolyline),
      steps: steps,
      distanceText: distance['text']?.toString() ?? '--',
      durationText: duration['text']?.toString() ?? '--',
      distanceMeters: (distance['value'] as num?)?.toInt() ?? 0,
      durationSeconds: (duration['value'] as num?)?.toInt() ?? 0,
    );
  }

  static RouteStep _parseStep(Map<String, dynamic> step) {
    final distance = step['distance'] as Map<String, dynamic>;
    final duration = step['duration'] as Map<String, dynamic>;
    final start = step['start_location'] as Map<String, dynamic>;
    final end = step['end_location'] as Map<String, dynamic>;

    final instructionRaw = step['html_instructions']?.toString() ?? '';

    return RouteStep(
      instruction: _stripHtml(instructionRaw),
      maneuver: step['maneuver']?.toString() ?? '',
      distanceText: distance['text']?.toString() ?? '--',
      durationText: duration['text']?.toString() ?? '--',
      distanceMeters: (distance['value'] as num?)?.toInt() ?? 0,
      durationSeconds: (duration['value'] as num?)?.toInt() ?? 0,
      startLocation: LatLng(
        (start['lat'] as num).toDouble(),
        (start['lng'] as num).toDouble(),
      ),
      endLocation: LatLng(
        (end['lat'] as num).toDouble(),
        (end['lng'] as num).toDouble(),
      ),
    );
  }

  static String _stripHtml(String input) {
    return input
        .replaceAll(RegExp(r'<[^>]*>'), ' ')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  static bool hasReachedDestination(
    LatLng current,
    LatLng destination, {
    double thresholdMeters = 25,
  }) {
    return Geolocator.distanceBetween(
          current.latitude,
          current.longitude,
          destination.latitude,
          destination.longitude,
        ) <=
        thresholdMeters;
  }

  static double distanceFromRouteMeters(
    LatLng current,
    List<LatLng> routePoints,
  ) {
    if (routePoints.length < 2) return 0;

    double minDistance = double.infinity;
    for (int i = 0; i < routePoints.length; i++) {
      final p = routePoints[i];
      final distance = Geolocator.distanceBetween(
        current.latitude,
        current.longitude,
        p.latitude,
        p.longitude,
      );
      if (distance < minDistance) {
        minDistance = distance;
      }
    }
    return minDistance;
  }

  static int nearestRoutePointIndex(LatLng current, List<LatLng> routePoints) {
    if (routePoints.isEmpty) return 0;

    double minDistance = double.infinity;
    int nearestIndex = 0;

    for (int i = 0; i < routePoints.length; i++) {
      final p = routePoints[i];
      final distance = Geolocator.distanceBetween(
        current.latitude,
        current.longitude,
        p.latitude,
        p.longitude,
      );

      if (distance < minDistance) {
        minDistance = distance;
        nearestIndex = i;
      }
    }

    return nearestIndex;
  }

  static double remainingDistanceMeters(
    LatLng current,
    List<LatLng> routePoints,
  ) {
    if (routePoints.length < 2) return 0;

    final nearestIndex = nearestRoutePointIndex(current, routePoints);
    double total = 0;

    for (int i = nearestIndex; i < routePoints.length - 1; i++) {
      total += Geolocator.distanceBetween(
        routePoints[i].latitude,
        routePoints[i].longitude,
        routePoints[i + 1].latitude,
        routePoints[i + 1].longitude,
      );
    }

    return total;
  }

  static Duration estimateRemainingDuration({
    required int totalDurationSeconds,
    required int totalDistanceMeters,
    required double remainingDistanceMeters,
  }) {
    if (totalDistanceMeters <= 0 || totalDurationSeconds <= 0) {
      return Duration.zero;
    }

    final ratio =
        (remainingDistanceMeters / totalDistanceMeters).clamp(0.0, 1.0);
    final seconds = (totalDurationSeconds * ratio).round();
    return Duration(seconds: seconds);
  }

  static List<LatLng> _decodePolyline(String encoded) {
    final points = <LatLng>[];
    int index = 0;
    int lat = 0;
    int lng = 0;

    while (index < encoded.length) {
      int b;
      int shift = 0;
      int result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      final dLat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dLat;

      shift = 0;
      result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      final dLng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dLng;

      points.add(LatLng(lat / 1e5, lng / 1e5));
    }

    return points;
  }
}
