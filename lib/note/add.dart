import 'dart:io';
import 'package:app22/components/custom_button.dart';
import 'package:app22/components/customtextfieldadd.dart';
import 'package:app22/note/view.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class AddNote extends StatefulWidget {
  final String docid;
  const AddNote({super.key, required this.docid});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  TextEditingController note = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  //لتحميل الصورة مع الملاحظة
  File? file;
  String? url;

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
          //بدنا نضيف عنوان الصورة  اللي بدنا نحملها
          //في حال كان مش موجود رح نضيف none
          //من خلال الurl بقدر اعرض الصورة بالنهاية==view.dart
          "image": url ?? 'none',
          //في درس التفكير المنطقي لابد من اضافة المعرف الخاص باليوزر مع اضافة كل قسم لمعرفة الاقسام الخاصة بكل يوزر
          //لحتى نعرف كل قسم لأي يوزر==where.. في صفحةHomepage
        });
        Navigator.push(
          this.context,
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
          // ignore: use_build_context_synchronously
          context: this.context,
          dialogType: DialogType.error,
          animType: AnimType.topSlide,
          title: 'Error',
          desc: 'Failed to add category.',
          btnOkOnPress: () {},
        ).show();
      }
    }
  }

  //لتحميل الصورة مع الملاحظة

  getFile() async {
    final ImagePicker picker = ImagePicker();
    // Pick an image.
    final XFile? imagegallery = await picker.pickImage(
      source: ImageSource.gallery,
    );
    // Capture a photo.
    /*final XFile? imageCamera = await picker.pickImage(
      source: ImageSource.camera,
    );*/
    //حتى لو ما اخترنا الصورة عند الضغط ع الزر
    //لحتى تكون الامور تمام بنضيف هذا الشرط
    if (imagegallery != null) {
      file = File(imagegallery.path);

      //cloud Storge ==خدمة تخزين سحابي==ليس مجانية على الفايربيز
      //اول اشي بنجيب اسم الصورة بعدها المكان اللي رح نخزن فيه الصورة لى الستورج بعدها بنرفع الصورة
      //بعدها بنجيب الرابط الخاص بالصورة لحتى نعرضها باليوزر انترفيس اسفل الكود
      var imagename = basename(imagegallery.path);
      //لاضافة الصورة داخل المجلد
      //ref("اسم المجلد").child(imagename);
      //او==ref("اسم المجلد/اسم الصورة");
      var refstorge = FirebaseStorage.instance.ref("images$imagename");
      await refstorge.putFile(file!);
      url = await refstorge.getDownloadURL();
    }
    setState(() {});
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
                        label: "note detailes:",
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
                    SizedBox(height: 20),
                    CustomButtonUpload(
                      login: 'Loading Images',
                      onPressed: () {
                        getFile();
                      },
                      isSelected: url != null ? true : false,
                    ),
                    Container(height: 10),
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
