import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  final String body;
  final String title;
  const Chat({super.key, required this.body, required this.title});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Center(
        child: ListView(children: [Text(widget.body), Text(widget.title)]),
      ),
    );
  }
}
