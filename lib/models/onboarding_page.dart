class OnboardingPage {
  String title = "";
  String text = "";
  String imageUrl = "";

  OnboardingPage({required this.title, required this.text, required this.imageUrl});

  OnboardingPage.fromJson(Map<dynamic, dynamic> json) {
    title = json["title"];
    text = json["text"];
    imageUrl = json["imageUrl"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["title"] = title;
    data["text"] = text;
    data["imageUrl"] = imageUrl;
    return data;
  }
}
