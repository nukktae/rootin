import Flutter
import NetworkExtension
import CoreLocation
import SystemConfiguration.CaptiveNetwork

class WifiMethodChannel: NSObject, FlutterPlugin {
    static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "com.example.app/wifi",
            binaryMessenger: registrar.messenger()
        )
        let instance = WifiMethodChannel()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getWifiNetworks":
            if #available(iOS 14.0, *) {
                NEHotspotNetwork.fetchCurrent { networks in
                    // Get all available networks
                    NEHotspotHelper.register(options: [:]) { command in
                        guard let ssid = command.network.ssid else { return }
                        result([ssid])
                    }
                }
            } else {
                // Fallback for older iOS versions
                if let interfaces = CNCopySupportedInterfaces() as NSArray? {
                    var networks: [String] = []
                    for interface in interfaces {
                        if let networkInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                            if let ssid = networkInfo[kCNNetworkInfoKeySSID as String] as? String {
                                networks.append(ssid)
                            }
                        }
                    }
                    result(networks)
                } else {
                    result([])
                }
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
} 