import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class TestState extends StatefulWidget {
  const TestState({super.key});

  @override
  State<TestState> createState() => _TestStateState();
}

class _TestStateState extends State<TestState> {
  getToken() async {
    String? tokenname = await FirebaseMessaging.instance.getToken();
    print(
      "==================================================Token: $tokenname",
    );
  }

  @override
  void initState() {
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
