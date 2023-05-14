import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:label_music/models/ra_options.dart';
import 'package:label_music/models/ra_settings.dart';
import 'package:label_music/screens/categories_screen.dart';
import 'package:label_music/screens/courses_screen.dart';
import 'package:label_music/screens/news_screen.dart';
import 'package:label_music/screens/onboarding_screen.dart';

import '../login/login_screen.dart';
import '../models/be_analytics.dart';
import '../screens/chat_screen.dart';
import '../screens/home_screen.dart';
import '../screens/notification_screen.dart';
import '../screens/settings_screen.dart';
import '../service/api_service.dart';
import '../widgets/loading.dart';

enum SCREEN {
  home,
  courses,
  categories,
  notifications,
  chat,
  news,
  onBoarding,
  settings,
  logout,
}

class BaseScreen extends StatefulWidget {
  const BaseScreen({Key? key}) : super(key: key);

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  SCREEN selectedScreen = SCREEN.home;
  APIService service = APIService();
  double fontSize = 14;

  RASettings settings = RASettings();
  RAOptions appOptions = RAOptions();
  BeAnalytics analytics = BeAnalytics();
  bool shrinkMenu = false;

  @override
  Widget build(BuildContext context) {
    return makeRequests();
  }

  Widget copyright() {
    return Visibility(
      visible: !shrinkMenu,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: Text(
          "Разработано 2023",
          style: GoogleFonts.teko(
              fontSize: 17, fontStyle: FontStyle.normal, color: Colors.teal),
        ),
      ),
    );
  }

  Widget logo() {
    if (shrinkMenu) {
      return Padding(
        padding: const EdgeInsets.only(top: 30, left: 30, bottom: 10),
        child: GestureDetector(
          onTap: () {
            setState(() {
              shrinkMenu = !shrinkMenu;
            });
          },
          child: FaIcon(
            shrinkMenu
                ? FontAwesomeIcons.arrowsLeftRightToLine
                : FontAwesomeIcons.minimize,
            size: 18,
            color: Colors.white,
          ),
        ),
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Visibility(
                visible: !shrinkMenu,
                child: Text(
                  "Label Music",
                  style: GoogleFonts.teko(
                      fontSize: 30,
                      fontStyle: FontStyle.normal,
                      color: Colors.white),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    shrinkMenu = !shrinkMenu;
                  });
                },
                child: FaIcon(
                  shrinkMenu
                      ? FontAwesomeIcons.maximize
                      : FontAwesomeIcons.minimize,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget menuItems() {
    return Expanded(
      child: SingleChildScrollView(
        primary: false,
        child: Padding(
          padding: const EdgeInsets.only(left: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              addRow(Icons.dashboard, "Dashboard", SCREEN.home),
              addRow(Icons.school, "Жанры, артисты", SCREEN.courses),
              addRow(Icons.category, "Категории", SCREEN.categories),
              addRow(Icons.newspaper, "Новости", SCREEN.news),
              addRow(Icons.notifications, "Уведомления", SCREEN.notifications),
              addRow(Icons.chat, "Чат поддержки", SCREEN.chat),
              addRow(Icons.list_alt, "OnBoarding", SCREEN.onBoarding),
              addRow(Icons.settings, "Настройки", SCREEN.settings),
              addRow(Icons.logout, "Выйти", SCREEN.logout),
            ],
          ),
        ),
      ),
    );
  }

  changeScreenTo(SCREEN screen) {
    setState(() {
      selectedScreen = screen;
    });
  }

  Widget setSelectedNavItem(
      SCREEN screen, bool isReady, RASettings settings, RAOptions options) {
    if (!isReady) {
      return const Loading();
    }
    switch (screen) {
      case SCREEN.home:
        {
          return HomeScreen(
            analytics: analytics,
          );
        }
      case SCREEN.notifications:
        {
          return NotificationScreen(
            general: settings,
          );
        }
      case SCREEN.categories:
        {
          return CategoriesScreen(options: options);
        }
      case SCREEN.courses:
        {
          return CoursesScreen(options: options);
        }
      case SCREEN.settings:
        {
          return SettingsScreen(settings: settings);
        }
      case SCREEN.onBoarding:
        {
          return OnboardingScreen(pages: options.onboardingPages);
        }
      case SCREEN.news:
        {
          return NewsScreen(options: options);
        }
      case SCREEN.chat:
        {
          return const ChatScreen();
        }

      case SCREEN.logout:
        {
          return HomeScreen(analytics: analytics);
        }
      default:
        {
          return HomeScreen(
            analytics: analytics,
          );
        }
    }
  }

  Widget makeRequests() {
    return FutureBuilder(
        future: Future.wait([
          service.requestSettings(),
          service.requestOptions(),
          service.getAnalytics()
        ]),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          bool isReady = false;
          if (snapshot.hasData) {
            isReady = true;
            settings = snapshot.data != null ? snapshot.data![0] : RASettings();
            appOptions = snapshot.data != null && snapshot.data!.length > 1
                ? snapshot.data![1]
                : RAOptions();
            analytics = snapshot.data != null && snapshot.data!.length > 2
                ? snapshot.data![2]
                : BeAnalytics();
          }
          return Material(
            child: Container(
              color: Theme.of(context).secondaryHeaderColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: shrinkMenu ? 55 : 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [logo(), menuItems(), copyright()],
                    ),
                  ),
                  Expanded(
                      child: setSelectedNavItem(
                          selectedScreen,
                          isReady,
                          snapshot.data != null && snapshot.data!.length > 0
                              ? snapshot.data![0]
                              : settings,
                          snapshot.data != null && snapshot.data!.length > 1
                              ? snapshot.data![1]
                              : RAOptions())),
                ],
              ),
            ),
          );
        });
  }

  Widget addRow(IconData iconData, String title, SCREEN type) {
    if (shrinkMenu) {
      return GestureDetector(
        onTap: () {
          if (type == SCREEN.logout) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const LoginScreen()));
          } else {
            changeScreenTo(type);
          }
        },
        child: Row(
          children: [
            Icon(
              iconData,
              color: selectedScreen == type ? Colors.greenAccent : Colors.white,
              size: 17,
            ),
            const SizedBox(
              height: 40,
            ),
          ],
        ),
      );
    }
    return GestureDetector(
      onTap: () {
        if (type == SCREEN.logout) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const LoginScreen()));
        } else {
          changeScreenTo(type);
        }
      },
      child: Row(
        children: [
          Icon(
            iconData,
            color: selectedScreen == type ? Colors.greenAccent : Colors.white,
            size: 17,
          ),
          Visibility(
            visible: !shrinkMenu,
            child: const SizedBox(
              width: 8,
            ),
          ),
          Visibility(
            visible: !shrinkMenu,
            child: Text(
              title,
              style: selectedScreen == type
                  ? GoogleFonts.jost(
                      fontSize: fontSize,
                      color: Colors.white,
                      fontWeight: FontWeight.normal)
                  : GoogleFonts.jost(
                      fontSize: fontSize,
                      color: Colors.grey,
                      fontWeight: FontWeight.normal),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }

  Widget addFancyRow(IconData iconData, String title, SCREEN type) {
    if (shrinkMenu) {
      return GestureDetector(
        onTap: () {
          if (type == SCREEN.logout) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const LoginScreen()));
          } else {
            changeScreenTo(type);
          }
        },
        child: Row(
          children: [
            FaIcon(
              iconData,
              color: selectedScreen == type ? Colors.greenAccent : Colors.white,
              size: 17,
            ),
            const SizedBox(
              height: 40,
            ),
          ],
        ),
      );
    }
    return Row(
      children: [
        FaIcon(
          iconData,
          color: selectedScreen == type ? Colors.greenAccent : Colors.white,
          size: 17,
        ),
        const SizedBox(
          width: 8,
        ),
        GestureDetector(
            child: Text(
              title,
              style: selectedScreen == type
                  ? GoogleFonts.jost(
                      fontSize: fontSize,
                      color: Colors.white,
                      fontWeight: FontWeight.normal)
                  : GoogleFonts.jost(
                      fontSize: fontSize,
                      color: Colors.grey,
                      fontWeight: FontWeight.normal),
            ),
            onTap: () {
              if (type == SCREEN.logout) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              } else {
                changeScreenTo(type);
              }
            }),
        const SizedBox(
          height: 40,
        ),
      ],
    );
  }
}
