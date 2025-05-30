import 'package:app22/components/custom_button.dart';
import 'package:app22/components/customtextfieldadd.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  TextEditingController name = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  CollectionReference categories = FirebaseFirestore.instance.collection(
    'categories',
  );

  bool isLoading = false;
  Future<void> addCategory() async {
    // Call the Category's CollectionReference to add a new Category
    return categories
        .add({
          "name": name.text,
          //في درس التفكير المنطقي لابد من اضافة المعرف الخاص باليوزر مع اضافة كل قسم لمعرفة الاقسام الخاصة بكل يوزر
          //لحتى نعرف كل قسم لأي يوزر==where.. في صفحةHomepage
          "id": await FirebaseAuth.instance.currentUser!.uid,
        })
        .then((value) => print("Category Added: ${name.text}"))
        .catchError((error) => print("Failed to add category: $error"));
  }

  @override
  void dispose() {
    name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AddCategory')),
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
                        login: "Add",
                        onPressed: () {
                          //لحتى ما نرسل داتا فارغة للـ firebase بنتحقق من الحقل
                          if (formKey.currentState!.validate()) {
                            // Add your logic to add the category here
                            try {
                              isLoading = true;
                              setState(() {});
                              addCategory();
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
