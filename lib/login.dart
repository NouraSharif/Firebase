// ignore_for_file: file_names

import 'package:app22/custom/custom_button.dart';
import 'package:app22/custom/custom_logo.dart';
import 'package:app22/custom/custom_text.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class login100 extends StatefulWidget {
  const login100({super.key});

  @override
  State<login100> createState() => _login100();
}

// ignore: camel_case_types
class _login100 extends State<login100> {
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
            const TestButton(login: "Login"),
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
                        fontSize: 26, // حجم الخط
                        color: Colors.blue, // تعيين اللون الأزرق
                        fontWeight: FontWeight.bold, // تعيين الخط العريض
                      ),
                    ),
                    onPressed: () {
                      // هنا تضع الكود الذي يتم تنفيذه عند الضغط على الأيقونة
                    },
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
                    onPressed: () {
                      // هنا تضع الكود الذي يتم تنفيذه عند الضغط على الأيقونة
                    },
                    icon: ShaderMask(
                      shaderCallback: (bounds) {
                        return const LinearGradient(
                          colors: [
                            Colors.blue, // الأزرق
                            Colors.red, // الأحمر
                            Colors.yellow, // الأصفر
                            Colors.green, // الأخضر
                          ],
                        ).createShader(
                          Rect.fromLTRB(0.0, 0.0, bounds.width, bounds.height),
                        ); // تطبيق التدرج
                      },
                      child: const Text(
                        'G', // حرف 'G' لتمثيل Google
                        style: TextStyle(
                          fontSize: 26, // حجم الخط
                          fontWeight: FontWeight.bold, // جعل الخط عريض
                          color:
                              Colors
                                  .white, // اللون الافتراضي للنص (لن يظهر بسبب التدرج اللوني)
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
                      Navigator.of(context).pushNamed("register");
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
