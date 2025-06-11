import 'package:fakelingo/core/provider/auth_provider.dart';
import 'package:fakelingo/ui/screens/app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:fakelingo/core/services/token_storage.dart';
import 'package:fakelingo/ui/screens/home.dart';
import 'package:fakelingo/ui/screens/login_screen.dart';
import 'package:fakelingo/ui/screens/register_screen.dart';
import 'package:fakelingo/ui/screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await TokenStorage.init();
  runApp(const App());
}
