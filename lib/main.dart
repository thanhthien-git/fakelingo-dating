import 'package:fakelingo/core/services/socket_service.dart';
import 'package:fakelingo/ui/screens/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:fakelingo/core/services/storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await StorageService.init();
  runApp(const App());
}
