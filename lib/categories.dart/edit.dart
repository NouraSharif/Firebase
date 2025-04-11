import 'package:app22/components/custom_button.dart';
import 'package:app22/components/customtextfieldadd.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditCategory extends StatefulWidget {
  final String docid;
  final String oldname;

  const EditCategory({super.key, required this.docid, required this.oldname});

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  TextEditingController name = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  CollectionReference categories = FirebaseFirestore.instance.collection(
    'categories',
  );

  bool isLoading = false;

  editCategory() async {
    //رح نضيف الايدي الخاص بالدوك اللي رح نقوم بتعديله
    //بنطالب المستخدم يقوم بادخاله
    //وايضا لازم نمرر للمستخدم الاسم القديم
    await categories.doc(widget.docid).update({'name': name.text});
  }

  @override
  void initState() {
    name.text = widget.oldname;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('EditCategory')),
      body: Form(
        key: formKey,
        child:
            isLoading
                ? Center(child: CircularProgressIndicator())
                : Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                        top: 20,
                        bottom: 10,
                        left: 20,
                        right: 20,
                      ),
                      width: double.infinity,
                      child: CustomTextFormAdd(
                        label: "category name:",
                        hintText: "Enter category name",
                        controller: name,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Please enter category name";
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      width: 100,
                      child: CustomButtonAuth(
                        login: "Save",
                        onPressed: () {
                          //لحتى ما نرسل داتا فارغة للـ firebase بنتحقق من الحقل
                          if (formKey.currentState!.validate()) {
                            // Add your logic to add the category here
                            try {
                              isLoading = true;
                              setState(() {});
                              editCategory();
                              //بعد اضافة القسم رح ننقل المستخدم على صفحة الاقسام==homepage
                              //isLoading = false; بدونها لانه مباشرة رح ينقلني على الصفحة
                              //لكن لو حدث خطا هنا رح تبقى القيمة ترو وما رح ينقلني على الصفحة
                              //لهيك عند الخطا في الكاتش رح اعطيه قيمة فولس
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                "homepage",
                                (Route<dynamic> route) => false,
                              );
                            } catch (e) {
                              // في حال صار خطأ في عملية الإضافة
                              isLoading = false;
                              setState(() {});
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.topSlide,
                                title: 'Error',
                                desc: 'Failed to add category.',
                                btnOkOnPress: () {},
                              ).show();
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
