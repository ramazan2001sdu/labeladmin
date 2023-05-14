import 'lesson.dart';

class Course {
  String name = "";
  String imageURL = "";
  String totalTime = "";
  String trailerURL = "";
  String trailerDuration = "";
  String level = "";
  String teacher = "";
  String description = "";
  int numberOfWatchers = 0;
  int numberOfFavourites = 0;

  List<String> tags = [];
  List<RALesson> lessons = [];

  Course({this.name = "", this.imageURL = "", required this.lessons, this.trailerURL = "", this.trailerDuration = ""});

  Course.fromJson(Map<dynamic, dynamic> json) {
    name = json["name"] ?? "";
    imageURL = json["imageURL"] ?? "";
    totalTime = json["totalTime"] ?? "";
    trailerURL = json["trailerURL"] ?? "";
    trailerDuration = json["trailerDuration"] ?? "";
    teacher = json["teacher"] ?? "";
    description = json["description"] ?? "";
    numberOfFavourites = json["numberOfFavourites"] ?? 0;
    numberOfWatchers = json["numberOfWatchers"] ?? 0;
    level = json["level"] ?? "";
    if (json["tags"] != null) {
      tags = List.from(json["tags"]);
    }
    if (json['lessons'] != null) {
      lessons = <RALesson>[];
      json['lessons'].forEach((v) {
        lessons.add(RALesson.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["name"] = name;
    data["imageURL"] = imageURL;
    data["totalTime"] = totalTime;
    data["trailerURL"] = trailerURL;
    data["trailerDuration"] = trailerDuration;
    data["level"] = level;
    data["teacher"] = teacher;
    data["description"] = description;
    data["numberOfWatchers"] = numberOfWatchers;
    data["numberOfFavourites"] = numberOfFavourites;
    data["tags"] = tags;
    data["lessons"] = lessons.map((v) => v.toJson()).toList();
    return data;
  }
}
