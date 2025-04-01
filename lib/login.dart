// ignore_for_file: file_names

import 'dart:convert' show jsonDecode;

import 'package:app22/custom/custom_button.dart';
import 'package:app22/custom/custom_logo.dart';
import 'package:app22/custom/custom_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart'
    show AnimType, AwesomeDialog, DialogType;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

// ignore: camel_case_types
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _Login();
}

// ignore: camel_case_types
class _Login extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Container(height: 10),
            const testLogo(icon: Icons.badge),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Login",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
                Container(height: 5),
                const Text(
                  "Login to continue using the app",
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
                Container(height: 15),
                const testText(label: "Email", hintText: "Enter your email "),
                Container(height: 10),
                const testText(label: "Password", hintText: "Enter password "),
              ],
            ),
            Container(height: 7),
            const Text(
              textAlign: TextAlign.right,
              "Forget Password?",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.grey,
              ),
            ),
            Container(height: 10),
            CustomButtonAuth(
              login: "Login",
              onPressed:
                  () =>
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.info,
                        animType: AnimType.rightSlide,
                        title: 'Dialog Title',
                        desc: 'Fetching data from the server...',
                        btnCancelOnPress: () {},
                        btnOkOnPress: () async {
                          try {
                            final response = await http
                                .get(
                                  Uri.parse(
                                    "https://jsonplaceholder.typicode.com/posts",
                                  ),
                                )
                                .timeout(
                                  const Duration(seconds: 10),
                                  onTimeout: () {
                                    throw Exception("Request timed out");
                                  },
                                );

                            if (response.statusCode == 200) {
                              final responseBody = jsonDecode(response.body);

                              if (responseBody is List &&
                                  responseBody.isNotEmpty) {
                                if (kDebugMode) {
                                  print(
                                    "First Title: ${responseBody[0]['title']}",
                                  );
                                }
                              } else {
                                if (kDebugMode) {
                                  print("No data found.");
                                }
                              }
                            } else {
                              if (kDebugMode) {
                                print("Server error: ${response.statusCode}");
                              }
                            }
                          } catch (e) {
                            if (kDebugMode) {
                              print("Error occurred: $e");
                            }
                          }
                        },
                      ).show(),
            ),
            Container(height: 30),
            const Row(
              children: [
                Expanded(child: Divider(color: Colors.grey)),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.0,
                  ), // مسافة بين الخط والنص
                  child: Text(
                    "Or Login with",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                Expanded(child: Divider(color: Colors.grey)),
              ],
            ),
            Container(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: 50,
                  width: 110,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 248, 242, 242),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  margin: const EdgeInsets.all(10),
                  child: IconButton(
                    icon: const Text(
                      'f', // حرف 'F' لتمثيل فيسبوك
                      style: TextStyle(
                        fontSize: 26,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {},
                  ),
                ),
                Container(
                  height: 50,
                  width: 110,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 248, 242, 242),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  margin: const EdgeInsets.all(10),
                  child: IconButton(
                    onPressed: () {},
                    icon: ShaderMask(
                      shaderCallback: (bounds) {
                        return const LinearGradient(
                          colors: [
                            Colors.blue,
                            Colors.red,
                            Colors.yellow,
                            Colors.green,
                          ],
                        ).createShader(
                          Rect.fromLTRB(0.0, 0.0, bounds.width, bounds.height),
                        );
                      },
                      child: const Text(
                        'G',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  width: 110,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 248, 242, 242),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  margin: const EdgeInsets.all(10),
                  child: IconButton(
                    icon: const Icon(
                      Icons.apple,
                      color: Colors.black,
                      size: 30,
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            Container(height: 10),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Do not have an account?"),
                  InkWell(
                    onTap: () {
                      //لحتى ما تنحفظ صفحة login في الذاكرة
                      Navigator.of(context).pushReplacementNamed("register");
                    },
                    child: const Text(
                      "Register",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
