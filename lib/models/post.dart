import 'package:intl/intl.dart';

class Post {
  String title = "";
  String text = "";
  String imageURL = "";
  DateTime dateCreated = DateTime.now();
  String authorName = "";
  String authorImageURL = "";
  int numberOfViews = 0;

  Post({this.title = "", this.text = "", this.imageURL = "", this.authorImageURL = "", this.authorName = "", this.numberOfViews = 0});

  Post.fromJson(Map<dynamic, dynamic> json) {
    title = json["title"] ?? "";
    text = json["text"] ?? "";
    authorName = json["authorName"] ?? "";
    authorImageURL = json["authorImageURL"] ?? "";
    imageURL = json["imageURL"] ?? "";
    numberOfViews = json["numberOfViews"] ?? 0;
    if (json["dateCreated"] != null) {
      dateCreated = DateTime.parse(json["dateCreated"]);
    } else {
      dateCreated = DateTime.now();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["title"] = title;
    data["text"] = text;
    data["imageURL"] = imageURL;
    data["authorName"] = authorName;
    data["authorImageURL"] = authorImageURL;
    data["numberOfViews"] = numberOfViews;
    data["dateCreated"] = dateCreated.toString();
    return data;
  }

  String dateToString() {
    return DateFormat.MMMMd().format(dateCreated);
  }
}
