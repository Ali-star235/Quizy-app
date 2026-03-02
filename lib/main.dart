import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quizzia/providers/questions_api_provider.dart';
import 'package:quizzia/ui/screens/home_screen.dart';
import 'package:quizzia/ui/screens/login_screen.dart';
import 'package:quizzia/ui/screens/question_screen.dart';
import 'package:quizzia/ui/screens/registration_screen.dart';
import 'package:quizzia/ui/screens/results_screen.dart';
import 'package:quizzia/ui/screens/splash_screen.dart';
import 'package:quizzia/providers/auth_provider.dart';
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ScreenUtilInit(
  minTextAdapt: true,
  splitScreenMode: true,
  builder: (context, child) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
        ChangeNotifierProvider(create: (_) => QuestionsApiProvider()),
      ],
      child: MyApp(),
    );
  },));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<StatefulWidget> {
  @override
  void initState() {
  super.initState();

  WidgetsBinding.instance.addPostFrameCallback((_) {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('+++==========================User is currently signed out!');
      } else {
        print('++++++++===================User is signed in!');
      }
    });
  });
}

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: Color(0xFFF3F2F8)),
      home: SplashScreen(),
      locale: const Locale('ar'),
      navigatorKey: navigatorKey,
      routes: {
        'login' : (context) =>  LoginScreen(),
        'signUp' : (context) =>  RegistrationScreen(),
        'home' : (context) =>  HomeScreen(),
        'question' : (context) =>  QuestionScreen(),
        'result' : (context) =>  ResultsScreen(),
      },
    );
  }
}
