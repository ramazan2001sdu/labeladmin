import 'package:label_music/models/category.dart';
import 'package:label_music/models/post.dart';

import 'onboarding_page.dart';

class RAOptions {
  List<OnboardingPage> onboardingPages = [];
  List<RACategory> categories = [];
  List<Post> posts = [];
  RAOptions();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (data["onBoardingPages"] != null) {
      data["onBoardingPages"] = onboardingPages.map((v) => v.toJson()).toList();
    }
    if (data["categories"] != null) {
      data["categories"] = categories.map((v) => v.toJson()).toList();
    }
    if (data["posts"] != null) {
      data["posts"] = posts.map((v) => v.toJson()).toList();
    }
    return data;
  }

  RAOptions.fromJson(Map<dynamic, dynamic> json) {
    if (json["onBoardingPages"] != null) {
      json['onBoardingPages'].forEach((v) {
        onboardingPages.add(OnboardingPage.fromJson(v));
      });
    }
    if (json["categories"] != null) {
      json['categories'].forEach((v) {
        categories.add(RACategory.fromJson(v));
      });
    }
    if (json["posts"] != null) {
      json['posts'].forEach((v) {
        posts.add(Post.fromJson(v));
      });
    }
  }
}
