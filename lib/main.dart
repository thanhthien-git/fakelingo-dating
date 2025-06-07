import 'package:fakelingo/core/provider/auth_provider.dart';
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
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          if (auth.isLoading) return const SplashScreen();

          return MaterialApp(
            title: 'FakeLingo Dating',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.pink,
              scaffoldBackgroundColor: Colors.black,
              fontFamily: 'Roboto',
              textTheme: const TextTheme(
                bodyMedium: TextStyle(color: Colors.white),
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
            ),
            home: auth.isLoggedIn ? const HomeScreen() : LoginScreen(),
            routes: {
              '/register': (context) => RegisterScreen(),
              '/home': (context) => const HomeScreen(),
              'login': (context) => LoginScreen(),
            },
          );
        },
      ),
    );
  }
}
