class MapControllerService {
  bool _isFetching = false;

  double? _lastLat;
  double? _lastLng;

  DateTime? _lastFetchTime;

  static const double movementThreshold = 0.005; // adjust per city scale
  static const Duration debounceTime = Duration(seconds: 2);

  bool shouldFetch(double lat, double lng) {
    final now = DateTime.now();

    if (_isFetching) return false;

    if (_lastFetchTime != null &&
        now.difference(_lastFetchTime!) < debounceTime) {
      return false;
    }

    if (_lastLat != null &&
        _lastLng != null &&
        (lat - _lastLat!).abs() < movementThreshold &&
        (lng - _lastLng!).abs() < movementThreshold) {
      return false;
    }

    _lastLat = lat;
    _lastLng = lng;
    _lastFetchTime = now;

    return true;
  }

  void setFetching(bool value) {
    _isFetching = value;
  }
}
