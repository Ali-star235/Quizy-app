// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quizzia/main.dart';
import 'package:quizzia/providers/auth_provider.dart';
import 'package:quizzia/providers/questions_api_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map> categories = [
    {'name': 'الرياضة', 'icon': Icons.sports_soccer, 'endPoint': 21},
    {'name': 'التاريخ', 'icon': Icons.menu_book_rounded, 'endPoint': 23},
    {'name': 'الحاسوب', 'icon': Icons.computer_rounded, 'endPoint': 18},
    {'name': 'الرياضيات', 'icon': Icons.calculate, 'endPoint': 19},
    {
      'name': 'ألعاب الفيديو',
      'icon': Icons.sports_esports_rounded,
      'endPoint': 15,
    },
    {'name': 'العلوم', 'icon': Icons.science_outlined, 'endPoint': 17},
  ];
  @override
  Widget build(BuildContext context) {
    var quesApi = Provider.of<QuestionsApiProvider>(context, listen: false);
    var authApi = Provider.of<AuthenticationProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: () async {
                  await authApi.signOut();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    'login',
                    (returns) => false,
                  );
                },
                child: Row(children: [Text(' تسجيل الخروج',style: TextStyle(
                  color: Colors.red
                ),),
                Icon(Icons.exit_to_app_outlined,color: Colors.red,)
                ]),
              ),
            ],
          ),
        ],
        centerTitle: true,
        title: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Quizzy',
                style: TextStyle(
                  color: Color(0xFF1E293B),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: 'App',
                style: TextStyle(
                  color: Color(0xFF5B21B6),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(23),
        child: Selector<QuestionsApiProvider, bool>(
          selector: (context, api) => api.isLoading,
          builder: (context, isLoading, child) {
            if (isLoading) {
              return Center(
                child: quesApi.isConnected
                    ? CircularProgressIndicator()
                    : Text(
                        'No Internet connection! ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[600],
                        ),
                      ),
              );
            } else {
              return Column(
                children: [
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10.h,
                        crossAxisSpacing: 20.w,
                      ),
                      itemCount: categories.length,
                      itemBuilder: (context, i) {
                        return InkWell(
                          onTap: () async {
                            await quesApi.getQuiz(
                              endPoint: categories[i]['endPoint'],
                            );
                            if (quesApi.questions.isNotEmpty) {
                              navigatorKey.currentState!.pushNamed('question');
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 27.w),
                                  height: 40.h,
                                  width: 40.w,
                                  child: Icon(
                                    categories[i]['icon'],
                                    color: Color(0xFF5B21B6),
                                    size: 57.h,
                                  ),
                                ),
                                SizedBox(height: 32.h),
                                Text(
                                  categories[i]['name'],
                                  style: TextStyle(
                                    color: Color(0xFF0F0F19),
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
