import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiAi {
  bool isConnected = true;
  static const String apiKey = 'AIzaSyD42f80Db_rDzwHni-9I-HnywXI8_MVpmE';
  var aiModel = GenerativeModel(model: 'gemini-2.5-flash', apiKey: apiKey);
  int numberOfAssists = 0;
  Future generateAns({required String question}) async {
    try {
      var content = [Content.text(question)];
      final response = await aiModel.generateContent(content);
      numberOfAssists++;
      return response.text;
    } catch (e) {
      isConnected = false;
    }
  }
}
