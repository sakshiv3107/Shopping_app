import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shopping_app/auth_wrapper.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shopping App',

      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Lato',

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 1, 203, 254),
          primary: const Color.fromARGB(255, 1, 165, 254),
          brightness: Brightness.light,
        ),

        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),

        inputDecorationTheme: const InputDecorationTheme(
          hintStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          prefixIconColor: Color.fromRGBO(119, 119, 119, 1),
        ),

        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
          titleMedium: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          bodySmall: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),

      darkTheme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Lato',

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 1, 161, 254),
          brightness: Brightness.dark,
        ),
      ),

      themeMode: ThemeMode.system,

      // Entry Point
      home: AuthWrapper(),
    );
  }
}
