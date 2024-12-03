import 'package:wifi_iot/wifi_iot.dart';
import 'dart:developer' as dev;
import 'dart:io';
import '../utils/permission_handler.dart';

class WifiService {
  static Future<List<String>> scanNetworks() async {
    try {
      // Check location permission first
      final hasPermission = await PermissionUtils.requestLocationPermission();
      if (!hasPermission) {
        throw Exception('Location permission required for WiFi scanning');
      }

      if (Platform.isIOS) {
        // iOS specific implementation
        final currentNetwork = await WiFiForIoTPlugin.getSSID();
        if (currentNetwork != null && currentNetwork.isNotEmpty) {
          return [currentNetwork];
        }
        return [];
      } else {
        // Android implementation
        final networks = await WiFiForIoTPlugin.loadWifiList();
        return networks.map((network) => network.ssid ?? '').toList() ?? [];
      }
    } catch (e) {
      dev.log('Error scanning WiFi networks: $e');
      throw Exception('Failed to scan WiFi networks: $e');
    }
  }

  static Future<bool> connectToNetwork(String ssid, String password) async {
    try {
      final connected = await WiFiForIoTPlugin.connect(
        ssid,
        password: password,
        security: NetworkSecurity.WPA,
        joinOnce: true,
      );

      dev.log('Connection attempt to $ssid result: $connected');
      return connected;
    } catch (e) {
      dev.log('Error connecting to WiFi: $e');
      throw Exception('Failed to connect to WiFi: $e');
    }
  }

  static Future<bool> isConnected() async {
    try {
      return await WiFiForIoTPlugin.isConnected();
    } catch (e) {
      dev.log('Error checking WiFi connection: $e');
      return false;
    }
  }
} 