import 'package:app22/note/add.dart';
import 'package:app22/note/edit.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

// ignore: must_be_immutable
class NoteView extends StatefulWidget {
  final String categoryid;
  const NoteView({required this.categoryid, super.key});

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  //عرض جميع الداتا داخل كولكشن معين==QuerySnapshot

  //دالة initState بتشتغل اول ما تفتح الصفحة
  //دالة git بترجعلي الداتا اللي بالفايرستور
  //موجودة بالدوكيمنت بس رح نعملها
  List<QueryDocumentSnapshot> data = [];
  //لاظهار اشارة تحميل
  bool isLoading = true;
  late String categoryid;

  getdata() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance
            .collection("categories")
            //رح احدد القسم اللي بدي اعرض ملاحظاته من خلال الاي دي اله
            //بعدها احدد الكولكشن اللي فيه==لانه كل قسم يقبل كولكشن واحد فقط بينما الكولكشن مجموعة اقسام
            .doc(widget.categoryid)
            .collection("note")
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddNote(docid: widget.categoryid),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        title: const Text("Note"),
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
      body: WillPopScope(
        //عند عمل باك ينقلني لصفحة معينة
        child:
            isLoading
                ? SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: const Center(
                    child:
                        //لحتى تظهر اشارة التحميل بطريقة جميلة
                        CircularProgressIndicator(),
                  ),
                )
                : GridView.builder(
                  itemCount: data.length,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (context, i) {
                    return InkWell(
                      onLongPress: () async {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.warning,
                          animType: AnimType.topSlide,
                          title: 'Warning',
                          desc: 'Are you sure to delete this note?',
                          btnOkText: "Delete",
                          btnOkOnPress: () async {
                            await FirebaseFirestore.instance
                                .collection("categories")
                                .doc(widget.categoryid)
                                .collection("note")
                                .doc(data[i].id)
                                .delete();

                            //اذا كان مع الملاحظة مرفق صورة او ملف لا بد انه نحذفه معها
                            //لخفض التكلفة مثلا
                            //وبنفس الوقت لازم نتاكد ازا الملاحظة مرفق معها ملف ولا لا لحتى ما يصير عنا خطا
                            if (data[i]['url'] != 'none') {
                              FirebaseStorage.instance
                                  .refFromURL(data[i]['url'])
                                  .delete();
                            }
                            setState(() {
                              data.removeAt(i);
                            });
                            //بعد ما عملت حذف للملاحظة مباشرة ياخذني على صفحة viewnote
                          },
                        ).show();
                      },
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder:
                                (context) => EditNote(
                                  notedocid: data[i].id,
                                  value: data[i]['note'],
                                  categoryid: widget.categoryid,
                                ),
                          ),
                        );
                      },
                      child: Card(
                        child: ListView(
                          padding: EdgeInsets.all(15),
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Text("${data[i]['note']}"),
                                  SizedBox(height: 10),
                                  // اذا المستخدم حمل صورة مع الملاحظة رح نحملها
                                  if (data[i]['image'] != "none")
                                    Image.network(
                                      "${data[i]['image']}",
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        onWillPop: () {
          Navigator.pushNamedAndRemoveUntil(
            context,
            "homepage",
            (Route<dynamic> route) => false,
          );
          return Future.value(false);
        },
      ),
    );
  }
}
