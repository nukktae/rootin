import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'dart:developer' as dev;

class PermissionUtils {
  static Future<bool> requestBluetoothPermissions() async {
    try {
      if (!Platform.isIOS) return true;
      
      // Check location services first
      final locationService = await Permission.location.serviceStatus;
      if (!locationService.isEnabled) {
        dev.log('Location services disabled');
        return false;
      }

      // Request location permission
      final locationStatus = await Permission.locationWhenInUse.request();
      if (!locationStatus.isGranted) {
        dev.log('Location permission denied');
        return false;
      }

      // Request Bluetooth permission
      final bluetoothStatus = await Permission.bluetooth.request();
      await Future.delayed(const Duration(milliseconds: 100));
      
      if (!bluetoothStatus.isGranted) {
        dev.log('Bluetooth permission denied');
        return false;
      }

      return true;
    } catch (e) {
      dev.log('Error requesting Bluetooth permissions: $e');
      return false;
    }
  }

  static Future<bool> requestLocationPermission() async {
    try {
      // Check system location services
      final locationService = await Permission.location.serviceStatus;
      if (!locationService.isEnabled) {
        dev.log('Location services disabled at system level');
        return false;
      }

      // Request location permission with retry
      for (int i = 0; i < 3; i++) {
        var locationStatus = await Permission.locationWhenInUse.status;
        dev.log('Location permission status (attempt ${i + 1}): $locationStatus');
        
        if (locationStatus.isGranted) break;
        
        locationStatus = await Permission.locationWhenInUse.request();
        await Future.delayed(const Duration(seconds: 1));
        
        if (i == 2 && !locationStatus.isGranted) {
          dev.log('Location permission denied after 3 attempts');
          return false;
        }
      }

      return true;
    } catch (e) {
      dev.log('Error requesting location permission: $e');
      return false;
    }
  }

  static Future<bool> checkLocationPermission() async {
    try {
      final locationService = await Permission.location.serviceStatus;
      if (!locationService.isEnabled) return false;

      final locationStatus = await Permission.locationWhenInUse.status;
      return locationStatus.isGranted;
    } catch (e) {
      dev.log('Error checking location permission: $e');
      return false;
    }
  }
} 