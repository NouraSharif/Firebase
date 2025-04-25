import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({super.key});

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? file;
  String? url;

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ImagePickerWidget')),
      body: Column(
        children: [
          Container(height: 50),
          MaterialButton(
            color: Colors.pink[200],
            onPressed: () {
              getFile();
            },
            child: Text("Pick Image"),
          ),
          if (url != null)
            //استخدمنا النت ورك لانه الصورة موجودة على الاستضافة الخاصة بالفايربيز على الانترنت
            Image.network(url!),
        ],
      ),
    );
  }
}
