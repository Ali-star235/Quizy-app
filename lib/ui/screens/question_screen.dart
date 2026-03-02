import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quizzia/models/gemini_ai.dart';
import 'package:quizzia/providers/questions_api_provider.dart';
import 'package:quizzia/ui/custom_widgets/custom_button.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  String? choice;
  PageController pageController = PageController();
  bool isAiLoading = false;
  GeminiAi geminiAi = GeminiAi();
  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var quesApi = Provider.of<QuestionsApiProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          quesApi.questions['results'][0]['category'],
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, 17),
        child: PageView.builder(
          controller: pageController,
          physics: NeverScrollableScrollPhysics(),
          onPageChanged: (value) => setState(() {}),
          itemCount: quesApi.questions['results'].length,
          itemBuilder: (context, i) {
            return Column(
              children: [
                SizedBox(height: 10.h),
                Text(
                  'سؤال ${i + 1}/15 ',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 10),
                LinearProgressIndicator(
                  borderRadius: BorderRadius.circular(12),
                  value: (i + 1) / 15,
                  backgroundColor: Color(0xFFE9D8FD),
                  valueColor: AlwaysStoppedAnimation(Color(0xFF5B21B6)),
                  minHeight: 10.h,
                ),
                SizedBox(height: 32.h),
                Text(
                  quesApi.questions['results'][i]['question'],
                  style: TextStyle(fontSize: 19.sp, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 42.h),
                Expanded(
                  child: ListView.builder(
                    itemCount: 4,
                    itemBuilder: (context, item) {
                      return Column(
                        children: [
                          SizedBox(height: 9.h),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.black),
                            ),
                            child: RadioListTile(
                              controlAffinity: ListTileControlAffinity.trailing,
                              title: Text(quesApi.choices[i][item]),
                              value: quesApi.choices[i][item],
                              groupValue: choice,
                              onChanged: (val) {
                                setState(() {
                                  choice = val;
                                });
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(height: 90.h),
                Row(
                  children: [
                    IgnorePointer(
                      ignoring: choice == null,
                      child: MaterialButton(
                        onPressed: i == 14
                            ? () {
                                quesApi.validateAnswer(choice: choice, i: i);
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  'result',
                                  (returns) => false,
                                );
                              }
                            : () {
                                quesApi.validateAnswer(choice: choice, i: i);
                                pageController.animateToPage(
                                  i + 1,
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.fastOutSlowIn,
                                );
                                choice = null;
                              },
                        color: choice == null
                            ? Color(0xFFD4DCE5)
                            : Color(0xFF6EE7B7),
                        minWidth: 220.w,
                        height: 40.h,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'التالي',
                          style: TextStyle(
                            color: choice == null
                                ? Color(0xFF6B7280)
                                : Color(0xFF0F172A),
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    IgnorePointer(
                      ignoring: geminiAi.numberOfAssists >= 4,
                      child: MaterialButton(
                        onPressed: () async {                        
                          setState(() {
                            isAiLoading = true;
                          });
                          var answer = await geminiAi.generateAns(
                            question:
                                "Answer the following question by selecting one of the provided choices.Your response MUST consist ONLY of the **exact word** that is the correct choice, with absolutely no other text, punctuation, or explanation.Question: ${quesApi.questions['results'][i]['question']}?Choices A. ${quesApi.choices[i][0]} B. ${quesApi.choices[i][1]} C. ${quesApi.choices[i][2]} D. ${quesApi.choices[i][3]}",
                          );
                          setState(() {
                            isAiLoading = false;
                          });
                          showModalBottomSheet(
                            isDismissible: false,
                            context: context,
                            builder: (context) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Center(
                                  child: ListView(
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            'المساعد الذكي',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15.sp,
                                            ),
                                          ),
                                          SizedBox(height: 100.h),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              geminiAi.isConnected? Text(
                                                'إجابة الذكاء الاصطناعي هي',
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.grey[600],
                                                ),
                                              ) : Text(
                                                'لا يوجد اتصال بالإنترنت',
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                              SizedBox(height: 20),
                                              Container(
                                                width: 190.w,
                                                height: 50.h,
                                                decoration: BoxDecoration(
                                                  color: Color(0xFFE4D7FE),
                                                  borderRadius: BorderRadius.circular(
                                                    10,
                                                  ),
                                                ),
                                                child: Center(
                                                  child:  Text(
                                                    '$answer',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.deepPurple,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 18.sp,
                                                    ),
                                                  ) ,
                                                ),
                                              ),
                                              SizedBox(height: 60.h),
                                              CustomButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                text: 'فهمت',
                                              ),
                                              SizedBox(height: 50.h),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        height: 40.h,
                        color: geminiAi.numberOfAssists >= 4?Color(0xFFD4DCE5):
                        Color(0xFFE4D7FE),
                        child: isAiLoading? CircularProgressIndicator(padding: EdgeInsets.all(8),) : Icon(
                          Icons.auto_awesome_outlined,
                          color: geminiAi.numberOfAssists >= 4?Color(0xFF6B7280):
                          Colors.deepPurple,
                          size: 28.h.w,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
