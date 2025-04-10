// ignore_for_file: file_names
import 'package:app22/components/custom_button.dart';
import 'package:app22/components/custom_logo.dart';
import 'package:app22/components/custom_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

// ignore: camel_case_types
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _Login();
}

// ignore: camel_case_types
class _Login extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _isPasswordObscure = true;

  bool isLoading = false;

  //تسجيل الدخول بواسطة جوجل
  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    //بلاحظ لو بعمل كانسل لشاشة اختيار الايميل بظهرلي خطا بالاوتبوت
    //لانه فيه قيمة بترجعلي نل فهاي القيمة بتسبب مشاكل للفانكشن اللي بعدها
    if (googleUser == null) {
      // User canceled the sign-in
      return;
    } //لحتى يخرج من الدالة

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    //عند الضغط رخ تظهر جميع الاليميلات الخاصة فيا في جوجل
    //اذا تمت العملية بنجاح رح اخليه ينقلني على الصفحة الرئيسية
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil("homepage", (Route<dynamic> route) => false);
  }

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
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Container(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: formKey,
                  child: ListView(
                    children: [
                      Container(height: 10),
                      const testLogo(icon: Icons.badge),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Login",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                          Container(height: 5),
                          const Text(
                            "Login to continue using the app",
                            style: TextStyle(color: Colors.grey, fontSize: 15),
                          ),
                          Container(height: 15),
                          CustomText(
                            label: "Email",
                            hintText: "Enter your email ",
                            controller: email,
                            validator: (String? value) {
                              if (email.text.isEmpty) {
                                return "Please enter your email";
                              }
                              return null;
                            },
                          ),
                          Container(height: 10),
                          CustomText(
                            label: "Password",
                            hintText: "Enter password ",
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
                        ],
                      ),
                      Container(height: 7),
                      InkWell(
                        onTap: () async {
                          //عند نسيان كلمة المرور بالضغط على هاي الكلمة رح يرسل بريد بكتابة كلمة المرور الجديدة
                          //ومباشرة بتستخدمها مع الاليميل للدخول للرئيسية
                          if (email.text.isEmpty) {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.error,
                              animType: AnimType.topSlide,
                              title: "Error",
                              desc: "Please enter your email",
                              btnOkOnPress: () {},
                            ).show();
                            return;
                          }
                          try {
                            //هاي الدالة ممكن يصير فيها ايرور مثلا الايميل مش موجود
                            /*
                        في النهاية في خلل بسيط:بانه ازا المستخدم ادخل ايميل عشوائي مش موجود بالفايربيز
                        بينبعتله رسالة على الايميل لتغيير كلمة السر
                        فلازم يكون الحساب موجود بالفايربيز===بتنحل عن طريق الشات جي بي تي
                            */
                            await FirebaseAuth.instance.sendPasswordResetEmail(
                              email: email.text.trim(),
                            );
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.success,
                              animType: AnimType.topSlide,
                              title: "Success",
                              desc: "Check your email to reset password",
                              btnOkOnPress: () {},
                            ).show();
                          } catch (e) {
                            print(e);
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.error,
                              animType: AnimType.topSlide,
                              title: "Error",
                              desc: "Failed to send reset password email",
                              btnOkOnPress: () {},
                            ).show();
                          }
                        },
                        child: Text(
                          textAlign: TextAlign.right,
                          "Forget Password?",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Container(height: 10),
                      CustomButtonAuth(
                        login: "Login",
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            try {
                              //اول ما نبلش بجلب الداتا بتظهر ايقونة التحميل
                              isLoading = true;
                              setState(() {});
                              await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                    email: email.text.trim(),
                                    password: password.text,
                                  );
                              //ولما يتم جلب الداتا بتم ازالتها
                              isLoading = false;
                              setState(() {});
                              //التحقق من البريد
                              if (FirebaseAuth
                                      .instance
                                      .currentUser
                                      ?.emailVerified ==
                                  false) {
                                FirebaseAuth.instance.currentUser
                                    ?.sendEmailVerification();
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.error,
                                  animType: AnimType.topSlide,
                                  title: "Error",
                                  desc: "Please verify your email",
                                  btnOkOnPress: () {},
                                ).show();
                              } else {
                                Navigator.of(
                                  context,
                                ).pushReplacementNamed("homepage");
                              }
                            } on FirebaseAuthException catch (e) {
                              //في حالة الايرور  بيظهر الديالوق ولكن عند عمل اوك تبقة الصفحة في حالة التحميل
                              //لانه التحميل ما زال شغال في حالة جلب الداتا ولكن حصل كاتش معين ولم ينتهي التحميل
                              //فعند حدوث الخطا لابد من اغلاق التحميل
                              isLoading = false;
                              setState(() {});
                              switch (e.code) {
                                case 'user-not-found':
                                  _showErrorDialog("Error", "User not found");
                                  break;
                                case 'wrong-password':
                                  _showErrorDialog("Error", "Wrong password");
                                  break;
                                default:
                                  _showErrorDialog("Error", " ${e.message}");
                              }
                            }
                          }
                        },
                      ),
                      Container(height: 30),
                      CustomButtonAuth(
                        login: "LogIn With Google",
                        onPressed: () async {
                          await signInWithGoogle();
                          //عند الضغط رخ تظهر جميع الاليميلات الخاصة فيا في جوجل
                        },
                      ),
                      /*
              //التصميم الاساسي 
              //لكن رح نحط بداله زر تسجيل الدخول بواسطة جوجل عوضا عن الايميل والباسوورد
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

             //-------------
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
                            Rect.fromLTRB(
                              0.0,
                              0.0,
                              bounds.width,
                              bounds.height,
                            ),
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
              */
                      Container(height: 10),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Do not have an account?"),
                            InkWell(
                              onTap: () {
                                //لحتى ما تنحفظ صفحة login في الذاكرة
                                Navigator.of(
                                  context,
                                ).pushReplacementNamed("register");
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
              ),
    );
  }
}
