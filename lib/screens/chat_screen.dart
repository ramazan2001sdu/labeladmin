import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_settings.dart';
import '../models/conversation.dart';
import '../models/message.dart';
import '../service/api_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late FocusNode myFocusNode;
  String userId = "support";
  String userName = "support_be_111";
  Conversation selectedConversation = Conversation(userName: "", messages: []);
  final messageController = TextEditingController();
  final conversationsScrollController = ScrollController();
  final messagesScrollController = ScrollController();
  List<Conversation> conversations = [];

  @override
  void initState() {
    super.initState();

    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();

    super.dispose();
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
          padding: const EdgeInsets.only(top: 0, left: 0, right: 20),
          child: StreamBuilder(
              stream: APIService().messagesCollection.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
                conversations = [];
                if (snapshot.connectionState == ConnectionState.active &&
                    !snapshot.hasError) {
                  for (QueryDocumentSnapshot documentSnapshot
                      in snapshot.data?.docs ?? []) {
                    Conversation conversation = Conversation.fromJson(
                        documentSnapshot.data() as Map<dynamic, dynamic>);
                    if (conversation.userName != "support_be_111") {
                      conversations.add(conversation);
                    }
                    if (selectedConversation.messages.isNotEmpty &&
                        selectedConversation.messages[0].userID ==
                            conversation.messages[0].userID) {
                      selectedConversation = conversation;
                    }
                  }
                  return mainArea();
                } else {
                  return mainArea();
                }
              }),
        ),
      ),
    );
  }

  Widget mainArea() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 265,
          child: conversationsUI(),
        ),
        messagesUI()
      ],
    );
  }

  Widget conversationsUI() {
    return SizedBox(
      width: 265,
      child: ListView.builder(
        controller: conversationsScrollController,
        itemCount: conversations.length,
        shrinkWrap: true,
        padding: const EdgeInsets.only(top: 10, bottom: 70),
        physics: const ScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
              decoration: BoxDecoration(
                  color: isSelectedConversation(conversations[index])
                      ? const Color.fromRGBO(250, 250, 250, 1)
                      : Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(20))),
              padding:
                  const EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 10),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    //width: 200,
                    decoration: BoxDecoration(
                      color: isSelectedConversation(conversations[index])
                          ? Colors.blueGrey
                          : Colors.white,
                      border: const Border(
                        bottom: BorderSide(
                            width: 1.0,
                            color: Color.fromRGBO(250, 250, 250, 1)),
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.comment,
                          size: 14,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedConversation = conversations[index];
                            });
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 150,
                                child: Text(
                                  conversations[index].userName,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: GoogleFonts.ubuntu(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                width: 150,
                                child: Text(
                                  conversations[index]
                                      .messages[
                                          conversations[index].messages.length -
                                              1]
                                      .message,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: GoogleFonts.ubuntu(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        GestureDetector(
                          onTap: () {
                            String conversationID =
                                conversations[index].messages[0].userID;
                            showAlertDialog(context, conversationID);
                          },
                          child: const FaIcon(
                            FontAwesomeIcons.xmark,
                            size: 13,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                  )));
        },
      ),
    );
  }

  Widget messagesUI() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (messagesScrollController.hasClients) {
        scrollToBottom();
        myFocusNode.requestFocus();
      }
    });
    return Expanded(
      child: Scaffold(
        body: Visibility(
          visible: selectedConversation.messages.isNotEmpty,
          child: Stack(
            children: <Widget>[
              ListView.builder(
                controller: messagesScrollController,
                itemCount: selectedConversation.messages.length,
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 10, bottom: 70),
                physics: const ScrollPhysics(),
                itemBuilder: (context, index) {
                  Message message = selectedConversation.messages[index];
                  return Container(
                    padding: const EdgeInsets.only(
                        left: 14, right: 14, top: 10, bottom: 10),
                    child: Align(
                      alignment: (message.userID != userId
                          ? Alignment.topLeft
                          : Alignment.topRight),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: (message.userID != userId
                              ? Colors.grey.shade200
                              : Colors.blue[200]),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          message.message,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                  );
                },
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
                  height: 60,
                  width: double.infinity,
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      const SizedBox(
                        width: 4,
                      ),
                      Expanded(
                        child: TextField(
                          controller: messageController,
                          focusNode: myFocusNode,
                          onSubmitted: (text) {
                            sendMessage();
                          },
                          decoration: const InputDecoration(
                              hintText: "Написать сообщение...",
                              hintStyle: TextStyle(color: Colors.black54),
                              border: InputBorder.none),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      FloatingActionButton(
                        onPressed: () {
                          sendMessage();
                        },
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 18,
                        ),
                        backgroundColor: Colors.black,
                        elevation: 0,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void sendMessage() async {
    if (messageController.text.isEmpty) {
      return;
    } else {
      Message message = Message(
          userID: userId, userName: userName, message: messageController.text);
      selectedConversation.messages.add(message);
      messageController.text = "";
      await APIService().sendMessage(
        selectedConversation,
        selectedConversation.messages[0].userID,
      );
    }
  }

  void scrollToBottom() {
    messagesScrollController.animateTo(
        messagesScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut);
  }

  bool isSelectedConversation(Conversation conversation) {
    if (selectedConversation.messages.isNotEmpty &&
        selectedConversation.messages[0].userID ==
            conversation.messages[0].userID) {
      return true;
    }
    return false;
  }

  showAlertDialog(BuildContext context, String conversationID) async {
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
        if (demoMode) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              "CANNOT MODIFY DEMO ADMIN",
              style: TextStyle(color: Colors.redAccent),
            ),
          ));
          return;
        }
        APIService().removeConversation(conversationID);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Подтвердить",
        style: Theme.of(context).textTheme.headline6,
      ),
      content: Text(
        "Вы уверены, что хотите удалить этот разговор?",
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
