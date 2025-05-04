import 'dart:convert';

import 'package:app22/chat.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
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
  /*  getToken() async {
    String? tokenname = await FirebaseMessaging.instance.getToken();
    print(
      "==================================================Token: $tokenname",
    );
  }*/

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

  //دالة بتشتغل عند الضغط على الاشعار في حال التطبيق كان مغلق
  getInit() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      //عشان ما يصير عندي ايرور لو عملنا رن للتطبيق في حال كان مفتوح
      //لانه قيمة المتغير بتكون لا تساوي نل وهي بتشتغل والتطبيق مغلق
      //بالنهاية بنتاكد انه هاي الدالة ما بتشتغل الا في حالة التطبيق كان مغلق
      String? title =
          initialMessage
              .notification!
              .title; //بما انه المتغير من نوع كزا ازن برجعلي كل معلومات الاشعار  فبدنا نستفيد منها
      String? body = initialMessage.notification!.body;
      if (initialMessage.data["type"] == "chat") {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Chat(body: body!, title: title!),
          ),
        );
        //في حال الضغط ع الاشعار وما كان نفس التايب رح يوجهني للصفحة الرئيسية
      }
    }
  }

  @override
  void initState() {
    getInit();
    //دالة خاصة بالضغط على الاشعار فالخلفية
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      /*  if (message.data["type"] == "chat") {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => Chat()));
        //في حال الضغط ع الاشعار وما كان نفس التايب رح يوجهني للصفحة الرئيسية
      }*/
    });

    //دالة مسؤولة عن ظهور الاشعار للمستخدم والتطبيق مفتوح
    FirebaseMessaging.onMessage.listen((RemoteMessage Message) {
      if (Message.notification != null) {
        print("==============================");
        print(Message.notification!.title);
        print(Message.notification!.body);
        print(Message.data);
        print("==============================");

        AwesomeDialog(
          context: context,
          title: Message.notification!.title,
          body: Text("${Message.notification!.body}"),
          dialogType: DialogType.info,
        ).show();
      }
      //او ممكن نضيف==snakbar==> الاشعار يظهر بالاسفل ...
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("${Message.notification!.body}")));
    });
    /*
      بهذا لاشكل اول ما اضغط على الزر الخاص بارسال الاشعار بكود الاشعار من الاي بي اي...الخ
      بوجود هاي الدالة رح يصل الاشعار والمستخدم فاتح التطبيق  والا بظهر لما يكون التطبيق بالخلفية  
      //هاي الدالة رح يتم استدعائها عند ارسال اي اشعار لانها ليسن ====ستريم
      
      */
    //  myRequestPermission();
    // getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CloudMessaging')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Center(
            child: MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () {
                //رح يكون مهمة هذا الزر الاشتراك بالتوبك
                // subscribe to topic on each app start-up
                FirebaseMessaging.instance.subscribeToTopic('waelabohamza');
              },
              child: const Text("Subscribe"),
            ),
          ),
          Container(height: 10),
          MaterialButton(
            color: Colors.blue,
            textColor: Colors.white,
            onPressed: () {
              //الزر هذا وظيفته الغاء الاشتراك بالتوبك كزا
              FirebaseMessaging.instance.unsubscribeFromTopic('waelabohamza');
            },
            child: const Text("Unsubscribe"),
          ),
          Container(height: 10),
          MaterialButton(
            color: Colors.blue,
            textColor: Colors.white,
            onPressed: () {
              //هذا الزر خاص بارسال الرسالة من التوبك
              sendMessageTopic(
                "Hi",
                "فيديو بعنوان الكرة الارضية مسطحة!",
                "waelabohamza", //لازم يكون نفس اسم التوبك بالاعلى اي خطا ما رح ينبعت الاشعار
              );
            },
            child: const Text("Send Message Topics"),
            /*
              اول ما اضغط ع هذا الزر الاشعار بصلني
              على شكل سناك بار...الخ
            */
          ),
        ],
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
    "data": {
      "name": "Noura Hassanin",
      "age": 23,
      "IP": 20203087,
      "type": "chat",
    },
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

//دالة خاصة بارسال الاشعار للتوبك
sendMessageTopic(title, message, topic) async {
  var headersList = {
    'Accept': '*/*',

    'Content-Type': 'application/json',
    'Authorization': 'key=',
  };
  var url = Uri.parse('https://fcm.googleapis.com/fcm/send');

  var body = {
    "to": "/topics/$topic",
    "notification": {"title": title, "body": message},
    "data": {
      "name": "Noura Hassanin",
      "age": 23,
      "IP": 20203087,
      "type": "chat",
    },
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
