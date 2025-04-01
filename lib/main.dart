import 'package:app22/firebase_options.dart';
import 'package:app22/login.dart';
import 'package:app22/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    //هاي دالة streem اللي بتستمع الى حالة المستخدم
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print(
          '==================================================User is currently signed out!',
        );
      } else {
        print(
          '==================================================User is signed in!',
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const login100(),
      routes: {
        "register": (context) => const Register20(),
        "login": (context) => const login100(),
      },
    );
  }
}
