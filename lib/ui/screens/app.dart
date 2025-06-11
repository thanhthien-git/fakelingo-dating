import 'package:fakelingo/core/provider/auth_provider.dart';
import 'package:fakelingo/core/provider/loading_provider.dart';
import 'package:fakelingo/ui/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fakelingo/ui/screens/home.dart';
import 'package:fakelingo/ui/screens/login_screen.dart';
import 'package:fakelingo/ui/screens/register_screen.dart';


class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => LoadingProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) {
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
            home: auth.isLoggedIn
                ? const MainScreen()
                : LoginScreen(),
            routes: {
              '/register': (context) => RegisterScreen(),
              'login': (context) => LoginScreen(),
              '/home': (context) => const MainScreen(),
            },
          );
        },
      ),
    );
  }
}
