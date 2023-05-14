import 'course.dart';

class RACategory {
  String categoryID = "";
  String name = "";
  String imageUrl = "";
  List<Course> courses = [];

  RACategory({this.name = "", this.categoryID = "", this.imageUrl = "", required this.courses});

  RACategory.fromJson(Map<dynamic, dynamic> json) {
    name = json["name"] ?? "";
    categoryID = json["categoryID"] ?? "";
    imageUrl = json["imageUrl"] ?? "";

    if (json['courses'] != null) {
      courses = <Course>[];
      json['courses'].forEach((v) {
        courses.add(Course.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["name"] = name;
    data["categoryID"] = categoryID;
    data["imageUrl"] = imageUrl;
    data["courses"] = courses.map((v) => v.toJson()).toList();
    return data;
  }

  RACategory fromCategory(RACategory cat) {
    RACategory category = RACategory(courses: []);
    category.name = cat.name;
    category.courses = List.from(cat.courses);
    category.imageUrl = cat.imageUrl;
    category.categoryID = cat.categoryID;
    return category;
  }
}
