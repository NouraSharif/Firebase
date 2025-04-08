import 'package:flutter/material.dart';

class CustomTextFormAdd extends StatelessWidget {
  final String label;
  final String hintText;
  final bool isPassword;
  final bool obscureText;
  final VoidCallback? onToggleObscure;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  CustomTextFormAdd({
    Key? key,
    required this.label,
    required this.hintText,
    required this.controller,
    required this.validator,
    this.isPassword = false,
    this.obscureText = false,
    this.onToggleObscure,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller, // إضافة الـ controller هنا
          validator: validator,
          obscureText: isPassword ? obscureText : false,
          decoration: InputDecoration(
            fillColor: const Color.fromARGB(255, 243, 240, 240),
            filled: true,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(100)),
              borderSide: BorderSide.none,
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(100)),
              borderSide: BorderSide.none,
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(100)),
              borderSide: BorderSide.none,
            ),
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 15),
            suffixIcon:
                isPassword
                    ? IconButton(
                      icon: Icon(
                        obscureText ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: onToggleObscure,
                    )
                    : null,
          ),
        ),
      ],
    );
  }
}
