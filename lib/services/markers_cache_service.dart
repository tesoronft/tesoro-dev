class MarkerCacheService {
  final Map<String, List<dynamic>> _cache = {};

  String _key(double lat, double lng) {
    return "${lat.toStringAsFixed(2)}_${lng.toStringAsFixed(2)}";
  }

  List<dynamic>? get(double lat, double lng) {
    return _cache[_key(lat, lng)];
  }

  void set(double lat, double lng, List<dynamic> markers) {
    _cache[_key(lat, lng)] = markers;
  }
}
