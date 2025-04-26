import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class TestState extends StatefulWidget {
  const TestState({super.key});

  @override
  State<TestState> createState() => _TestStateState();
}

class _TestStateState extends State<TestState> {
  //لاني بشتغل على محاكي كروم ما بيقبل يطبعلي التوكن لازم اشتغل على محاكي اندرويد
  //او جهاز حقيقي
  getToken() async {
    String? tokenname = await FirebaseMessaging.instance.getToken();
    print(
      "==================================================Token: $tokenname",
    );
  }

  /*
  في الويب ➔ المتصفح مسؤول عن طلب الإذن.

  في الموبايل ➔ إنت (كمطور) لازم تطلب الإذن من الكود.
  */
  //في الويب بلاتفورم والايفون وبعض الاصدارت الجديدة من الاندرويد التطبيق ماعندهم الاذن الخاص بالوصول للاشعارات
  //بهاي الحالة رح نستخدمpermission

  myRequestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      //الخصائص هاي خاصة بالابل حسب ال
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  @override
  void initState() {
    //  myRequestPermission();
    getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TestState')),
      body: const Center(child: Text('Welcome to TestState')),
    );
  }
}
