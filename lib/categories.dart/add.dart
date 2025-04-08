import 'package:app22/components/custom_button.dart';
import 'package:app22/components/customtextfieldadd.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<void> addCategory() {
    // Call the Category's CollectionReference to add a new Category
    return categories
        .add({"name": name.text})
        .then((value) => print("Category Added: ${name.text}"))
        .catchError((error) => print("Failed to add category: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AddCategory')),
      body: Form(
        key: formKey,
        child: Column(
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
                      addCategory();
                      //بعد اضافة القسم رح ننقل المستخدم على صفحة الاقسام==homepage
                      Navigator.pushReplacementNamed(context, "homepage");
                    } catch (e) {
                      // في حال صار خطأ في عملية الإضافة
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
