class Message {
  String userID = "";
  String message = "";
  String userName = "";

  Message({required this.userID, required this.message, required this.userName});

  Message.fromJson(Map<dynamic, dynamic> json) {
    userID = json["userID"] ?? "";
    message = json["message"] ?? "";
    userName = json["userName"] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["userID"] = userID;
    data["message"] = message;
    data["userName"] = userName;

    return data;
  }
}
