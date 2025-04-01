// ignore_for_file: file_names

import 'package:flutter/material.dart';

// ignore: camel_case_types
class testLogo extends StatelessWidget {
  final IconData icon;

  const testLogo({super.key, required this.icon});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(30),
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 243, 240, 240),
          borderRadius: BorderRadius.all(Radius.circular(100)),
        ),
        child: ClipRRect(child: Icon(icon, color: Colors.blue, size: 60)),
      ),
    );
  }
}
