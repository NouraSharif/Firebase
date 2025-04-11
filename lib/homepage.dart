import 'package:app22/categories.dart/edit.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  //عرض جميع الداتا داخل كولكشن معين==QuerySnapshot

  //دالة initState بتشتغل اول ما تفتح الصفحة
  //دالة git بترجعلي الداتا اللي بالفايرستور
  //موجودة بالدوكيمنت بس رح نعملها
  List<QueryDocumentSnapshot> data = [];
  //لاظهار اشارة تحميل
  bool isLoading = true;

  getdata() async {
    QuerySnapshot
    querySnapshot =
        //لحتى نعرف كل قسم لأي يوزر==where.. في صفحةHomepage
        //بنحدد اسم الحق==id
        //وبكتب انه يجيبلي فقط الاقسام الخاصة باليوزر
        //where==اعطيني جميع الدوك الخاصة بهذا الكولكشن اللي بكون فيها الحقل اي دي يساوي الاي دي كزا اللي برجعلي من اليوزر اللي مسجل دخوله.
        await FirebaseFirestore.instance
            .collection("categories")
            .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .get();
    data.addAll(querySnapshot.docs);
    //عشان نعمل تحديث للصفحة بعد ما نجيب الداتا
    //لانه رح تتغير قيمة الداتا
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink[200],
        onPressed: () {
          Navigator.pushNamed(context, "addCategory");
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        title: const Text("Home Page"),
        //بدي اعمل ايقونة خاصة بتسجيل الخروج من خلال الفايربيز
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // هنا يمكنك إضافة كود تسجيل الخروج من Firebase
              // على سبيل المثال:
              FirebaseAuth.instance.signOut();
              Navigator.pushNamedAndRemoveUntil(
                context,
                "login",
                (route) => false,
              );
              //بعد تسجيل الدخول باستخدام جوجل المرات اللي بعدها ما بتظهر شاشة لاختيار الايميل
              //لذلك بدي احذف الايميل من الذاكرة
              //مقابل تسجيل الدخول باستخدام جوجل بنعمل تسجيل الخروج باستخدامه
              //بنعمل instance
              GoogleSignIn googleSignIn = GoogleSignIn();
              googleSignIn.disconnect();
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          isLoading
              ? SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: const Center(
                  child:
                      //لحتى تظهر اشارة التحميل بطريقة جميلة
                      CircularProgressIndicator(),
                ),
              )
              : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //عرض الداتا
                  GridView.builder(
                    itemCount: data.length,
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                    itemBuilder: (context, i) {
                      return InkWell(
                        onLongPress: () {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.warning,
                            animType: AnimType.rightSlide,
                            title: 'Dialog Title',
                            desc: 'اختر ماذا تريد ان تفعل',

                            btnOkText: "تعديل",
                            btnCancelText: "حذف",
                            btnCancelOnPress: () async {
                              await FirebaseFirestore.instance
                                  .collection("categories")
                                  .doc(data[i].id)
                                  .delete();
                              //بعد تنفيذ عملية الحذف لازم ارجع اوجه المستخدم لنفس الصفحة لحتى تنعمللها عملية ريفرش
                              Navigator.of(
                                context,
                              ).pushReplacementNamed("homepage");
                            },
                            btnOkOnPress: () {
                              //بعد ما اضغط على تعديل رح ينقلني على صفحة التعديل
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder:
                                      (context) => EditCategory(
                                        docid: data[i].id,
                                        oldname: data[i]['name'],
                                      ),
                                ),
                              );
                            },
                          ).show();
                        },
                        child: Card(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("images/file.jpg"),
                              Text("${data[i]['name']}"),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  //----------------------------------------------------
                  Container(height: 10),
                  const Text("Welcome to the Home Page!"),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "register");
                    },
                    child: const Text("Go to Register"),
                  ),
                  Container(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "login");
                    },
                    child: const Text("Go to Login"),
                  ),
                ],
              ),
        ],
      ),
    );
  }
}
