import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_settings.dart';
import '../base/base_screen.dart';
import '../widgets/button_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(33, 33, 33, 1),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Music Label",
              style: GoogleFonts.teko(
                  fontSize: 70,
                  fontStyle: FontStyle.normal,
                  color: Colors.white),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: 500,
              height: 300,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(40))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 400,
                    child: TextField(
                      maxLines: 1,
                      obscureText: false,
                      controller: userNameController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).secondaryHeaderColor,
                              width: 1.0),
                        ),
                        labelText: 'Username',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 400,
                    child: TextField(
                      maxLines: 1,
                      obscureText: true,
                      controller: passwordController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).secondaryHeaderColor,
                              width: 1.0),
                        ),
                        labelText: 'Password',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  BeButton(
                      name: "Войти",
                      callback: () {
                        loginAction();
                      }),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Разработано 2023",
              style: GoogleFonts.teko(
                  fontSize: 22,
                  fontStyle: FontStyle.normal,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  void loginAction() {
    AppSettings settings = AppSettings();
    if (settings.isAdmin(userNameController.text, passwordController.text)) {
      //showAlertDialog(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BaseScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("неверные имя пользователя или пароль"),
      ));
    }
  }

  showAlertDialog(BuildContext context) async {
    // set up the buttons
    Widget continueButton = TextButton(
      child: Text(
        "Go ahead",
        style: Theme.of(context).textTheme.bodyText2,
      ),
      onPressed: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BaseScreen()),
        );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "DEMO",
        style: Theme.of(context).textTheme.headline6,
      ),
      content: Text(
        "This is demo of our Admin Panel and it is not attached to the demo apk file to prevent users to remove the content of the app.",
        style: Theme.of(context).textTheme.bodyText2,
      ),
      actions: [
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
