import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quizzia/providers/auth_provider.dart';
import 'package:quizzia/ui/custom_widgets/custom_button.dart';
import 'package:quizzia/ui/custom_widgets/custom_dialog.dart';
import 'package:quizzia/ui/custom_widgets/custom_text_field.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  GlobalKey<FormState> formState = GlobalKey();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  @override
  void dispose() {
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    username.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<AuthenticationProvider>(context, listen: false);
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Selector<AuthenticationProvider, bool>(
            selector: (context, auth) => auth.isLoading,
            builder: (context, isLoading, child) {
              if (isLoading) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 340.h),
                    CircularProgressIndicator(),
                  ],
                );
              } else {
                return Form(
                  key: formState,
                  child: Column(
                    children: [
                      SizedBox(height: 120.h),
                      Text(
                        'إنشاء حساب',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 26.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'لنبدأ معك!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF9D9BAE),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 40.h),
                      CustomTextField(
                        controller: username,
                        secure: false,
                        hint: 'اسم المستخدم',
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'لا يمكن ترك اسم المستخدم فارغًا';
                          }
                        },
                      ),
                      CustomTextField(
                        secure: false,
                        hint: 'البريد الإلكتروني',
                        controller: email,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'لا يمكن ترك البريد الإلكتروني فارغًا';
                          }
                          if (!(val.contains('@') || val.contains('.com'))) {
                            return 'بيانات بريد إلكتروني غير صحيحة';
                          }
                        },
                      ),
                      CustomTextField(
                        secure: true,
                        hint: 'كلمة المرور',
                        controller: password,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'لا يمكن ترك كلمة المرور فارغة';
                          }
                        },
                      ),
                      CustomTextField(
                        secure: true,
                        hint: 'تأكيد كلمة المرور',
                        controller: confirmPassword,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'لا يمكن ترك الحقل فارغًا';
                          }
                          if (val != password.text) {
                            return 'كلمات المرور غير متطابقة';
                          }
                        },
                      ),
                      SizedBox(height: 33.h),

                      CustomButton(
                        onPressed: () async {
                          if (formState.currentState!.validate()) {
                            await auth.creatAccount(
                              email: email.text.trim(),
                              password: password.text.trim(),
                            );
                            if (auth.authState == AuthState.success) {
                              Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  'home',
                                  (returns) => false,
                                );
                            } else if (auth.authState ==
                                AuthState.weakPassword) {
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return CustomDialog(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: Icons.lock_outline,
                                    title: 'كلمة مرور ضعيفة',
                                    desc:
                                        'كلمة مرورك ضعيفة. جرب كلمة أقوى.',
                                  );
                                },
                              );
                            } else if (auth.authState == AuthState.usedEmail) {
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return CustomDialog(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: Icons.email,
                                    title: 'البريد الإلكتروني مستخدم مسبقًا',
                                    desc:
                                        'البريد الإلكتروني مستخدم بالفعل. جرّب بريدًا آخر.',
                                  );
                                },
                              );
                            }
                          }
                        },
                        text: 'تسجيل حساب',
                      ),
                      SizedBox(height: 27.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'login');
                            },
                            child: Text(
                              'تسجيل الدخول',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Color(0xFF5B21B6),
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                          Text(
                            'لديك حساب بالفعل؟',
                            style: TextStyle(
                              color: Color(0xFF9D9BAE),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
