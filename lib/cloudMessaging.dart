import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class CloudMessaging extends StatefulWidget {
  const CloudMessaging({super.key});

  @override
  State<CloudMessaging> createState() => _CloudMessagingState();
}

class _CloudMessagingState extends State<CloudMessaging> {
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
      appBar: AppBar(title: const Text('CloudMessaging')),
      body: Center(
        child: MaterialButton(
          onPressed: () {
            sendMessage(
              "New",
              "Hello Ahmed! Now we have a new Car,Can look it in this video,Thanks!",
            );
          },
          child: const Text("Send Notification"),
        ),
      ),
    );
  }
}

//كود ارسال الاشعار من الAPI بلغة Dart
sendMessage(title, message) async {
  var headersList = {
    'Accept': '*/*',

    'Content-Type': 'application/json',
    'Authorization': 'key=',
  };
  var url = Uri.parse('https://fcm.googleapis.com/fcm/send');

  var body = {
    "to": "<Device FCM token>",
    "notification": {"title": title, "body": message},
  };

  var http;
  var req = http.Request('GET', url);
  req.headers.addAll(headersList);
  req.body = json.encode(body);

  var res = await req.send();
  final resBody = await res.stream.bytesToString();

  if (res.statusCode >= 200 && res.statusCode < 300) {
    print(resBody);
  } else {
    print(res.reasonPhrase);
  }
}
