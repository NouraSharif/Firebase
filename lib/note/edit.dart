import 'package:app22/components/custom_button.dart';
import 'package:app22/components/customtextfieldadd.dart';
import 'package:app22/note/view.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditNote extends StatefulWidget {
  final String notedocid;
  final String categoryid; //عشان اول ما نعدل الملاحظة ننتقل ع صفحة NoteView
  final String value; //هاي قيمة الملاحظة المبدئية
  const EditNote({
    super.key,
    required this.notedocid,
    required this.categoryid,
    required this.value,
  });

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  TextEditingController note = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = false;
  editNote() async {
    //نقلنا الكولكشن داخل الدالة لحتى يكون اسناد القيم صحيح بدون مشاكل
    //تاني شي رح نحدد الاي دي للدوكيومنت اللي رح ناخده من الكونستراكتر
    CollectionReference Collectionnote = FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.categoryid)
        .collection("note");
    if (formKey.currentState!.validate()) {
      try {
        isLoading = true;
        setState(() {});
        await Collectionnote.doc(widget.notedocid).update({"note": note.text});
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NoteView(categoryid: widget.categoryid),
          ),
        );
      } catch (e) {
        print("$e");
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
  }

  @override
  void initState() {
    note.text = widget.value; //هاي قيمة الملاحظة المبدئية
    super.initState();
  }

  @override
  void dispose() {
    note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('EditNote')),
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
                        label: "Edit this note :",
                        hintText: "Enter Your Note",
                        controller: note,
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
                          editNote();
                        },
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
