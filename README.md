<div align="center">
  <img src="assets/images/rootin_logo.png" alt="Rootin Logo" width="200"/>
  
  # Rootin 🌱
  
  *Your AI-Powered Plant Care Companion*

  [![Flutter](https://img.shields.io/badge/Flutter-3.16-02569B?logo=flutter&style=for-the-badge)](https://flutter.dev/)
  [![Dart](https://img.shields.io/badge/Dart-3.2-0175C2?logo=dart&style=for-the-badge)](https://dart.dev/)
  [![Firebase](https://img.shields.io/badge/Firebase-Cloud-FFCA28?logo=firebase&style=for-the-badge)](https://firebase.google.com/)
  [![BLE](https://img.shields.io/badge/Bluetooth-LE-0082FC?logo=bluetooth&style=for-the-badge)](https://www.bluetooth.com/)
</div>

---

## 🚀 About

Rootin revolutionizes indoor plant care by combining IoT technology with AI-powered recommendations. Our smart soil moisture sensors and intelligent algorithms help plant owners maintain optimal growing conditions, preventing common care mistakes through real-time monitoring and personalized guidance.

---

## ✨ Key Features

- 🔍 **Smart Monitoring**
  - Real-time soil moisture tracking with custom BLE sensors
  - Interactive trend visualization using FL Chart
  - Automated plant health diagnostics

- 🤖 **Intelligent Notifications**
  - Context-aware watering reminders
  - Predictive plant health alerts
  - Battery and sensor status updates
  - 95% notification delivery rate

- 🌿 **AI-Powered Care**
  - Species-specific care recommendations
  - Visual plant identification
  - Personalized watering schedules

---

## 🛠️ Technical Stack

### Mobile Development
- **Core**: Flutter 3.16, Dart 3.2
- **State Management**: Provider
- **Data Visualization**: FL Chart
- **UI/UX**: Custom animations & widgets

### Cloud Services
- **Backend**: Firebase Cloud Platform
- **Push Notifications**: Firebase Cloud Messaging
- **Authentication**: Firebase Auth
- **Database**: Cloud Firestore

### IoT Integration
- **Protocol**: Bluetooth Low Energy (BLE)
- **Hardware**: Custom moisture sensors
- **Data Processing**: Real-time analytics

---

## 📱 App Preview

<div align="center">
  <img src="screenshots/home.png" width="200" alt="Home Screen"/>
  <img src="screenshots/monitoring.png" width="200" alt="Monitoring Screen"/>
  <img src="screenshots/notifications.png" width="200" alt="Notifications Screen"/>
</div>

---

## 🌟 Technical Highlights

- **Efficient Architecture**: Custom BLE protocol for reliable sensor communication
- **Real-time Processing**: Live data visualization with interactive charts
- **Smart Notifications**: Robust FCM implementation with retry logic
- **Responsive Design**: Fluid animations and adaptive layouts
- **Offline Support**: Local data persistence and background sync

---

## 🔧 Core Features Implementation

```dart
// Real-time moisture monitoring
class RealTimeSoilMoistureScreen extends StatefulWidget {
  final Map<String, dynamic> plantDetail;
  final String status;

  @override
  State<RealTimeSoilMoistureScreen> createState() => RealTimeSoilMoistureScreenState();
}

// BLE device management
class BluetoothSearchScreen extends StatefulWidget {
  final String plantNickname;
  final String imageUrl;

  @override
  State<BluetoothSearchScreen> createState() => BluetoothSearchScreenState();
}

// Notification handling
void initializeNotifications() {
  FirebaseMessaging.instance.onMessage.listen((RemoteMessage message) {
    handleNotification(message);
  });
}

## 📈 Future Development

- [ ] Plant disease detection using ML
- [ ] Community-driven care tips
- [ ] Advanced environmental metrics
- [ ] Cross-platform expansion
- [ ] Smart home integration

## 🤝 Contributing

We welcome contributions! Please check our [Contributing Guidelines](CONTRIBUTING.md) for details.

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<div align="center">
  <p>Made with 💚 for plant lovers</p>
  <p>© 2024 Rootin. All rights reserved.</p>
</div>