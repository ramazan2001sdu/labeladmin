import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:label_music/models/lesson.dart';
import 'package:label_music/widgets/dropdown_widget.dart';
import 'package:label_music/widgets/textfield_widget.dart';
import 'package:label_music/widgets/video_picker.dart';

class LessonsPicker extends StatefulWidget {
  const LessonsPicker({Key? key, required this.lessons, required this.onChange})
      : super(key: key);
  final List<RALesson> lessons;
  final Function onChange;
  @override
  State<LessonsPicker> createState() => _LessonsPickerState();
}

class _LessonsPickerState extends State<LessonsPicker> {
  List<RALesson> lessons = [];
  final videoIDController = TextEditingController();
  final videoTitleController = TextEditingController();
  final durationController = TextEditingController();
  String selectedType = "YouTube";
  StateSetter? _setState;
  @override
  void initState() {
    // TODO: implement initState
    for (var lesson in widget.lessons) {
      lessons.add(lesson);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        primary: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Настройка ",
              style: Theme.of(context).textTheme.bodyText2,
            ),
            const SizedBox(
              height: 15,
            ),
            ReorderableListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              primary: false,
              children: <Widget>[
                for (int index = 0; index < lessons.length; index += 1)
                  Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) {
                      setState(() {
                        lessons.removeAt(index);
                        widget.onChange(lessons);
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
                                  Flexible(
                                    child: Text(
                                      lessons[index].name,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: GoogleFonts.ubuntu(
                                          fontSize: 16, color: Colors.black),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          onTap: () {
                            showEditDialog(context, lessons[index], index);
                          },
                        ),
                      ),
                    ),
                  ),
              ],
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  final RALesson item = lessons.removeAt(oldIndex);
                  lessons.insert(newIndex, item);
                  widget.onChange(lessons);
                });
              },
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                showAddDialog(context, 0);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const FaIcon(
                    FontAwesomeIcons.plus,
                    color: Colors.black,
                    size: 17,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    "Добавить видео артиста",
                    style:
                        GoogleFonts.poppins(fontSize: 15, color: Colors.black),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  showAddDialog(BuildContext context, int index) {
    // set up the buttons

    Widget cancelButton = TextButton(
      child: Text(
        "Отмена",
        style: Theme.of(context).textTheme.bodyText2,
      ),
      onPressed: () {
        Navigator.of(context).pop();
        //clearAllControllers();
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        "Подтвердить",
        style: Theme.of(context).textTheme.bodyText2,
      ),
      onPressed: () {
        RALesson lesson = RALesson();
        lesson.videoURL = videoIDController.text;
        lesson.name = videoTitleController.text;
        lesson.videoType = convertToVideoType();
        lesson.duration = durationController.text;

        lessons.add(lesson);
        videoIDController.text = "";
        videoTitleController.text = "";
        durationController.text = "";
        Navigator.of(context).pop();
        widget.onChange(lessons);
        setState(() {});
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Добавить видео артиста",
        style: Theme.of(context).textTheme.headline6,
      ),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setStatePopup) {
          _setState = setStatePopup;
          return SingleChildScrollView(
            primary: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BeDropdown(
                    title: "Type",
                    items: const ["YouTube", "Vimeo", "Firebase"],
                    callback: (value) {
                      _setState!(() {
                        selectedType = value;
                      });
                    },
                    selectedValue: selectedType),
                const SizedBox(
                  height: 20,
                ),
                Visibility(
                  visible: selectedType != "Firebase",
                  child: BeTextField(
                      title: "Ссылка на видео",
                      subtitle: "Вставьте сюда ссылку на видео",
                      text: videoIDController.text,
                      callback: (videoID) {
                        videoIDController.text = videoID;
                      }),
                ),
                Visibility(
                  visible: selectedType == "Firebase",
                  child: BeVideoPicker(onPick: (videoUrl) {
                    videoIDController.text = videoUrl;
                  }),
                ),
                const SizedBox(
                  height: 20,
                ),
                BeTextField(
                    title: "Название",
                    subtitle: "Напишите здесь какой-нибудь заголовок",
                    text: videoTitleController.text,
                    callback: (videoTitle) {
                      videoTitleController.text = videoTitle;
                    }),
                const SizedBox(
                  height: 20,
                ),
                BeTextField(
                    title: "Продолжительность",
                    subtitle: "В минутах...",
                    text: durationController.text,
                    callback: (videoTitle) {
                      durationController.text = videoTitle;
                    }),
                const SizedBox(
                  height: 20,
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

  showEditDialog(BuildContext context, RALesson lesson, int index) {
    // set up the buttons
    videoIDController.text = lesson.videoURL;
    videoTitleController.text = lesson.name;
    durationController.text = lesson.duration;

    Widget cancelButton = TextButton(
      child: Text(
        "Отмена",
        style: Theme.of(context).textTheme.bodyText2,
      ),
      onPressed: () {
        Navigator.of(context).pop();
        //clearAllControllers();
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        "Подтвердить",
        style: Theme.of(context).textTheme.bodyText2,
      ),
      onPressed: () {
        RALesson lesson = RALesson();
        lesson.videoURL = videoIDController.text;
        lesson.name = videoTitleController.text;
        lesson.videoType = convertToVideoType();
        lesson.duration = durationController.text;

        lessons.removeAt(index);
        lessons.insert(index, lesson);
        videoIDController.text = "";
        videoTitleController.text = "";
        durationController.text = "";
        Navigator.of(context).pop();
        widget.onChange(lessons);
        setState(() {});
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Edit YouTube Video",
        style: Theme.of(context).textTheme.headline6,
      ),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setStatePopup) {
          _setState = setStatePopup;
          return SingleChildScrollView(
            primary: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BeDropdown(
                    title: "Type",
                    items: const ["YouTube", "Vimeo", "Firebase"],
                    callback: (value) {
                      _setState!(() {
                        selectedType = value;
                      });
                    },
                    selectedValue: selectedType),
                const SizedBox(
                  height: 20,
                ),
                Visibility(
                  visible: selectedType != "Firebase",
                  child: BeTextField(
                      title: "Ссылка на видео",
                      subtitle: "Вставьте сюда ссылку на видео",
                      text: videoIDController.text,
                      callback: (videoID) {
                        videoIDController.text = videoID;
                      }),
                ),
                Visibility(
                  visible: selectedType == "Firebase",
                  child: BeVideoPicker(onPick: (videoUrl) {
                    videoIDController.text = videoUrl;
                  }),
                ),
                const SizedBox(
                  height: 20,
                ),
                BeTextField(
                    title: "Название",
                    subtitle: "Напишите здесь какой-нибудь заголовок",
                    text: videoTitleController.text,
                    callback: (videoTitle) {
                      videoTitleController.text = videoTitle;
                    }),
                const SizedBox(
                  height: 20,
                ),
                BeTextField(
                    title: "Продолжительность",
                    subtitle: "Прмиер 1:45...",
                    text: durationController.text,
                    callback: (videoTitle) {
                      durationController.text = videoTitle;
                    }),
                const SizedBox(
                  height: 20,
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

  VideoType convertToVideoType() {
    if (selectedType == "YouTube") {
      return VideoType.youtube;
    } else if (selectedType == "Vimeo") {
      return VideoType.vimeo;
    } else {
      return VideoType.firebase;
    }
  }
}
