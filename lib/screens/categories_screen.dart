import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:label_music/models/category.dart';
import 'package:label_music/models/ra_options.dart';
import 'package:uuid/uuid.dart';

import '../app_settings.dart';
import '../service/api_service.dart';
import '../widgets/button_widget.dart';
import '../widgets/image_picker.dart';
import '../widgets/textfield_widget.dart';

class CategoriesScreen extends StatefulWidget {
  CategoriesScreen({Key? key, required this.options}) : super(key: key);
  RAOptions options;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  APIService service = APIService();
  String selectedValue = "Home";
  List<RACategory> items = [];

  final nameTextController = TextEditingController();
  String selectedImageUrl = "";
  bool isScreenWide = true;

  StateSetter? _setState;

  @override
  void initState() {
    // TODO: implement initState
    items = List.from(widget.options.categories);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isScreenWide = MediaQuery.of(context).size.width >= 950;
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
            body: Flex(
              direction: isScreenWide ? Axis.horizontal : Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(child: mainArea()),
                const SizedBox(
                  width: 50,
                  height: 50,
                ),
                sideArea()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget sideArea() {
    return Expanded(
      child: SingleChildScrollView(
        primary: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Текущие активные категории",
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Проведите влево, чтобы удалить категорию",
              style: Theme.of(context).textTheme.bodyText2,
            ),
            const SizedBox(
              height: 50,
            ),
            ReorderableListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              primary: false,
              children: <Widget>[
                for (int index = 0; index < items.length; index += 1)
                  Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) {
                      if (demoMode) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                            "CANNOT MODIFY DEMO ADMIN",
                            style: TextStyle(color: Colors.redAccent),
                          ),
                        ));
                        return;
                      }
                      setState(() {
                        items.removeAt(index);
                        updateItems("Категория удалена");
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Material(
                        elevation: 5,
                        color: Colors.white,
                        child: ListTile(
                          minVerticalPadding: 10,
                          tileColor: Colors.white,
                          selectedColor: Colors.white,
                          selectedTileColor: Colors.white,
                          title: Padding(
                            padding: const EdgeInsets.only(right: 50),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    items[index].name,
                                    style: GoogleFonts.ubuntu(
                                        fontSize: 16, color: Colors.black),
                                  )
                                ],
                              ),
                            ),
                          ),
                          onTap: () {
                            showEditDialog(context, items[index], index);
                          },
                        ),
                      ),
                    ),
                  ),
              ],
              onReorder: (int oldIndex, int newIndex) {
                if (demoMode) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                      "CANNOT MODIFY DEMO ADMIN",
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  ));
                  return;
                }
                setState(() {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  final RACategory item = items.removeAt(oldIndex);
                  items.insert(newIndex, item);
                  updateItems("Изменения сохранены");
                });
              },
            )
          ],
        ),
      ),
    );
  }

  Widget mainArea() {
    String title = "Категории";
    String subtitle = "Добавить категории";

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        title,
        style: Theme.of(context).textTheme.headline6,
      ),
      const SizedBox(
        height: 50,
      ),
      Text(
        subtitle,
        style: Theme.of(context).textTheme.bodyText2,
      ),
      const SizedBox(
        height: 10,
      ),
      options(),
      const SizedBox(
        height: 20,
      ),
      BeButton(
          name: "Добавить категорию",
          callback: () {
            addItem();
          }),
    ]);
  }

  Widget options() {
    return categoryOptions();
  }

  Widget categoryOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        titleForItem(
            "Название", 'Введите название категории.', nameTextController),
        const SizedBox(
          height: 20,
        ),
        BeImagePicker(
          onPick: (selectedImage, imageUrl) {
            selectedImageUrl = imageUrl;
          },
          preloadedImage: selectedImageUrl,
        ),
      ],
    );
  }

  addItem() async {
    RACategory item = RACategory(courses: []);
    item.name = nameTextController.text;
    item.imageUrl = selectedImageUrl;
    item.categoryID = const Uuid().v4();
    if (item.name.isEmpty) {
      return;
    }

    items.add(item);
    clearAllControllers();

    if (demoMode) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "CANNOT MODIFY DEMO ADMIN",
          style: TextStyle(color: Colors.redAccent),
        ),
      ));
      return;
    }
    await service.updateCategories(items);

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Товар добавлен"),
    ));
    setState(() {});
  }

  showEditDialog(BuildContext context, RACategory item, int index) {
    // set up the buttons

    Widget cancelButton = TextButton(
      child: Text(
        "Отмена",
        style: Theme.of(context).textTheme.bodyText2,
      ),
      onPressed: () {
        Navigator.of(context).pop();
        clearAllControllers();
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        "Обновить",
        style: Theme.of(context).textTheme.bodyText2,
      ),
      onPressed: () {
        if (demoMode) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              "CANNOT MODIFY DEMO ADMIN",
              style: TextStyle(color: Colors.redAccent),
            ),
          ));
          return;
        }
        items.removeAt(index);
        item.name = nameTextController.text;
        item.imageUrl = selectedImageUrl;

        items.insert(index, item);

        Navigator.of(context).pop();
        clearAllControllers();
        updateItems("Категория обновлена");
      },
    );

    Widget selectedWidget = categoryOptions();
    nameTextController.text = item.name;
    selectedImageUrl = item.imageUrl;

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Изменить категорию",
        style: Theme.of(context).textTheme.headline6,
      ),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setStatePopup) {
          _setState = setStatePopup;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  titleForItem("Название", 'Введите название категории.',
                      nameTextController),
                  const SizedBox(
                    height: 20,
                  ),
                  BeImagePicker(
                    onPick: (selectedImage, imageUrl) {
                      selectedImageUrl = imageUrl;
                    },
                    preloadedImage: selectedImageUrl,
                  ),
                ],
              )
            ],
          );
        },
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  clearAllControllers() {
    nameTextController.text = "";
    selectedImageUrl = "";
    setState(() {});
  }

  updateItems(String text) async {
    if (demoMode) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "CANNOT MODIFY DEMO ADMIN",
          style: TextStyle(color: Colors.redAccent),
        ),
      ));
      return;
    }

    await service.updateCategories(items);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
    ));
  }

  Widget titleForItem(
    String title,
    String msgField,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BeTextField(
            title: title,
            subtitle: msgField,
            text: controller.text,
            callback: (text) {
              controller.text = text;
            }),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
