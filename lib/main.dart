import 'package:app22/auth/login.dart';
import 'package:app22/auth/register.dart';
import 'package:app22/categories.dart/add.dart';
import 'package:app22/filter.dart' show FilterFirestore;
import 'package:app22/firebase_options.dart';
import 'package:app22/homepage.dart';
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
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.pink[200],
          titleTextStyle: TextStyle(
            color: Colors.blue,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.blue),
        ),
      ),

      debugShowCheckedModeBanner: false, // إخفاء شريط الـ Debug
      title: "My App",
      //من خلال الفايربيز بنعرف
      //لو الشخص عامل تسجيل دخول بدي احوله على الصفحة الرئيسية
      //لو مش عامل تسجيل دخول بدي احوله على صفحة تسجيل الدخول
      home: // ImagePickerWidget(),
          //FilterFirestore(), //==واجهة عملناها لحتى نطبق مفهوم الفلتر
          (FirebaseAuth.instance.currentUser != null &&
                  FirebaseAuth.instance.currentUser!.emailVerified)
              ? Homepage()
              : Login(),
      routes: {
        "register": (context) => const Register(),
        "login": (context) => const Login(),
        "homepage": (context) => Homepage(),
        "addCategory": (context) => const AddCategory(),
        "filterfirestore": (context) => const FilterFirestore(),
      },
    );
  }
}
