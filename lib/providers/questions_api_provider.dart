import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class QuestionsApiProvider with ChangeNotifier {
  bool isLoading = false;
  Map questions = {};
  List<List> choices = [];
  List correctAns = [];
  int userCorrectAns = 0;
  bool isConnected = true;
  Future getQuiz({required int endPoint}) async {
    isLoading = true;
    notifyListeners();
    choices = [];
    correctAns = [];
    userCorrectAns = 0;
    try {
      var response = await get(
        Uri.parse(
          'https://opentdb.com/api.php?amount=15&category=$endPoint&type=multiple',
        ),
      );
      var responseBody = jsonDecode(response.body);
      questions = responseBody;
      provideChoices();
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isConnected = false;
    }
  }

  provideChoices() {
    List questionChoices = [];
    for (var ques in questions['results']) {
      questionChoices.addAll(ques['incorrect_answers']);
      questionChoices.add(ques['correct_answer']);
      questionChoices.shuffle();
      questionChoices.shuffle();
      choices.add(questionChoices);
      questionChoices = [];
      correctAns.add(ques['correct_answer']);
    }
  }

  validateAnswer({required String? choice, required int i}) {
    if (choice == correctAns[i]) {
      userCorrectAns++;
    }
  }
}
