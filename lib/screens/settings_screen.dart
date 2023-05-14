import 'package:flutter/material.dart';
import 'package:label_music/models/ra_settings.dart';

import '../app_settings.dart';
import '../service/api_service.dart';
import '../widgets/button_widget.dart';
import '../widgets/color_picker_widget.dart';
import '../widgets/dropdown_widget.dart';
import '../widgets/image_picker.dart';
import '../widgets/loading_picker.dart';
import '../widgets/textfield_widget.dart';
import '../widgets/textview_widget.dart';
import '../widgets/toggle_widget.dart';

class SettingsScreen extends StatefulWidget {
  final RASettings settings;
  const SettingsScreen({Key? key, required this.settings}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double spaceBetweenItems = 70;

  late RASettings updatedSettings;
  APIService service = APIService();
  String selectedFont = "";

  final pushNotificationsServerKey = TextEditingController();
  final companyNameController = TextEditingController();
  final companyPhoneController = TextEditingController();
  final companyEmailController = TextEditingController();
  final loadingSizeController = TextEditingController();

  Color topBarColor = Colors.black87;
  Color topBarItemColor = Colors.white;

  Color bottomBarColor = Colors.black87;
  Color bottomBarItemColor = Colors.white;
  Color bottomBarSelectedItemColor = Colors.black;

  Color loadingColor = Colors.black;

  int instantUpdates = 0;
  int enabledAnalytics = 0;
  int enableShare = 0;
  int enableSafeArea = 1;
  int enableNoInternetPopup = 0;
  int enableConstructionMode = 1;
  int enableAuthorization = 1;
  int enableFacebookLogin = 1;
  int enableGoogleLogin = 1;
  int enableEmailLogin = 1;
  int enableRTL = 1;
  int enableScreenSecurity = 1;
  int enableExitApp = 1;
  int enableLandscape = 1;
  int enableShowTitlesAlwaysForBottomMenu = 0;

  bool isScreenWide = true;

  @override
  void initState() {
    // TODO: implement initState
    updatedSettings = widget.settings.getCurrentSettings();
    companyNameController.text = widget.settings.companyName;
    companyEmailController.text = widget.settings.companyEmail;
    companyPhoneController.text = widget.settings.companyNumber;
    loadingSizeController.text = widget.settings.loadingSize.toString();
    if (widget.settings.fontName.isNotEmpty) {
      selectedFont = widget.settings.fontName;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isScreenWide = MediaQuery.of(context).size.width >= 1250;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 40, left: 50, right: 20, bottom: 20),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        headerView(),
        const SizedBox(
          height: 50,
        ),
        maintenanceMode(),
        SizedBox(
          height: spaceBetweenItems,
        ),
        companySettings(),
        SizedBox(
          height: spaceBetweenItems,
        ),
        toggles(),
        SizedBox(
          height: spaceBetweenItems,
        ),
        sectionTitle("Theme Colors"),
        themeOptions(),
        SizedBox(
          height: spaceBetweenItems,
        ),
        sectionTitle("Social"),
        socialArea(),
        SizedBox(
          height: spaceBetweenItems,
        ),
        sectionTitle("О нас"),
        aboutUsArea(),
      ],
    );
  }

  Widget aboutUsArea() {
    return BeTextView(
        title: "О нас (HTML Tags allowed)",
        subtitle: "Введите текст",
        text: updatedSettings.aboutUs,
        callback: (text) {
          updatedSettings.aboutUs = text;
        });
  }

  Widget headerView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Настройки приложения",
          style: Theme.of(context).textTheme.headline6,
        ),
        BeButton(
            name: "Сохранить",
            callback: () {
              saveSettingsAction();
            }),
      ],
    );
  }

  Widget maintenanceMode() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        BeToggle(
            name: "Включить режим тех обслуживания",
            currentIndex: updatedSettings.enableConstructionMode ? 0 : 1,
            callback: (index) {
              setState(() {
                enableConstructionMode = index;
                updatedSettings.enableConstructionMode =
                    index == 0 ? true : false;
              });
            }),
        const SizedBox(
          width: 50,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BeToggle(
                name: "Включить мгновенные обновления",
                currentIndex: updatedSettings.instantUpdates ? 0 : 1,
                callback: (index) {
                  setState(() {
                    instantUpdates = index;
                    updatedSettings.instantUpdates = index == 0 ? true : false;
                  });
                }),
            const SizedBox(
              width: 8,
            ),
            GestureDetector(
              onTap: () {
                showAlertDialog(context, "Instant Updates",
                    "Всякий раз, когда вы вносите изменения в панель администратора, клиенты в мобильном приложении будут видеть мгновенные обновления. Если вы включите это, это немного снизит производительность приложения. откройте приложение.");
              },
              child: const Icon(
                Icons.info,
                color: Colors.black54,
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget companySettings() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Логотип компании",
              style: Theme.of(context).textTheme.bodyText2,
            ),
            const SizedBox(
              height: 15,
            ),
            BeImagePicker(
              onPick: (selectedImage, imageUrl) {
                updatedSettings.logoUrl = imageUrl;
              },
              preloadedImage: updatedSettings.logoUrl,
            ),
          ],
        ),
        SizedBox(
          width: 50,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Название приложения",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: 300,
                  child: TextField(
                    obscureText: false,
                    controller: companyNameController,
                    onChanged: (value) {
                      updatedSettings.companyName = value;
                    },
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).secondaryHeaderColor,
                            width: 1.0),
                      ),
                      labelText: 'Введите название приложения',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  " Email тех поддержки",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: 300,
                  child: TextField(
                    obscureText: false,
                    controller: companyEmailController,
                    onChanged: (value) {
                      updatedSettings.companyEmail = value;
                    },
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).secondaryHeaderColor,
                            width: 1.0),
                      ),
                      labelText: 'Введите email тех поддержки',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Номер поддержки",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: 300,
                  child: TextField(
                    obscureText: false,
                    controller: companyPhoneController,
                    onChanged: (value) {
                      updatedSettings.companyNumber = value;
                    },
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).secondaryHeaderColor,
                            width: 1.0),
                      ),
                      labelText: 'Введите здесь номер телефона',
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ],
    );
  }

  Widget authorization() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BeToggle(
            name: "Включить авторизацию",
            currentIndex: updatedSettings.enableAuthorization ? 0 : 1,
            callback: (index) {
              setState(() {
                enableAuthorization = index;
                updatedSettings.enableAuthorization = index == 0 ? true : false;
              });
            }),
        const SizedBox(
          height: 50,
        ),
        Visibility(
            visible: updatedSettings.enableAuthorization,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                BeToggle(
                    name: "Enable Facebook Login",
                    currentIndex: updatedSettings.enableFacebookLogin ? 0 : 1,
                    callback: (index) {
                      setState(() {
                        enableFacebookLogin = index;
                        updatedSettings.enableFacebookLogin =
                            index == 0 ? true : false;
                      });
                    }),
                const SizedBox(
                  width: 50,
                ),
                BeToggle(
                    name: "Enable Google Login",
                    currentIndex: updatedSettings.enableGoogleLogin ? 0 : 1,
                    callback: (index) {
                      setState(() {
                        enableGoogleLogin = index;
                        updatedSettings.enableGoogleLogin =
                            index == 0 ? true : false;
                      });
                    }),
                const SizedBox(
                  width: 50,
                ),
                BeToggle(
                    name: "Enable Email Login",
                    currentIndex: updatedSettings.enableEmailLogin ? 0 : 1,
                    callback: (index) {
                      setState(() {
                        enableEmailLogin = index;
                        updatedSettings.enableEmailLogin =
                            index == 0 ? true : false;
                      });
                    }),
              ],
            ))
      ],
    );
  }

  Widget themeOptions() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Выберите шрифт приложения",
              style: Theme.of(context).textTheme.bodyText2,
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 3),
              child: BeDropdown(
                  title: "Выберите шрифт",
                  items: const [
                    "Roboto",
                    "Poppins",
                    "Open Sans",
                    "Lato",
                    "Oswald",
                    "Montserrat"
                  ],
                  callback: (value) {
                    selectedFont = value;
                    updatedSettings.fontName = value;
                  },
                  selectedValue: selectedFont),
            ),
          ],
        ),
        SizedBox(
          height: 50,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            BeColorPicker(
                name: "Цвет верхней полосы",
                currentColor: updatedSettings.getTopBarColor(),
                callback: (color) {
                  topBarColor = color;
                  List<int> navigationRGB = [
                    topBarColor.red,
                    topBarColor.green,
                    topBarColor.blue
                  ];
                  updatedSettings.topBarRGB = navigationRGB;
                  setState(() => {});
                }),
            const SizedBox(
              width: 50,
            ),
            BeColorPicker(
                name: "Цвет элементов верхней панели",
                currentColor: updatedSettings.getTopBarItemsColor(),
                callback: (color) {
                  topBarItemColor = color;
                  List<int> navigationItemsRGB = [
                    topBarItemColor.red,
                    topBarItemColor.green,
                    topBarItemColor.blue
                  ];
                  updatedSettings.topBarItemsRGB = navigationItemsRGB;
                  setState(() => {});
                }),
          ],
        ),
        const SizedBox(
          height: 50,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            BeColorPicker(
                name: "Цвет нижней полосы",
                currentColor: updatedSettings.getBottomBarColor(),
                callback: (color) {
                  bottomBarColor = color;
                  List<int> navigationRGB = [
                    bottomBarColor.red,
                    bottomBarColor.green,
                    bottomBarColor.blue
                  ];
                  updatedSettings.bottomBarRGB = navigationRGB;
                  setState(() => {});
                }),
            const SizedBox(
              width: 50,
            ),
            BeColorPicker(
                name: "Цвет элементов нижней панели",
                currentColor: updatedSettings.getBottomBarItemsColor(),
                callback: (color) {
                  bottomBarItemColor = color;
                  List<int> navigationItemsRGB = [
                    bottomBarItemColor.red,
                    bottomBarItemColor.green,
                    bottomBarItemColor.blue
                  ];
                  updatedSettings.bottomBarItemsRGB = navigationItemsRGB;
                  setState(() => {});
                }),
            const SizedBox(
              width: 50,
            ),
            BeColorPicker(
                name: "Цвет выбранных элементов нижней панели",
                currentColor: updatedSettings.getBottomBarSelectedItemsColor(),
                callback: (color) {
                  bottomBarSelectedItemColor = color;
                  List<int> navigationItemsRGB = [
                    bottomBarSelectedItemColor.red,
                    bottomBarSelectedItemColor.green,
                    bottomBarSelectedItemColor.blue
                  ];
                  updatedSettings.bottomBarSelectedItemsRGB =
                      navigationItemsRGB;
                  setState(() => {});
                }),
          ],
        ),
        const SizedBox(
          height: 50,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            BeColorPicker(
                name: "Загрузка цвета",
                currentColor: updatedSettings.getLoadingColor(),
                callback: (color) {
                  loadingColor = color;
                  List<int> navigationRGB = [
                    loadingColor.red,
                    loadingColor.green,
                    loadingColor.blue
                  ];
                  updatedSettings.loadingRGB = navigationRGB;
                  setState(() => {});
                }),
            const SizedBox(
              width: 50,
            ),
            SizedBox(
              width: 100,
              child: TextField(
                obscureText: false,
                controller: loadingSizeController,
                onChanged: (value) {
                  updatedSettings.loadingSize = int.parse(value);
                },
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).secondaryHeaderColor,
                        width: 1.0),
                  ),
                  labelText: 'Размер загрузки',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 50,
        ),
        LoadingPicker(
            selectedType: updatedSettings.loadingType,
            onChange: (type) {
              updatedSettings.loadingType = type;
            }),
        const SizedBox(
          height: 50,
        ),
      ],
    );
  }

  Widget socialArea() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            BeTextField(
                title: "Facebook",
                subtitle: "Enter facebook link",
                text: updatedSettings.facebook,
                callback: (text) {
                  updatedSettings.facebook = text;
                }),
            const SizedBox(
              width: 30,
            ),
            BeTextField(
                title: "Instagram",
                subtitle: "Enter instagram link",
                text: updatedSettings.instagram,
                callback: (text) {
                  updatedSettings.instagram = text;
                }),
          ],
        ),
        const SizedBox(
          height: 50,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            BeTextField(
                title: "Twitter",
                subtitle: "Enter twitter link",
                text: updatedSettings.twitter,
                callback: (text) {
                  updatedSettings.twitter = text;
                }),
            const SizedBox(
              width: 30,
            ),
            BeTextField(
                title: "Pinterest",
                subtitle: "Enter pinterest link",
                text: updatedSettings.pinterest,
                callback: (text) {
                  updatedSettings.pinterest = text;
                }),
          ],
        ),
        const SizedBox(
          height: 50,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            BeTextField(
                title: "LinkedIn",
                subtitle: "Enter linkedin link",
                text: updatedSettings.linkedin,
                callback: (text) {
                  updatedSettings.linkedin = text;
                }),
            const SizedBox(
              width: 30,
            ),
            BeTextField(
                title: "TikTok",
                subtitle: "Enter tiktok link",
                text: updatedSettings.tiktok,
                callback: (text) {
                  updatedSettings.tiktok = text;
                }),
          ],
        ),
        const SizedBox(
          height: 50,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            BeTextField(
                title: "YouTube",
                subtitle: "Enter vimeo link",
                text: updatedSettings.youtube,
                callback: (text) {
                  updatedSettings.youtube = text;
                }),
            const SizedBox(
              width: 30,
            ),
            BeTextField(
                title: "Vimeo",
                subtitle: "Enter youtube link",
                text: updatedSettings.vimeo,
                callback: (text) {
                  updatedSettings.vimeo = text;
                }),
          ],
        ),
      ],
    );
  }

  Widget toggles() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BeToggle(
                name: "Включить отсутствие всплывающих окон в Интернете",
                currentIndex: updatedSettings.enableNoInternetPopup ? 0 : 1,
                callback: (index) {
                  setState(() {
                    enableNoInternetPopup = index;
                    updatedSettings.enableNoInternetPopup =
                        index == 0 ? true : false;
                  });
                }),
            const SizedBox(
              height: 50,
            ),
            BeToggle(
                name: "Enable SafeArea",
                currentIndex: updatedSettings.enableSafeArea ? 0 : 1,
                callback: (index) {
                  setState(() {
                    enableSafeArea = index;
                    updatedSettings.enableSafeArea = index == 0 ? true : false;
                  });
                }),
            const SizedBox(
              height: 50,
            ),
            BeToggle(
                name: "Kill app on exit",
                currentIndex: updatedSettings.enableExitApp ? 0 : 1,
                callback: (index) {
                  setState(() {
                    enableExitApp = index;
                    updatedSettings.enableExitApp = index == 0 ? true : false;
                  });
                }),
          ],
        ),
        const SizedBox(
          width: 50,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BeToggle(
                name: "Enable Landscape",
                currentIndex: updatedSettings.enableLandscape ? 0 : 1,
                callback: (index) {
                  setState(() {
                    enableLandscape = index;
                    updatedSettings.enableLandscape = index == 0 ? true : false;
                  });
                }),
            const SizedBox(
              height: 50,
            ),
            BeToggle(
                name: "Enable RTL",
                currentIndex: updatedSettings.enableRTL ? 0 : 1,
                callback: (index) {
                  setState(() {
                    enableRTL = index;
                    updatedSettings.enableRTL = index == 0 ? true : false;
                  });
                }),
            const SizedBox(
              height: 50,
            ),
            BeToggle(
                name: "Заблокировать запись экрана",
                currentIndex: updatedSettings.enableScreenSecurity ? 0 : 1,
                callback: (index) {
                  setState(() {
                    enableScreenSecurity = index;
                    updatedSettings.enableScreenSecurity =
                        index == 0 ? true : false;
                  });
                }),
          ],
        ),
      ],
    );
  }

  saveSettingsAction() async {
    if (demoMode) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "CANNOT MODIFY DEMO ADMIN",
          style: TextStyle(color: Colors.redAccent),
        ),
      ));
      return;
    }

    await service.updateSettings(updatedSettings);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Настройки обновлены!"),
    ));
    setState(() {});
  }

  showAlertDialog(BuildContext context, String title, String subtitle) async {
    // set up the buttons
    Widget continueButton = Center(
      child: BeButton(
          name: "Понятно!",
          callback: () {
            Navigator.of(context).pop();
          }),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        title,
        style: Theme.of(context).textTheme.headline6,
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 200),
      content: Text(
        subtitle,
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

  Widget sectionTitle(String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: Theme.of(context).textTheme.headline6,
        ),
        const SizedBox(
          height: 30,
        )
      ],
    );
  }
}
