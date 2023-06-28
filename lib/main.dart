import 'package:flutter/material.dart';
import 'package:projeto_final/src/auth/auth_service.dart';
import 'package:projeto_final/src/auth/login_page.dart';
import 'package:projeto_final/src/home/home_page.dart';
import 'package:projeto_final/src/registration/registration_page.dart';
import 'package:provider/provider.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthService())],
      child: _app(),
    );
  }

  Widget _app() {
    return MaterialApp(
      title: 'Easy Money',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: const Color.fromARGB(255, 8, 22, 171),
        appBarTheme: const AppBarTheme(
          color: Color.fromARGB(255, 8, 22, 171),
          centerTitle: true,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        colorSchemeSeed: const Color.fromARGB(255, 17, 72, 3),
        appBarTheme: const AppBarTheme(
          color: Color.fromARGB(255, 17, 72, 3),
          centerTitle: true,
        ),
      ),
      initialRoute: '/auth/login',
      routes: {
        '/auth/login': (context) => const LoginPage(),
        '/auth/registration': (context) => const RegistrationPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
