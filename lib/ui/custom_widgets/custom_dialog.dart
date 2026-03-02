import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quizzia/ui/custom_widgets/custom_button.dart';

class CustomDialog extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;
  final void Function() onPressed;
  const CustomDialog({
    super.key,
    required this.icon,
    required this.title,
    required this.desc,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.all(2),
      child: AlertDialog(
        icon: Icon(icon, size: 50.w.h),
        iconPadding: EdgeInsets.only(top: 26.h, bottom: 8.h),
        iconColor: Color(0xFF1E293B),
        backgroundColor: Colors.white,
        title: Text(title, style: TextStyle(color: Colors.black)),
        titlePadding: EdgeInsets.fromLTRB(30, 30, 30, 10),
        content: Text(
          desc,
          style: TextStyle(color: Colors.black),
          textAlign: TextAlign.center,
        ),
        
        actions: [
          CustomButton(
            onPressed: onPressed,
            text: 'حسنًا',
          ),
        ],
      ),
    );
  }
}
