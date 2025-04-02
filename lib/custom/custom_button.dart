import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomButtonAuth extends StatelessWidget {
  final String login;
  void Function()? onPressed;

  CustomButtonAuth({super.key, required this.login, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: MaterialButton(
        color: Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        onPressed: onPressed,
        child: Text(
          login,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  jsonDecode(String body) {}
}
