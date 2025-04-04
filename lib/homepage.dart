import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Homepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Home Page"),
          //بدي اعمل ايقونة خاصة بتسجيل الخروج من خلال الفايربيز
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                // هنا يمكنك إضافة كود تسجيل الخروج من Firebase
                // على سبيل المثال:
                FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  "login",
                  (route) => false,
                );
                //بعد تسجيل الدخول باستخدام جوجل المرات اللي بعدها ما بتظهر شاشة لاختيار الايميل
                //لذلك بدي احذف الايميل من الذاكرة
                //مقابل تسجيل الدخول باستخدام جوجل بنعمل تسجيل الخروج باستخدامه
                //بنعمل instance
                GoogleSignIn googleSignIn = GoogleSignIn();
                googleSignIn.disconnect();
              },
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Welcome to the Home Page!"),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "register");
                },
                child: const Text("Go to Register"),
              ),
              Container(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "login");
                },
                child: const Text("Go to Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
