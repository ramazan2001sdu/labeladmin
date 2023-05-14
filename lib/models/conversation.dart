import 'message.dart';

class Conversation {
  List<Message> messages = [];
  String userName = "";

  Conversation({required this.userName, required this.messages});

  Conversation.fromJson(Map<dynamic, dynamic> json) {
    if (json["messages"] != null) {
      json['messages'].forEach((v) {
        messages.add(Message.fromJson(v));
      });
    }
    userName = json["user_name"] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["messages"] = messages.map((v) => v.toJson()).toList();
    data["userName"] = userName;
    return data;
  }
}
