import 'package:firebase_core/firebase_core.dart';

import 'models/be_user.dart';

const bool demoMode = false;
const int kMinWidthLargeScreen = 980;

class AppSettings {
  //ADMINS
  List<BeUser> admins = [
    BeUser(username: "admin@demo.com", password: "admin"),
    BeUser(username: "root", password: "root"),
    BeUser(username: "label", password: "1234567"),
  ];

  //CHANGE FIREBASE SETTINGS FOR WEB ADMIN HERE
  FirebaseOptions firebaseOptions = const FirebaseOptions(
      apiKey: "AIzaSyAN9b7rxtMn0-ZZud0QAX9vVXgk9aYyccA",
      authDomain: "label-music-acae2.firebaseapp.com",
      projectId: "label-music-acae2",
      storageBucket: "label-music-acae2.appspot.com",
      messagingSenderId: "162386717401",
      appId: "1:162386717401:web:fa9d64c7e13103a024ecc8");

  AppSettings();

  bool isAdmin(String username, String password) {
    for (BeUser admin in admins) {
      if (admin.username == username && admin.password == password) {
        return true;
      }
    }
    return false;
  }
}
