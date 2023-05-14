import 'package:flutter/material.dart';
import 'package:label_music/models/ra_settings.dart';

import '../../../widgets/loading.dart';
import '../app_settings.dart';
import '../service/api_service.dart';
import '../widgets/button_widget.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key, required this.general}) : super(key: key);
  final RASettings general;
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final titleController = TextEditingController();
  final textController = TextEditingController();
  final serverKey = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.only(top: 40, left: 50, right: 20),
          child: Scaffold(
            backgroundColor: Colors.white,
            body: mainArea(),
          ),
        ),
      ),
    );
  }

  Widget mainArea() {
    return FutureBuilder(
        future: APIService().requestSettings(),
        builder: (BuildContext context, AsyncSnapshot<RASettings> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (!snapshot.hasData) {
              return const Loading();
            } else {
              RASettings general = snapshot.data!;
              serverKey.text = general.pushNotificationsServerKey;
              return SingleChildScrollView(
                primary: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Уведомление",
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        BeButton(
                            name: "Сохранить изменения",
                            callback: () {
                              updateSettings(general);
                            })
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Text(
                      "Отправить уведомление",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 400,
                      child: TextField(
                        obscureText: false,
                        controller: titleController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).secondaryHeaderColor,
                                width: 1.0),
                          ),
                          labelText: 'Заголовок Вашего уведомления',
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 400,
                      child: TextField(
                        maxLines: 4,
                        obscureText: false,
                        controller: textController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).secondaryHeaderColor,
                                width: 1.0),
                          ),
                          labelText: 'Описание Вашего уведомления',
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        BeButton(
                            name: "Отправить",
                            callback: () {
                              showAlertDialog(context);
                            }),
                      ],
                    ),
                  ],
                ),
              );
            }
          } else {
            return const Loading();
          }
        });
  }

  void updateSettings(RASettings general) async {
    if (demoMode) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "CANNOT MODIFY DEMO ADMIN",
          style: TextStyle(color: Colors.redAccent),
        ),
      ));
      return;
    }

    general.pushNotificationsServerKey = serverKey.text;
    await APIService().updateSettings(general);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Push Settings are updated!"),
    ));
    setState(() {});
  }

  showAlertDialog(BuildContext context) async {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(
        "Отмена",
        style: Theme.of(context).textTheme.bodyText2,
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        "Вперед, продолжать",
        style: Theme.of(context).textTheme.bodyText2,
      ),
      onPressed: () async {
        Navigator.of(context).pop();
        bool success = await APIService().sendPushNotification(
            titleController.text, textController.text, widget.general);
        if (success) {
          setState(() {
            titleController.text = "";
            textController.text = "";
          });
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Ваше уведомление отправлено на все устройства"),
          ));
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Подтверждение",
        style: Theme.of(context).textTheme.headline6,
      ),
      content: Text(
        "Вы уверены, что хотите отправить это уведомление?",
        style: Theme.of(context).textTheme.bodyText2,
      ),
      actions: [
        cancelButton,
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
}
