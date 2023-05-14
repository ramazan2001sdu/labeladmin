import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../widgets/button_widget.dart';
import '../../../widgets/textfield_widget.dart';
import '../../../widgets/textview_widget.dart';
import '../app_settings.dart';
import '../models/onboarding_page.dart';
import '../service/api_service.dart';
import '../widgets/image_picker.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key, required this.pages}) : super(key: key);
  final List<OnboardingPage> pages;
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final titleFieldController = TextEditingController();
  final textFieldController = TextEditingController();
  String onBoardingPageImageUrl = "";
  List<OnboardingPage> onBoardingPages = [];

  Image image = const Image(
    image: AssetImage("images/logo_white.png"),
  );

  @override
  void initState() {
    // TODO: implement initState
    onBoardingPages = List.from(widget.pages);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isScreenWide = MediaQuery.of(context).size.width >= 1400;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Scaffold(
        body: SingleChildScrollView(
          primary: false,
          child: Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Padding(
              padding: const EdgeInsets.only(top: 40, left: 50, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  header(),
                  Flex(
                    direction: isScreenWide ? Axis.horizontal : Axis.vertical,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: isScreenWide
                        ? [mainArea(), phoneArea(), activeItems()]
                        : [
                            mainArea(),
                            const SizedBox(
                              height: 40,
                            ),
                            phoneArea(),
                            const SizedBox(
                              height: 40,
                            ),
                            activeItems()
                          ],
                  ),
                  const SizedBox(
                    height: 50,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Создание посадочных страниц",
          style: Theme.of(context).textTheme.headline6,
        ),
        const SizedBox(
          height: 50,
        ),
      ],
    );
  }

  Widget mainArea() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BeTextField(
            title: "Название для страницы",
            subtitle: "Введите название",
            text: titleFieldController.text,
            callback: (text) {
              titleFieldController.text = text;
            }),
        const SizedBox(
          height: 20,
        ),
        BeTextView(
            title: "Добавить текст",
            subtitle: "Напишите текст",
            text: textFieldController.text,
            callback: (text) {
              textFieldController.text = text;
            }),
        const SizedBox(
          height: 20,
        ),
        BeImagePicker(
          onPick: (selectedImage, imageUrl) {
            image = selectedImage;
            onBoardingPageImageUrl = imageUrl;
          },
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            BeButton(
                name: "Добавить страницу",
                callback: () {
                  addOnboardingPage();
                }),
            const SizedBox(
              width: 20,
            ),
            BeButton(
                name: "Предварительный просмотр",
                callback: () {
                  setState(() {});
                }),
          ],
        ),
      ],
    );
  }

  Widget phoneArea() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Предварительный просмотр начальной страницы",
          style: Theme.of(context).textTheme.bodyText2,
        ),
        const SizedBox(
          height: 15,
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 300,
              height: 500,
              child: Image.asset("images/onboarding_page.png"),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 235),
              child: SizedBox(
                width: 130,
                height: 130,
                child: onBoardingPageImageUrl.isNotEmpty
                    ? Image(image: NetworkImage(onBoardingPageImageUrl))
                    : image,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: SizedBox(
                width: 190,
                height: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      titleFieldController.text,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      textFieldController.text,
                      maxLines: 5,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w200,
                          color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget activeItems() {
    return SizedBox(
      width: 300,
      height: 500,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Активные onboarding-страницы",
            style: Theme.of(context).textTheme.bodyText2,
          ),
          const SizedBox(
            height: 15,
          ),
          ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: [
              for (int index = 0; index < onBoardingPages.length; index += 1)
                Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    onBoardingPages.removeAt(index);
                    removeOnBoardingPage();
                  },
                  child: Card(
                    elevation: 9,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.only(right: 50),
                        child: Container(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: onBoardingItem(onBoardingPages[index]),
                          ),
                        ),
                      ),
                      onTap: () {
                        OnboardingPage page = onBoardingPages[index];
                        setState(() {
                          titleFieldController.text = page.title;
                          textFieldController.text = page.text;
                          onBoardingPageImageUrl = page.imageUrl;
                        });
                      },
                    ),
                  ),
                ),
            ],
          )
        ],
      ),
    );
  }

  Widget onBoardingItem(OnboardingPage page) {
    return Text(page.title, style: Theme.of(context).textTheme.bodyText1);
  }

  addOnboardingPage() async {
    if (demoMode) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "CANNOT MODIFY DEMO ADMIN",
          style: TextStyle(color: Colors.redAccent),
        ),
      ));
      return;
    }
    OnboardingPage page = OnboardingPage(
        title: titleFieldController.text,
        text: textFieldController.text,
        imageUrl: onBoardingPageImageUrl);
    onBoardingPages.add(page);
    APIService service = APIService();
    await service.updateOnBoardingPages(onBoardingPages);
    setState(() {});
  }

  removeOnBoardingPage() async {
    if (demoMode) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "CANNOT MODIFY DEMO ADMIN",
          style: TextStyle(color: Colors.redAccent),
        ),
      ));
      return;
    }
    APIService service = APIService();
    await service.updateOnBoardingPages(onBoardingPages);
    setState(() {});
  }
}
