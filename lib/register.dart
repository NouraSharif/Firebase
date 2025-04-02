// ignore_for_file: file_names
import 'package:app22/custom/custom_button.dart';
import 'package:app22/custom/custom_logo.dart';
import 'package:app22/custom/custom_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _Register();
}

class _Register extends State<Register> {
  bool _isPasswordObscure = true;
  bool _isConfirmPasswordObscure = true;

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void _showErrorDialog(String title, String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.topSlide,
      title: title,
      desc: message,
      btnOkOnPress: () {},
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
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
                  CustomText(
                    label: "Username",
                    hintText: "Enter your name",
                    controller: name,
                    validator: (String? value) {
                      if (name.text.isEmpty) {
                        return "Please enter your name";
                      }
                      return null;
                    },
                  ),
                  Container(height: 10),
                  CustomText(
                    label: "Email",
                    hintText: "Enter your email",
                    controller: email,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your email";
                      }
                      return null;
                    },
                  ),
                  Container(height: 10),
                  CustomText(
                    label: "Password",
                    hintText: "Enter password",
                    controller: password,
                    isPassword: true,
                    obscureText: _isPasswordObscure,
                    onToggleObscure: () {
                      setState(() {
                        _isPasswordObscure = !_isPasswordObscure;
                      });
                    },
                    validator: (String? value) {
                      if (password.text.isEmpty) {
                        return "Please enter your password";
                      }
                      return null;
                    },
                  ),
                  Container(height: 10),
                  CustomText(
                    label: "Confirm password",
                    hintText: "Enter confirm password",
                    controller: confirmPassword,
                    isPassword: true,
                    obscureText: _isConfirmPasswordObscure,
                    onToggleObscure: () {
                      setState(() {
                        _isConfirmPasswordObscure = !_isConfirmPasswordObscure;
                      });
                    },
                    validator: (String? value) {
                      if (confirmPassword.text.isEmpty) {
                        return "Please enter your confirm password";
                      } else if (confirmPassword.text != password.text) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
                  ),
                  Container(height: 20),
                  CustomButtonAuth(
                    login: "Register",
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        try {
                          await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                email: email.text.trim(),
                                password: password.text,
                              );
                          Navigator.of(
                            context,
                          ).pushReplacementNamed("homepage");
                        } on FirebaseAuthException catch (e) {
                          switch (e.code) {
                            case 'weak-password':
                              _showErrorDialog(
                                'Weak Password',
                                'The password provided is too weak.',
                              );
                              break;
                            case 'email-already-in-use':
                              _showErrorDialog(
                                'Email Already In Use',
                                'The account already exists for that email.',
                              );
                              break;
                            case 'invalid-email':
                              _showErrorDialog(
                                'Invalid Email',
                                'The email address is badly formatted.',
                              );
                              break;
                            default:
                              _showErrorDialog(
                                'Error',
                                'Firebase Error: ${e.message}',
                              );
                          }
                        }
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
