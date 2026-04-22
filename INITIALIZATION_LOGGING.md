# Initialization Logging Guide

## Overview
Comprehensive logging has been added throughout the initialization code to help identify what's being called repeatedly and where the app is crashing.

## Color-Coded Log Messages

### 🔴 [MAIN] - Main Entry Point
```
🔴 [MAIN] main() called
🔴 [MAIN] WidgetsFlutterBinding initialized
🔴 [MAIN] Firebase initialized
🔴 [MAIN] App providers initialized and runApp called
```

### 🟡 [PROVIDERS] - Provider Initialization
```
🟡 [PROVIDERS] AppProviders.providers() called
🟡 [PROVIDERS] Creating InternetChecker
🟡 [PROVIDERS] Creating DashboardProvider
🟡 [PROVIDERS] Creating ApiProvider
🟡 [PROVIDERS] Creating PreferencesProvider
🟡 [PROVIDERS] Creating CameraProvider
🟡 [PROVIDERS] Creating AppPermissions
```

### 🔵 [PREFS] - PreferencesProvider (SharedPreferences)
```
🔵 [PREFS] PreferencesProvider constructor called
🔵 [PREFS] getAllPrefs() started
🔵 [PREFS] SharedPreferences obtained
🔵 [PREFS] refreshToken loaded: [token]
🔵 [PREFS] accessToken loaded: [token]
🔵 [PREFS] userId loaded: [userId]
🔵 [PREFS] isSSOUser loaded: [bool]
🔵 [PREFS] getAllPrefs() completed successfully
```

### 🟢 [INTERNET] - InternetChecker
```
🟢 [INTERNET] InternetChecker constructor called
🟢 [INTERNET] InternetConnectionChecker instance created
🟢 [INTERNET] _init() started
🟢 [INTERNET] hasConnection check completed: [bool]
🟢 [INTERNET] onStatusChange listener triggered: [status]
🟢 [INTERNET] _init() completed - listener attached
```

### 🟠 [API] - ApiProvider
```
🟠 [API] ApiProvider constructor called
🟠 [API] getMarkers() called - page=1, long=X.XX, lat=Y.YY, distance=10
🟠 [API] getMarkers() API request started
🟠 [API] ApiProvider dispose() called
```

### 🟣 [PERMS] - AppPermissions (Location/Camera)
```
🟣 [PERMS] AppPermissions constructor called
🟣 [PERMS] getCurrentPosition() called
🟣 [PERMS] location permission checked: [permission]
🟣 [PERMS] requesting location permission
🟣 [PERMS] permission result: [permission]
🟣 [PERMS] location permission granted, getting position
🟣 [PERMS] getCurrentPosition() completed: LAT, LONG
🟣 [PERMS] AppPermissions dispose() called
```

### 🟠 [HOME] - HomeView Initialization
```
🟠 [HOME] initState() called - initializing HomeView
🟠 [HOME] WidgetsBindingObserver added
🟠 [HOME] loadMarker() called - imageId=null
🟠 [HOME] loadMarker() loading image from assets
🟠 [HOME] loadMarker() bitmap loaded
🟠 [HOME] loadMarker() image registered: [imageId]
🟠 [HOME] loadMarker() completed
🟠 [HOME] GoogleMapsMapView onViewCreated() called
🟠 [HOME] Map controller assigned
🟠 [HOME] Future.microtask executing - calling initMap()
🟠 [HOME] initMap() called
🟠 [HOME] initMap() skipped - didInitMap=false, isInitializingMap=false, controller=true
🟠 [HOME] initMap() starting initialization
🟠 [HOME] initMap() completed successfully
🟠 [HOME] dispose() called - cleaning up HomeView
```

## How to Read the Logs

### Running the App
```bash
cd /Users/muhammadroshaan/development/tesoro_nft_app
flutter run -v  # Use -v for verbose output to see all print() statements
```

### What to Look For

1. **Repeated Initialization**
   - If you see the same log message printed multiple times (e.g., multiple "initState() called"), the widget is rebuilding unexpectedly
   
2. **Missing Completion Messages**
   - If you see "started" but not "completed", the operation is hanging
   
3. **Error Messages**
   - Any message with "ERROR:" will show the exception
   
4. **Sequence of Events**
   - The logs show the exact order operations happen
   - Use timestamps to identify bottlenecks

## Expected Initialization Sequence (Normal)

```
🔴 [MAIN] main() called
🔴 [MAIN] WidgetsFlutterBinding initialized
🔴 [MAIN] Firebase initialized
🟡 [PROVIDERS] AppProviders.providers() called
🟢 [INTERNET] InternetChecker constructor called
🟠 [API] ApiProvider constructor called
🔵 [PREFS] PreferencesProvider constructor called
🟣 [PERMS] AppPermissions constructor called
🟢 [INTERNET] _init() started
🔵 [PREFS] getAllPrefs() started
🟠 [HOME] initState() called - initializing HomeView
🟠 [HOME] GoogleMapsMapView onViewCreated() called
🟡 [PROVIDERS] Creating InternetChecker
🟡 [PROVIDERS] Creating DashboardProvider
🟡 [PROVIDERS] Creating CameraProvider
[...providers get created...]
🟣 [PERMS] getCurrentPosition() called
[location permission flow...]
🟠 [HOME] initMap() called
🟠 [API] getMarkers() called
[API response...]
🟠 [HOME] initMap() completed successfully
```

## Problem Indicators

### Issue: Widget Building Multiple Times
**Log Pattern:**
```
🟠 [HOME] initState() called - initializing HomeView
[... initialization ...]
🟠 [HOME] dispose() called - cleaning up HomeView
🟠 [HOME] initState() called - initializing HomeView  ← REPEATED!
```

### Issue: Hanging Initialization
**Log Pattern:**
```
🔵 [PREFS] getAllPrefs() started
🔵 [PREFS] SharedPreferences obtained
[... nothing after this ...]
```
The app freezes at SharedPreferences call

### Issue: Permission Crashes
**Log Pattern:**
```
🟣 [PERMS] getCurrentPosition() called
🟣 [PERMS] location permission checked: denied
[... app crashes here ...]
```

### Issue: API Crashes
**Log Pattern:**
```
🟠 [API] getMarkers() called
🟠 [API] getMarkers() API request started
[... app crashes without completion ...]
```

## Next Steps After Running

1. Run the app with `flutter run -v`
2. Watch the logs in the terminal
3. Note where the logs stop (that's likely where the crash happens)
4. Send me the complete log output
5. We'll identify the exact function causing the crash

---

**Updated Files with Logging:**
- lib/main.dart
- lib/consts/app_providers.dart
- lib/providers/preferences_provider.dart
- lib/providers/api_provider.dart
- lib/utils/internet_checker.dart
- lib/utils/app_permissions.dart
- lib/features/dashboard/home/home_view.dart
