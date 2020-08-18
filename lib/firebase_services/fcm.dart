import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:heard/firebase_services/auth_service.dart';

class FCM {
  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  bool _initialized = false;

  Future<void> init(String userType) async{
    if (!_initialized) {
      // For iOS request permission first.
      _firebaseMessaging.requestNotificationPermissions();
      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print("onMessage: $message");
        },
        onBackgroundMessage: myBackgroundMessageHandler,
        onLaunch: (Map<String, dynamic> message) async {
          print("onLaunch: $message");
        },
        onResume: (Map<String, dynamic> message) async {
          print("onResume: $message");
        },
      );

      String fcmToken = await _firebaseMessaging.getToken();

      String authToken = await AuthService.getToken();
      var response = await http.post(
          'https://heard-project.herokuapp.com/fcm/upsert',
          headers: {
            'Authorization': authToken,
          },
          body: {
            'fcm_token': fcmToken,
            'type': userType,
          });
      _initialized = true;

      var code = response.statusCode;
      print("Token Response: $code");
    }
  }

  static Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }
  }
}