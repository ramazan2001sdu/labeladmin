import 'dart:convert';
import 'dart:html' as html;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:label_music/models/category.dart';
import 'package:label_music/models/ra_options.dart';
import 'package:label_music/models/ra_settings.dart';
import 'package:uuid/uuid.dart';

import '../models/be_analytics.dart';
import '../models/conversation.dart';
import '../models/onboarding_page.dart';
import '../models/post.dart';

class APIService {
  final CollectionReference settingsCollection =
      FirebaseFirestore.instance.collection("settings");
  final CollectionReference messagesCollection =
      FirebaseFirestore.instance.collection("conversations");
  final CollectionReference analyticsCollection =
      FirebaseFirestore.instance.collection("analytics");

  //SETTINGS FUNCTIONS---------------------------------------------------------------------
  Future updateSettings(RASettings settings) async {
    await settingsCollection.doc("settings").set(settings.toJson());
  }

  Future<RASettings> requestSettings() async {
    DocumentSnapshot<Object?> snapshot =
        await settingsCollection.doc("settings").get();
    RASettings settings = RASettings();

    if (snapshot.data() == null) {
      return settings;
    }
    return RASettings.fromJson(snapshot.data() as Map<dynamic, dynamic>);
  }

  Future<RAOptions> requestOptions() async {
    DocumentSnapshot<Object?> snapshot =
        await settingsCollection.doc("options").get();

    if (snapshot.data() == null) {
      return RAOptions();
    }

    Map<dynamic, dynamic> itemsMaps = snapshot.data() as Map<dynamic, dynamic>;

    return RAOptions.fromJson(itemsMaps);
  }
  //----------------------------------------------------------------------------------------

  Future<String> uploadImage(html.File image) async {
    var uuid = const Uuid();
    String fileName = uuid.v1();
    final _firebaseStorage = FirebaseStorage.instance;

    //Upload to Firebase
    var snapshot =
        await _firebaseStorage.ref().child('images/$fileName').putBlob(image);
    var downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> uploadVideo(html.File video) async {
    var uuid = const Uuid();
    String fileName = uuid.v1();
    final _firebaseStorage = FirebaseStorage.instance;

    //Upload to Firebase
    var snapshot =
        await _firebaseStorage.ref().child('videos/$fileName').putBlob(video);
    var downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<bool> sendPushNotification(
      String title, String message, RASettings settings) async {
    String key = settings.pushNotificationsServerKey;
    String accessToken = await getAccessToken();
    final response = await http.post(
      Uri.parse(
          'https://fcm.googleapis.com/v1/projects/rocket-academy/messages:send'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(<String, dynamic>{
        "message": {
          "topic": "messaging",
          "notification": {"title": title, "body": message},
          "data": {"msgId": "msg_12342"},
        }
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<String> getJson() {
    return rootBundle.loadString(
        'label-music-acae2-firebase-adminsdk-wepu8-67ed4470f7.json');
  }

  Future<String> getAccessToken() async {
    String json = await getJson();
    var serviceAccount = jsonDecode(json);

    final accountCredentials = ServiceAccountCredentials.fromJson(json);

    final scopes = ["https://www.googleapis.com/auth/firebase.messaging"];

    final AuthClient authClient =
        await clientViaServiceAccount(accountCredentials, scopes);

    return authClient.credentials.accessToken.data;
  }

  Future updateOnBoardingPages(List<OnboardingPage> items) async {
    bool keyExist = await checkIfKeyExist("onBoardingPages");
    if (keyExist) {
      await settingsCollection
          .doc("options")
          .update({"onBoardingPages": items.map((v) => v.toJson()).toList()});
    } else {
      await settingsCollection
          .doc("options")
          .set({"onBoardingPages": items.map((v) => v.toJson()).toList()});
    }
  }

  Future checkIfKeyExist(String key) async {
    DocumentSnapshot<Object?> snapshot =
        await settingsCollection.doc("options").get();
    if (snapshot.data() != null) {
      return true;
    } else {
      return false;
    }
  }

  sendMessage(Conversation conversation, String userId) async {
    await messagesCollection.doc(userId).update(conversation.toJson());
  }

  void removeConversation(String conversationID) async {
    await messagesCollection.doc(conversationID).delete();
  }

  Future updateCategories(List<RACategory> items) async {
    bool keyExist = await checkIfKeyExist("categories");
    if (keyExist) {
      await settingsCollection
          .doc("options")
          .update({"categories": items.map((v) => v.toJson()).toList()});
    } else {
      await settingsCollection
          .doc("options")
          .set({"categories": items.map((v) => v.toJson()).toList()});
    }
  }

  Future updatePosts(List<Post> items) async {
    bool keyExist = await checkIfKeyExist("posts");
    if (keyExist) {
      await settingsCollection
          .doc("options")
          .update({"posts": items.map((v) => v.toJson()).toList()});
    } else {
      await settingsCollection
          .doc("options")
          .set({"posts": items.map((v) => v.toJson()).toList()});
    }
  }

  Future<BeAnalytics> getAnalytics() async {
    DocumentSnapshot<Object?> snapshot =
        await analyticsCollection.doc("analytics").get();
    if (snapshot.data() != null) {
      Map<dynamic, dynamic> analyticsData =
          snapshot.data() as Map<dynamic, dynamic>;
      BeAnalytics analytics = BeAnalytics.fromJson(analyticsData);
      return analytics;
    } else {
      return BeAnalytics();
    }
  }
}
