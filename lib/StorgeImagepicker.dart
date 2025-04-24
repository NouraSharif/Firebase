import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({super.key});

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? file;

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
          if (file != null) Image.file(file!),
        ],
      ),
    );
  }
}
