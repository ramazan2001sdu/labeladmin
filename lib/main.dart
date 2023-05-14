import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:label_music/app_settings.dart';
import 'package:label_music/login/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: AppSettings().firebaseOptions);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Label Music',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        secondaryHeaderColor: Colors.black87,
        textTheme: TextTheme(
          headline1: GoogleFonts.ubuntu(fontSize: 75, color: Colors.black87),
          headline2: GoogleFonts.ubuntu(fontSize: 65, color: Colors.black87),
          headline3: GoogleFonts.ubuntu(fontSize: 55, color: Colors.black87),
          headline4: GoogleFonts.ubuntu(fontSize: 45, color: Colors.black87),
          headline5: GoogleFonts.ubuntu(fontSize: 35, color: Colors.black87),
          headline6: GoogleFonts.ubuntu(
              fontSize: 25, color: Colors.black87, fontWeight: FontWeight.bold),
          bodyText1: GoogleFonts.ubuntu(
              fontSize: 18, color: Colors.black87, fontWeight: FontWeight.bold),
          bodyText2: GoogleFonts.ubuntu(fontSize: 16, color: Colors.black87),
          caption: GoogleFonts.gochiHand(fontSize: 22, color: Colors.black87),
          button: GoogleFonts.ubuntu(fontSize: 16, color: Colors.white),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
