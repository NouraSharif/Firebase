// ignore_for_file: file_names

import 'package:app22/custom/custom_button.dart';
import 'package:app22/custom/custom_logo.dart';
import 'package:app22/custom/custom_text.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _Register();
}

class _Register extends State<Register> {
  bool _isPasswordObscure = true;
  bool _isConfirmPasswordObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Container(height: 20),
            const testLogo(icon: Icons.badge),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Register",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
                Container(height: 5),
                const Text(
                  "Enter Your Personal Information",
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
                Container(height: 15),
                const testText(label: "Username", hintText: "Enter your name"),
                Container(height: 10),
                const testText(label: "Email", hintText: "Enter your email"),
                Container(height: 10),
                testText(
                  label: "Password",
                  hintText: "Enter password",
                  isPassword: true,
                  obscureText: _isPasswordObscure,
                  onToggleObscure: () {
                    setState(() {
                      _isPasswordObscure = !_isPasswordObscure;
                    });
                  },
                ),
                Container(height: 10),
                testText(
                  label: "Confirm password",
                  hintText: "Enter confirm password",
                  isPassword: true,
                  obscureText: _isConfirmPasswordObscure,
                  onToggleObscure: () {
                    setState(() {
                      _isConfirmPasswordObscure = !_isConfirmPasswordObscure;
                    });
                  },
                ),
                Container(height: 20),
                InkWell(
                  onTap: () {
                    // Navigator.of(context).pushReplacementNamed("homepage");
                  },
                  child: CustomButtonAuth(
                    login: "Register",
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed("homepage");
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
