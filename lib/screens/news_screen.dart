import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:label_music/models/post.dart';
import 'package:label_music/models/ra_options.dart';

import '../app_settings.dart';
import '../service/api_service.dart';
import '../widgets/button_widget.dart';
import '../widgets/image_picker.dart';
import '../widgets/textfield_widget.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key, required this.options}) : super(key: key);
  final RAOptions options;
  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  APIService service = APIService();
  String selectedValue = "Home";
  List<Post> posts = [];

  final titleTextController = TextEditingController();
  final textTextController = TextEditingController();
  final authorNameTextController = TextEditingController();

  String postImageUrl = "";
  String authorImageUrl = "";
  bool isScreenWide = true;

  StateSetter? _setState;

  @override
  void initState() {
    // TODO: implement initState
    posts = List.from(widget.options.posts);
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
              "Текущие добавленные сообщения",
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Проведите пальцем влево, чтобы удалить сообщение",
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
                for (int index = 0; index < posts.length; index += 1)
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
                        posts.removeAt(index);
                        updateItems("Сообщение удалено");
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
                                    posts[index].title,
                                    style: GoogleFonts.ubuntu(
                                        fontSize: 16, color: Colors.black),
                                  )
                                ],
                              ),
                            ),
                          ),
                          onTap: () {
                            showEditDialog(context, posts[index], index);
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
                  final Post item = posts.removeAt(oldIndex);
                  posts.insert(newIndex, item);
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
    String title = "Новости";
    String subtitle = "Создать новый пост";

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
          name: "Создать пост",
          callback: () {
            addItem();
          }),
      const SizedBox(
        height: 40,
      ),
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
        titleForItem("Заголовок поста", 'Введите название заголовка.',
            titleTextController),
        const SizedBox(
          height: 20,
        ),
        titleForItem("Текст сообщения", 'Введите текст.', textTextController),
        const SizedBox(
          height: 20,
        ),
        BeImagePicker(
          onPick: (selectedImage, imageUrl) {
            postImageUrl = imageUrl;
          },
          imageText: "Выберите изображение публикации",
          preloadedImage: postImageUrl,
        ),
        const SizedBox(
          height: 20,
        ),
        titleForItem(
            "Имя автора", 'Введите имя автора.', authorNameTextController),
        const SizedBox(
          height: 20,
        ),
        BeImagePicker(
          onPick: (selectedImage, imageUrl) {
            authorImageUrl = imageUrl;
          },
          imageText: "Выберите изображение",
          preloadedImage: authorImageUrl,
        ),
      ],
    );
  }

  addItem() async {
    Post item = Post();
    item.title = titleTextController.text;
    item.text = textTextController.text;
    item.authorName = authorNameTextController.text;
    item.imageURL = postImageUrl;
    item.authorImageURL = authorImageUrl;
    item.dateCreated = DateTime.now();
    item.numberOfViews = 0;

    if (item.title.isEmpty) {
      return;
    }

    posts.add(item);
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
    await service.updatePosts(posts);

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Товар добавлен"),
    ));
    setState(() {});
  }

  showEditDialog(BuildContext context, Post item, int index) {
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
        posts.removeAt(index);
        item.title = titleTextController.text;
        item.text = textTextController.text;
        item.authorName = authorNameTextController.text;
        item.imageURL = postImageUrl;
        item.authorImageURL = authorImageUrl;
        item.dateCreated = DateTime.now();

        posts.insert(index, item);

        Navigator.of(context).pop();
        clearAllControllers();
        updateItems("Сообщение обновлено");
      },
    );

    Widget selectedWidget = categoryOptions();
    titleTextController.text = item.title;
    textTextController.text = item.text;
    authorNameTextController.text = item.authorName;
    postImageUrl = item.imageURL;
    authorImageUrl = item.authorImageURL;

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Редактировать пост",
        style: Theme.of(context).textTheme.headline6,
      ),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setStatePopup) {
          _setState = setStatePopup;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                titleForItem("Заголовок поста", 'Введите название поста.',
                    titleTextController),
                const SizedBox(
                  height: 20,
                ),
                titleForItem(
                    "Текст сообщения", 'Напишите  текст.', textTextController),
                const SizedBox(
                  height: 20,
                ),
                BeImagePicker(
                  onPick: (selectedImage, imageUrl) {
                    postImageUrl = imageUrl;
                  },
                  imageText: "Выберите изображение публикации",
                  preloadedImage: postImageUrl,
                ),
                const SizedBox(
                  height: 20,
                ),
                titleForItem(
                    "Автор", 'Введите имя автора.', authorNameTextController),
                const SizedBox(
                  height: 20,
                ),
                BeImagePicker(
                  onPick: (selectedImage, imageUrl) {
                    authorImageUrl = imageUrl;
                  },
                  imageText: "Выберите изображение",
                  preloadedImage: authorImageUrl,
                ),
              ],
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
    textTextController.text = "";
    titleTextController.text = "";
    authorNameTextController.text = "";
    postImageUrl = "";
    authorImageUrl = "";
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

    await service.updatePosts(posts);

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
