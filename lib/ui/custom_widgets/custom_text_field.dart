import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final String? Function(String?) validator;
  final TextEditingController? controller;
  final bool secure;
  const CustomTextField({
    super.key,
    required this.hint,
    required this.validator,
    this.controller,
    required this.secure,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(17, 10, 17, 10),
      child: TextFormField(
        controller: controller,
        validator: validator,
        obscureText: secure,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(13.r),
          ),
          fillColor: Colors.grey[300],
          filled: true,
          hintText: hint,
          hintStyle: TextStyle(color: Color(0xFF8C8C9A)),
        ),
      ),
    );
  }
}
