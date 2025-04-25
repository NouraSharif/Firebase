import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomButtonAuth extends StatelessWidget {
  final String login;
  void Function()? onPressed;

  CustomButtonAuth({super.key, required this.login, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 30,
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

// ignore: must_be_immutable
class CustomButtonUpload extends StatelessWidget {
  final String login;
  void Function()? onPressed;
  bool isSelected;

  CustomButtonUpload({
    super.key,
    required this.login,
    required this.onPressed,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 30,

      child: MaterialButton(
        color: isSelected ? Colors.pink[200] : Colors.blue,
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
