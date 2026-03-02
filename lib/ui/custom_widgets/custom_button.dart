import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final void Function() onPressed;
  final String text;
   CustomButton({super.key,required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(onPressed: onPressed,
    minWidth: 300.w,
    height: 40.h,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
    color: Color(0xFF5B21B6),
    elevation: 16,
    child: Text(text,style: TextStyle(
      color: Colors.white,
      fontSize: 14.sp,
      fontWeight: FontWeight.w600
    ),),
    );
  }
}
