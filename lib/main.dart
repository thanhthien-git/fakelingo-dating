import 'package:fakelingo/core/services/fcm_token_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'ui/screens/app.dart';
import 'core/services/storage_service.dart';
import 'core/services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await StorageService.init();
  await Firebase.initializeApp();
  await FcmTokenService().initFcm();

  FirebaseMessaging.onBackgroundMessage(NotificationService.firebaseBackgroundHandler);

  await NotificationService.init();

  runApp(const App());
}
