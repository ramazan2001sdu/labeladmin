import 'package:flutter/material.dart';

import '../models/be_analytics.dart';
import '../widgets/stats_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.analytics}) : super(key: key);
  final BeAnalytics analytics;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return startingWidget();
  }

  Widget startingWidget() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.only(top: 40, left: 50, right: 50),
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              primary: false,
              child: mainArea(),
            ),
          ),
        ),
      ),
    );
  }

  Widget mainArea() {
    // bool isScreenWide =
    //     MediaQuery.of(context).size.width >= kMinWidthLargeScreen;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        "Dashboard",
        style: Theme.of(context).textTheme.headline6,
      ),
      const SizedBox(
        height: 20,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          BeStats(
              name: "Посетители",
              icon: const Icon(
                Icons.people,
                color: Colors.white,
                size: 40,
              ),
              value: widget.analytics.visitors.toString(),
              colors: const [
                Colors.pinkAccent,
                Colors.pinkAccent,
              ]),
          const SizedBox(
            width: 20,
          ),
          BeStats(
              name: "Акции",
              icon: const Icon(Icons.share, color: Colors.white, size: 40),
              value: widget.analytics.userShares.toString(),
              colors: const [
                Colors.blueAccent,
                Colors.blueAccent,
              ]),
          const SizedBox(
            width: 20,
          ),
          BeStats(
              name: "Подписчики",
              icon: const Icon(
                Icons.attach_money,
                color: Colors.white,
                size: 40,
              ),
              value: widget.analytics.subscribers.toString(),
              colors: const [
                Colors.greenAccent,
                Colors.greenAccent,
              ]),
        ],
      ),
      const SizedBox(
        height: 20,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BeStats(
              name: "Посетители",
              icon: const Icon(
                Icons.library_books,
                color: Colors.white,
                size: 40,
              ),
              value: widget.analytics.openedCourses.toString(),
              colors: const [
                Colors.orangeAccent,
                Colors.orangeAccent,
              ]),
          const SizedBox(
            width: 20,
          ),
          BeStats(
              name: "iOS",
              icon: const Icon(
                Icons.apple_outlined,
                color: Colors.white,
                size: 40,
              ),
              value: widget.analytics.appleDevices.toString(),
              colors: const [
                Colors.black87,
                Colors.black87,
              ]),
          const SizedBox(
            width: 20,
          ),
          BeStats(
              name: "Android",
              icon: const Icon(
                Icons.android_outlined,
                color: Colors.white,
                size: 40,
              ),
              value: widget.analytics.androidDevices.toString(),
              colors: const [
                Colors.blueGrey,
                Colors.blueGrey,
              ]),
        ],
      ),
      const SizedBox(
        height: 20,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BeStats(
              name: "Email users",
              icon: const Icon(
                Icons.rate_review,
                color: Colors.white,
                size: 40,
              ),
              value: "33",
              colors: const [
                Colors.brown,
                Colors.brown,
              ]),
          const SizedBox(
            width: 20,
          ),
          BeStats(
              name: "Facebook users",
              icon: const Icon(
                Icons.apple_outlined,
                color: Colors.white,
                size: 40,
              ),
              value: "11",
              colors: const [
                Color.fromRGBO(45, 76, 133, 1),
                Color.fromRGBO(45, 76, 133, 1),
              ]),
          const SizedBox(
            width: 20,
          ),
          BeStats(
              name: "Google users",
              icon: const Icon(
                Icons.android_outlined,
                color: Colors.white,
                size: 40,
              ),
              value: "323",
              colors: const [
                Color.fromRGBO(248, 173, 43, 1),
                Color.fromRGBO(248, 173, 43, 1),
              ]),
        ],
      ),
      const SizedBox(
        height: 50,
      ),
    ]);
  }
}
