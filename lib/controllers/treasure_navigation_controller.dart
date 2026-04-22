import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tesoro_nft_app/controllers/navigation/navigation_live_tracking_service.dart';
import 'package:tesoro_nft_app/controllers/navigation/navigation_routing_service.dart';
import 'package:tesoro_nft_app/enums/permission_state_enums.dart';
import 'package:tesoro_nft_app/models/treasures/treasure_get_model.dart';
import 'package:tesoro_nft_app/utils/app_permissions.dart';
import 'package:tesoro_nft_app/utils/routes_navigation.dart';

typedef OnNavigationArrived = Future<void> Function();

class TreasureNavigationController extends ChangeNotifier {
  TreasureNavigationController({
    required this.treasure,
    required this.onArrived,
    NavigationRoutingService? routingService,
    NavigationLiveTrackingService? liveTrackingService,
  })  : _routingService = routingService ?? NavigationRoutingService(),
        _liveTrackingService =
            liveTrackingService ?? NavigationLiveTrackingService();

  final TreasureGetModel treasure;
  final OnNavigationArrived onArrived;
  final NavigationRoutingService _routingService;
  final NavigationLiveTrackingService _liveTrackingService;

  GoogleMapController? _mapController;

  final Set<Marker> _markers = <Marker>{};
  final Set<Polyline> _polylines = <Polyline>{};

  List<LatLng> _routePoints = <LatLng>[];
  List<RouteStep> _routeSteps = <RouteStep>[];

  LatLng? _currentPosition;
  LatLng? _destination;

  String _totalDistanceText = '--';
  String _remainingDistanceText = '--';
  String _remainingDurationText = '--';
  String _etaText = '--';
  String _nextInstruction = 'Preparing route...';
  String _nextTurnDistanceText = '--';

  bool _isLocationAllowed = true;
  bool _isLoading = true;
  bool _isRerouting = false;
  bool _hasArrived = false;
  bool _isNavigationStopped = false;
  bool _isDisposed = false;

  DateTime _lastRerouteAt = DateTime.fromMillisecondsSinceEpoch(0);

  Set<Marker> get markers => _markers;
  Set<Polyline> get polylines => _polylines;
  LatLng? get currentPosition => _currentPosition;

  String get remainingDistanceText => _remainingDistanceText;
  String get remainingDurationText => _remainingDurationText;
  String get etaText => _etaText;
  String get nextInstruction => _nextInstruction;
  String get nextTurnDistanceText => _nextTurnDistanceText;

  bool get isLocationAllowed => _isLocationAllowed;
  bool get isLoading => _isLoading;
  bool get isRerouting => _isRerouting;

  Future<void> initializeNavigation(AppPermissions permissions) async {
    _isNavigationStopped = false;
    _hasArrived = false;

    final permissionState = await permissions.checkLocationPermission();

    if (permissionState != PermissionState.granted) {
      _isLocationAllowed = false;
      _isLoading = false;
      _safeNotify();
      return;
    }

    final destinationCoords = treasure.location?.coordinates;
    if (destinationCoords == null || destinationCoords.length < 2) {
      _isLoading = false;
      _nextInstruction = 'Destination unavailable';
      _safeNotify();
      return;
    }

    final current = await permissions.getCurrentPosition();
    if (current == null) {
      _isLoading = false;
      _isLocationAllowed = false;
      _safeNotify();
      return;
    }

    _currentPosition = LatLng(current.latitude, current.longitude);
    _destination = LatLng(
      (destinationCoords[1] as num).toDouble(),
      (destinationCoords[0] as num).toDouble(),
    );

    await _buildOrRebuildRoute(
      origin: _currentPosition!,
      destination: _destination!,
      moveCameraToBounds: true,
    );

    _listenToPositionStream();
  }

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    unawaited(_fitRouteOnMap());
  }

  Future<void> onLifecycleChanged(AppLifecycleState state) async {
    if (state == AppLifecycleState.detached) {
      await stopNavigationSession(clearMapState: false);
      return;
    }

    if (state == AppLifecycleState.resumed && _currentPosition != null) {
      _updateProgress(_currentPosition!);
    }
  }

  Future<void> requestPermissionAndRestart(AppPermissions permissions) async {
    final permissionState = await permissions.requestLocationPermission();

    if (permissionState != PermissionState.granted) {
      await permissions.openLocationSettings();
      return;
    }

    _isLocationAllowed = true;
    _isLoading = true;
    _safeNotify();
    await initializeNavigation(permissions);
  }

  Future<void> stopNavigationSession({bool clearMapState = true}) async {
    if (_isNavigationStopped) return;
    _isNavigationStopped = true;

    await _liveTrackingService.stopTracking();

    if (!clearMapState) return;

    _isRerouting = false;
    _isLoading = false;
    _polylines.clear();
    _routePoints.clear();
    _routeSteps.clear();
    _markers
        .removeWhere((marker) => marker.markerId.value == 'current_position');

    _safeNotify();
  }

  void _listenToPositionStream() {
    if (_isNavigationStopped) return;

    unawaited(_liveTrackingService.startTracking(onLocation: (current) async {
      if (_isNavigationStopped || _isDisposed) return;

      _currentPosition = current;
      _refreshMarkers();
      _updateProgress(current);

      await _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: current, zoom: 16),
        ),
      );

      if (_destination != null &&
          _routingService.hasReachedDestination(
            current: current,
            destination: _destination!,
          )) {
        await _handleArrived();
        return;
      }

      if (_routePoints.length > 1 && !_hasArrived) {
        final offRouteDistance = _routingService.distanceFromRouteMeters(
          current: current,
          routePoints: _routePoints,
        );
        final now = DateTime.now();
        final rerouteCooldown = now.difference(_lastRerouteAt).inSeconds > 8;

        if (offRouteDistance > 60 && rerouteCooldown && !_isRerouting) {
          _lastRerouteAt = now;
          await _buildOrRebuildRoute(
            origin: current,
            destination: _destination!,
            moveCameraToBounds: false,
          );
        }
      }
    }));
  }

  Future<void> _buildOrRebuildRoute({
    required LatLng origin,
    required LatLng destination,
    required bool moveCameraToBounds,
  }) async {
    _isLoading = _routePoints.isEmpty;
    _isRerouting = _routePoints.isNotEmpty;
    _safeNotify();

    try {
      final route = await _routingService.fetchRoute(
        origin: origin,
        destination: destination,
      );

      if (_isDisposed || _isNavigationStopped) return;
      _routePoints = route.polylinePoints;
      _routeSteps = route.steps;
      _totalDistanceText = route.distanceText;

      _polylines
        ..clear()
        ..addAll(_routingService.buildRoutePolylines(_routePoints));

      _refreshMarkers();
      _updateProgress(origin, forceTotal: true);

      if (moveCameraToBounds) {
        await _fitRouteOnMap();
      }
    } catch (_) {
      if (_isDisposed) return;
      _nextInstruction = 'Unable to build route. Check map key or network.';
      _safeNotify();
    } finally {
      if (_isDisposed) return;
      _isLoading = false;
      _isRerouting = false;
      _safeNotify();
    }
  }

  void _refreshMarkers() {
    if (_destination == null) return;

    final updated = _routingService.buildMarkers(
      treasure: treasure,
      destination: _destination!,
      currentPosition: _currentPosition,
    );

    _markers
      ..clear()
      ..addAll(updated);

    _safeNotify();
  }

  void _updateProgress(LatLng current, {bool forceTotal = false}) {
    if (_routePoints.length < 2) return;

    final remainingDistance = _routingService.remainingDistanceMeters(
      current: current,
      routePoints: _routePoints,
    );

    final remainingDuration = _routingService.estimateRemainingDuration(
      totalDurationSeconds: _routeSteps.fold<int>(
        0,
        (sum, step) => sum + step.durationSeconds,
      ),
      totalDistanceMeters: _routeSteps.fold<int>(
        0,
        (sum, step) => sum + step.distanceMeters,
      ),
      remainingDistanceMeters: remainingDistance,
    );

    final nextStep = _routingService.pickNextStep(
      current: current,
      routeSteps: _routeSteps,
    );
    final stepDistance = _routingService.distanceToStepStartMeters(
      current: current,
      nextStep: nextStep,
    );

    if (forceTotal) {
      _remainingDistanceText = _totalDistanceText;
    } else {
      _remainingDistanceText =
          _routingService.formatDistance(remainingDistance);
    }

    _remainingDurationText = _routingService.formatDuration(remainingDuration);
    _etaText = _routingService.formatEta(remainingDuration);
    _nextInstruction = nextStep?.instruction.isNotEmpty == true
        ? nextStep!.instruction
        : 'Continue to destination';
    _nextTurnDistanceText = _routingService.formatDistance(stepDistance);

    _safeNotify();
  }

  Future<void> _fitRouteOnMap() async {
    if (_mapController == null || _routePoints.isEmpty) return;

    final bounds = _routingService.computeBounds(_routePoints);
    if (bounds == null) return;

    await _mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(
        bounds,
        70,
      ),
    );
  }

  Future<void> _handleArrived() async {
    if (_hasArrived) return;
    _hasArrived = true;

    await stopNavigationSession(clearMapState: false);
    if (_isDisposed) return;
    await onArrived();
  }

  void _safeNotify() {
    if (_isDisposed) return;
    notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;

    unawaited(_liveTrackingService.dispose());
    _mapController?.dispose();
    _mapController = null;

    super.dispose();
  }
}
