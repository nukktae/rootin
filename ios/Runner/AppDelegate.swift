import Flutter
import UIKit
import Firebase
import FirebaseMessaging

@main
@objc class AppDelegate: FlutterAppDelegate, MessagingDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    Messaging.messaging().delegate = self
    
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
      
      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
      UNUserNotificationCenter.current().requestAuthorization(
        options: authOptions,
        completionHandler: { _, _ in }
      )
    }
    
    application.registerForRemoteNotifications()
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    print("Firebase registration token: \(String(describing: fcmToken))")
    
    if let token = fcmToken {
      print("Valid FCM token received")
    } else {
      print("Received null FCM token")
    }
    
    NotificationCenter.default.post(
      name: Notification.Name("FCMToken"),
      object: nil,
      userInfo: ["token": fcmToken ?? ""]
    )
  }
  
  override func application(_ application: UIApplication,
                        didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    print("Received remote notification: \(userInfo)")
    completionHandler(.newData)
  }
}
