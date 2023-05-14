import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:label_music/models/ra_options.dart';
import 'package:label_music/widgets/dropdown_category_widget.dart';
import 'package:label_music/widgets/lessons_picker.dart';
import 'package:label_music/widgets/loading.dart';

import '../app_settings.dart';
import '../models/category.dart';
import '../models/course.dart';
import '../models/lesson.dart';
import '../service/api_service.dart';
import '../widgets/button_widget.dart';
import '../widgets/image_picker.dart';
import '../widgets/textfield_widget.dart';

class CoursesScreen extends StatefulWidget {
  CoursesScreen({Key? key, required this.options}) : super(key: key);
  RAOptions options;

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  APIService service = APIService();

  List<RACategory> categories = [];
  List<Course> courses = [];
  RACategory selectedCategory = RACategory(courses: []);
  RACategory prevCategory = RACategory(courses: []);
  final nameTextController = TextEditingController();
  final levelTextController = TextEditingController();
  final teacherTextController = TextEditingController();
  final descriptionTextController = TextEditingController();
  final tagsTextController = TextEditingController();
  String selectedImageUrl = "";
  bool isScreenWide = true;
  int selectedIndex = 0;
  StateSetter? _setState;
  List<RALesson> selectedLessons = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isScreenWide = MediaQuery.of(context).size.width >= 950;
    return FutureBuilder(
      future: APIService().requestOptions(),
      builder: (BuildContext context, AsyncSnapshot<RAOptions> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          widget.options.categories = List.from(snapshot.data!.categories);
          categories = List.from(widget.options.categories);
          if (selectedCategory.name.isEmpty &&
              selectedCategory.courses.isEmpty) {
            debugPrint("category is selected");
            if (categories.isNotEmpty) {
              selectedCategory =
                  RACategory(courses: []).fromCategory(categories[0]);
            }
            courses = List.from(selectedCategory.courses);
          }
          return startingWidget();
        } else {
          return Stack(
            children: [
              startingWidget(),
              const Center(
                child: Loading(),
              )
            ],
          );
        }
      },
    );
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
            body: Flex(
              direction: isScreenWide ? Axis.horizontal : Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                mainArea(),
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
              "Жанры, артисты",
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Проведите влево, чтобы удалить",
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
                for (int index = 0; index < courses.length; index += 1)
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
                        courses.removeAt(index);
                        selectedCategory.courses = List.from(courses);
                        updateSelectedCategory();
                        updateItems("Course is removed");
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
                          leading: SizedBox(
                            width: 50,
                            height: 50,
                            child: CachedNetworkImage(
                              imageUrl: courses[index].imageURL,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Padding(
                            padding: const EdgeInsets.only(right: 50),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    courses[index].name,
                                    style: GoogleFonts.ubuntu(
                                        fontSize: 16, color: Colors.black),
                                  )
                                ],
                              ),
                            ),
                          ),
                          onTap: () {
                            courses = List.from(selectedCategory.courses);
                            showEditDialog(context, courses[index], index);
                          },
                        ),
                      ),
                    ),
                  ),
              ],
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  if (demoMode) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                        "CANNOT MODIFY DEMO ADMIN",
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    ));
                    return;
                  }
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  final Course item = courses.removeAt(oldIndex);
                  courses.insert(newIndex, item);
                  selectedCategory.courses = List.from(courses);
                  updateSelectedCategory();
                  updateItems("Changes saved");
                });
              },
            )
          ],
        ),
      ),
    );
  }

  updateSelectedCategory() {
    if (demoMode) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "CANNOT MODIFY DEMO ADMIN",
          style: TextStyle(color: Colors.redAccent),
        ),
      ));
      return;
    }
    for (int i = 0; i < categories.length; i += 1) {
      if (selectedCategory.categoryID == categories[i].categoryID) {
        categories.removeAt(i);
        categories.insert(i, selectedCategory);
        break;
      }
    }
  }

  Widget mainArea() {
    String title = "Менеджер артистов";
    String subtitle = "Выберите категорию";

    return SizedBox(
      width: 300,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headline6,
        ),
        const SizedBox(
          height: 20,
        ),
        BeButton(
            name: "Добавить артиста",
            callback: () {
              if (categories.isNotEmpty) {
                addItem();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                    "YOU DON'T HAVE ANY CATEGORIES",
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ));
                return;
              }
            }),
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
        Expanded(
          child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return Card(
                    child: ListTile(
                        minVerticalPadding: 10,
                        selected: selectedIndex == index ? true : false,
                        tileColor: Colors.white,
                        selectedColor: Colors.black,
                        selectedTileColor: Colors.green[50],
                        title: Text(categories[index].name),
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                            selectedCategory = RACategory(courses: [])
                                .fromCategory(categories[index]);
                            courses = List.from(selectedCategory.courses);
                          });
                        },
                        leading: SizedBox(
                          width: 40,
                          height: 40,
                          child: CachedNetworkImage(
                            imageUrl: categories[index].imageUrl,
                            fit: BoxFit.cover,
                          ),
                        )));
              }),
        ),
      ]),
    );
  }

  Widget options() {
    return courseOptions();
  }

  Widget courseOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        titleForItem("Название", 'Название.', nameTextController),
        const SizedBox(
          height: 20,
        ),
        BeDropdownCategory(
            title: "Категории",
            items: categories,
            selectedCategory: selectedCategory,
            callback: (value) {
              selectedCategory = RACategory(courses: []).fromCategory(value);
            }),
        const SizedBox(
          height: 20,
        ),
        titleForItem("Артист", 'Артист', teacherTextController),
        const SizedBox(
          height: 20,
        ),
        titleForItem("Данные", "примечание", levelTextController),
        const SizedBox(
          height: 20,
        ),
        titleForItem(
            "Описание ", "HTML tags allowed", descriptionTextController),
        const SizedBox(
          height: 20,
        ),
        titleForItem("Tags", "Tags separated by comma", tagsTextController),
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
    Course item = Course(lessons: []);
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
        "Создать",
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
        //add new item to the array and update category
        Course course = Course(lessons: []);
        course.name = nameTextController.text;
        course.lessons = List.from(selectedLessons);
        course.teacher = teacherTextController.text;
        course.level = levelTextController.text;
        course.tags = convertTagsToList();
        course.description = descriptionTextController.text;
        course.imageURL = selectedImageUrl;
        selectedCategory.courses.add(course);
        Navigator.of(context).pop();
        clearAllControllers();
        updateItems("Course is created");
      },
    );

    Widget selectedWidget = courseOptions();

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Добавить новое видео ",
        style: Theme.of(context).textTheme.headline6,
      ),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setStatePopup) {
          _setState = setStatePopup;

          return SizedBox(
            width: 800,
            child: SingleChildScrollView(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: BeDropdownCategory(
                            title: "Категории",
                            items: categories,
                            selectedCategory: selectedCategory,
                            callback: (value) {
                              selectedCategory =
                                  RACategory(courses: []).fromCategory(value);
                            }),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      titleForItem("Название", 'Название.', nameTextController),
                      const SizedBox(
                        height: 20,
                      ),
                      titleForItem("Артист", 'Артист', teacherTextController),
                      const SizedBox(
                        height: 20,
                      ),
                      titleForItem("Данные", "Примечание", levelTextController),
                      const SizedBox(
                        height: 20,
                      ),
                      titleForItem("Описание", "HTML tags allowed",
                          descriptionTextController),
                      const SizedBox(
                        height: 20,
                      ),
                      titleForItem("Tags", "Tags separated by comma",
                          tagsTextController),
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
                  ),
                  const SizedBox(
                    width: 70,
                  ),
                  LessonsPicker(
                      lessons: [],
                      onChange: (lessons) {
                        selectedLessons = List.from(lessons);
                      }),
                ],
              ),
            ),
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

  showEditDialog(BuildContext context, Course item, int index) {
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
        if (prevCategory.categoryID.isNotEmpty) {
          prevCategory.courses.removeAt(index);
          for (RACategory cat in categories) {
            if (cat.categoryID == prevCategory.categoryID) {
              cat.courses = List.from(prevCategory.courses);
              break;
            }
          }
          prevCategory = RACategory(courses: []);
          Course item = Course(lessons: []);
          item.name = nameTextController.text;
          item.imageURL = selectedImageUrl;
          item.lessons = List.from(selectedLessons);
          item.teacher = teacherTextController.text;
          item.level = levelTextController.text;
          item.tags = convertTagsToList();
          item.description = descriptionTextController.text;
          selectedCategory.courses.add(item);
          updateSelectedCategory();
        } else {
          selectedCategory.courses.removeAt(index);
          item.name = nameTextController.text;
          item.imageURL = selectedImageUrl;
          item.lessons = List.from(selectedLessons);
          item.teacher = teacherTextController.text;
          item.level = levelTextController.text;
          item.tags = convertTagsToList();
          item.description = descriptionTextController.text;
          selectedCategory.courses.insert(index, item);
          updateSelectedCategory();
        }

        Navigator.of(context).pop();
        clearAllControllers();
        updateItems("Course is updated");
      },
    );

    selectedLessons = List.from(item.lessons);
    nameTextController.text = item.name;
    selectedImageUrl = item.imageURL;
    teacherTextController.text = item.teacher;
    levelTextController.text = item.level;
    tagsTextController.text = convertListToTags(item.tags);
    descriptionTextController.text = item.description;
    selectedImageUrl = item.imageURL;

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Редактировать",
        style: Theme.of(context).textTheme.headline6,
      ),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setStatePopup) {
          _setState = setStatePopup;

          return SizedBox(
            width: 800,
            child: SingleChildScrollView(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: BeDropdownCategory(
                            title: "Категории",
                            items: categories,
                            selectedCategory: selectedCategory,
                            callback: (value) {
                              prevCategory.courses = selectedCategory.courses;
                              prevCategory.categoryID =
                                  selectedCategory.categoryID;
                              prevCategory.name = selectedCategory.name;
                              prevCategory.imageUrl = selectedCategory.imageUrl;
                              selectedCategory =
                                  RACategory(courses: []).fromCategory(value);
                            }),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      titleForItem("Название", 'Название.', nameTextController),
                      const SizedBox(
                        height: 20,
                      ),
                      titleForItem("Артист", 'Артист', teacherTextController),
                      const SizedBox(
                        height: 20,
                      ),
                      titleForItem("Данные", "примечание", levelTextController),
                      const SizedBox(
                        height: 20,
                      ),
                      titleForItem("Описание", "HTML tags allowed",
                          descriptionTextController),
                      const SizedBox(
                        height: 20,
                      ),
                      titleForItem("Tags", "Tags separated by comma",
                          tagsTextController),
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
                  ),
                  const SizedBox(
                    width: 70,
                  ),
                  LessonsPicker(
                      lessons: selectedLessons,
                      onChange: (lessons) {
                        selectedLessons = List.from(lessons);
                      }),
                ],
              ),
            ),
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
    teacherTextController.text = "";
    levelTextController.text = "";
    descriptionTextController.text = "";
    tagsTextController.text = "";
    prevCategory = RACategory(courses: []);
    selectedLessons = [];
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
    for (int i = 0; i < categories.length; i++) {
      RACategory category = categories[i];
      if (category.categoryID == selectedCategory.categoryID) {
        categories.removeAt(i);
        categories.insert(i, selectedCategory);
        break;
      }
    }
    await service.updateCategories(categories);
    setState(() {
      courses = List.from(selectedCategory.courses);
    });
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

  List<String> convertTagsToList() {
    if (tagsTextController.text.isEmpty) {
      return [];
    }
    return tagsTextController.text
        .split(",")
        .map((x) => x.trim())
        .where((element) => element.isNotEmpty)
        .toList();
  }

  String convertListToTags(List<String> tags) {
    if (tags.isEmpty) {
      return "";
    }
    String result = "";
    for (String tag in tags) {
      result += "$tag,";
    }
    return result;
  }
}
