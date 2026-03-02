import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quizzia/providers/questions_api_provider.dart';
import 'package:quizzia/ui/custom_widgets/custom_button.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  @override
  Widget build(BuildContext context) {
    var quesApi = Provider.of<QuestionsApiProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'النتائج',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.all(20.w),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 12.h),
              Text(
                'لقد حصلت على ${quesApi.userCorrectAns}/15',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.sp),
              ),
              SizedBox(height: 16.h),
              Text(
                'لقد أجبت ${quesApi.userCorrectAns} بشكل صحيح و ${15 - quesApi.userCorrectAns} بشكل خاطئ',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12.sp),
              ),
              SizedBox(height: 40.h),
              Expanded(
                child: GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 13.w,
                  ),
                  children: [
                    Container(
                      height: 90.h,
                      decoration: BoxDecoration(
                        color: Color(0xFFDFF7E9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${quesApi.userCorrectAns}',
                            style: TextStyle(
                              color: Color(0xFF2DBE62),
                              fontWeight: FontWeight.bold,
                              fontSize: 26.sp,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'صحيح',
                            style: TextStyle(
                              color: Color(0xFF2DBE62),
                              fontWeight: FontWeight.bold,
                              fontSize: 20.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 90.h,
                      decoration: BoxDecoration(
                        color: Color(0xFFFDE4E4),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${15 - quesApi.userCorrectAns}',
                            style: TextStyle(
                              color: Color(0xFFF44336),
                              fontWeight: FontWeight.bold,
                              fontSize: 26.sp,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'خطأ',
                            style: TextStyle(
                              color: Color(0xFFF44336),
                              fontWeight: FontWeight.bold,
                              fontSize: 20.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              CustomButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    'home',
                    (returns) => false,
                  );
                },
                text: 'العودة للصفحة الرئيسية',
              ),
              SizedBox(height: 55.h),
            ],
          ),
        ),
      ),
    );
  }
}
