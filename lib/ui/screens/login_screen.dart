import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quizzia/providers/auth_provider.dart';
import 'package:quizzia/ui/custom_widgets/custom_button.dart';
import 'package:quizzia/ui/custom_widgets/custom_dialog.dart';
import 'package:quizzia/ui/custom_widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> formState = GlobalKey();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  void dispose() {
    email.dispose();
    password.dispose();
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
                      SizedBox(height: 185.h),
                      Text(
                        'مرحبًا بعودتك',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 26.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'تسجيل الدخول لمتابعة رحلة الاختبارات الخاصة بك',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF9D9BAE),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 40.h),
                      CustomTextField(
                        controller: email,
                        secure: false,
                        hint: 'البريد الإلكتروني',
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
                        controller: password,
                        secure: true,
                        hint: 'كلمة المرور',
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'لا يمكن ترك كلمة المرور فارغة';
                          }
                        },
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          SizedBox(width: 240),
                          TextButton(
                            onPressed: () async {
                              if (email.text.isEmpty) {
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return CustomDialog(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: Icons.warning_amber_outlined,
                                      title: 'البريد الإلكتروني مطلوب',
                                      desc:
                                          'عفوًا! تحتاج إلى إدخال بريدك الإلكتروني حتى نتمكن من إرسال رابط إعادة تعيين كلمة المرور لك.',
                                    );
                                  },
                                );
                              } else {
                                try {
                                  await auth.resetPassword(email: email.text);
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return CustomDialog(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: Icons.done,
                                        title: 'تم إرسال الرابط!',
                                        desc:
                                            'تحقق من صندوق الوارد! لقد أرسلنا لك رابطًا لإعادة تعيين كلمة المرور.',
                                      );
                                    },
                                  );
                                } catch (e) {
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return CustomDialog(
                                        onPressed: () {
                                          auth.stopLoading();
                                          Navigator.pop(context);
                                        },
                                        icon: Icons.warning,
                                        title: 'بريد إلكتروني غير صالح',
                                        desc:
                                            'جرّب تصحيح البريد الإلكتروني المكتوب',
                                      );
                                    },
                                  );
                                }
                              }
                            },
                            child: Text(
                              'هل نسيت كلمة المرور؟',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Color(0xFF5B21B6),
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30.h),
                      CustomButton(
                        onPressed: () async {
                          if (formState.currentState!.validate()) {
                            await auth.signIn(
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
                                AuthState.userNotFound) {
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return CustomDialog(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: Icons.warning_amber_outlined,
                                    title: 'فشل تسجيل الدخول',
                                    desc:
                                        'همم... يبدو أنك لا تملك حسابًا بعد. جرّب إنشاء حساب!',
                                  );
                                },
                              );
                            }
                          }
                        },
                        text: 'تسجيل الدخول',
                      ),
                      SizedBox(height: 25.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'signUp');
                            },
                            child: Text(
                              'إنشاء حساب',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Color(0xFF5B21B6),
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                          Text(
                            'ليس لديك حساب؟',
                            style: TextStyle(
                              color: Color(0xFF9D9BAE),
                              fontSize: 13.sp,
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
