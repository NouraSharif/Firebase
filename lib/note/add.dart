import 'package:app22/components/custom_button.dart';
import 'package:app22/components/customtextfieldadd.dart';
import 'package:app22/note/view.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddNote extends StatefulWidget {
  final String docid;
  const AddNote({super.key, required this.docid});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  TextEditingController note = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = false;
  AddNote() async {
    //نقلنا الكولكشن داخل الدالة لحتى يكون اسناد القيم صحيح بدون مشاكل
    //تاني شي رح نحدد الاي دي للدوكيومنت اللي رح ناخده من الكونستراكتر
    CollectionReference Collectionnote = FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.docid)
        .collection("note");
    if (formKey.currentState!.validate()) {
      try {
        isLoading = true;
        setState(() {});
        await Collectionnote.add({
          "note": note.text,

          //في درس التفكير المنطقي لابد من اضافة المعرف الخاص باليوزر مع اضافة كل قسم لمعرفة الاقسام الخاصة بكل يوزر
          //لحتى نعرف كل قسم لأي يوزر==where.. في صفحةHomepage
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NoteView(categoryid: widget.docid),
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
  void dispose() {
    note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AddNote')),
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
                        login: "Add",
                        onPressed: () {
                          AddNote();
                        },
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
