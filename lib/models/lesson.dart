enum VideoType { youtube, vimeo, firebase }

class RALesson {
  String name = "";
  String videoURL = "";
  VideoType videoType = VideoType.youtube;
  String duration = "";

  RALesson({this.name = "", this.videoURL = "", this.videoType = VideoType.youtube, this.duration = "00:00"});

  RALesson.fromJson(Map<dynamic, dynamic> json) {
    name = json["name"] ?? "";
    videoURL = json["videoURL"] ?? "";
    videoType = intToVideoType(json["videoType"] ?? VideoType.youtube);
    duration = json["duration"] ?? "00:00";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["name"] = name;
    data["videoURL"] = videoURL;
    data["videoType"] = convertVideoTypeToInt();
    data["duration"] = duration;
    return data;
  }

  int convertVideoTypeToInt() {
    if (videoType == VideoType.youtube) {
      return 0;
    } else if (videoType == VideoType.vimeo) {
      return 1;
    } else {
      return 2;
    }
  }

  VideoType intToVideoType(int type) {
    if (type == 0) {
      return VideoType.youtube;
    } else if (type == 1) {
      return VideoType.vimeo;
    } else {
      return VideoType.firebase;
    }
  }
}
