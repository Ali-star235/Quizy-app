import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {  
    Timer(Duration(seconds: 7), () {
      if (FirebaseAuth.instance.currentUser != null){
        Navigator.pushReplacementNamed(context, 'home');
      }
      else{
        Navigator.pushReplacementNamed(context, 'signUp');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipOval(
              child: Image.asset(
                'assets/images/quiz_logo_only.png',
                height: 85.h,
              ),
            ),
            SizedBox(height: 15.h),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Quizzy',
                    style: TextStyle(
                      color: Color(0xFF1E293B),
                      fontSize: 30.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: 'App',
                    style: TextStyle(
                      color: Color(0xFF5B21B6),
                      fontSize: 30.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 17.h),
            Text(
              'هيا لنتعلم',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
