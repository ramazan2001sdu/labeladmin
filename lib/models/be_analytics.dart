class BeAnalytics {
  int visitors = 0;
  int userShares = 0;
  int subscribers = 0;
  int openedCourses = 0;
  int appleDevices = 0;
  int androidDevices = 0;

  BeAnalytics({this.visitors = 0, this.userShares = 0, this.subscribers = 0, this.openedCourses = 0, this.appleDevices = 0, this.androidDevices = 0});

  BeAnalytics.fromJson(Map<dynamic, dynamic> json) {
    visitors = json["visitors"] ?? 0;
    userShares = json["userShares"] ?? 0;
    subscribers = json["subscribers"] ?? 0;
    openedCourses = json["openedCourses"] ?? 0;
    appleDevices = json["appleDevices"] ?? 0;
    androidDevices = json["androidDevices"] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["visitors"] = visitors;
    data["userShares"] = userShares;
    data["subscribers"] = subscribers;
    data["openedCourses"] = openedCourses;
    data["appleDevices"] = appleDevices;
    data["androidDevices"] = androidDevices;
    return data;
  }
}
