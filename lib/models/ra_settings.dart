import 'dart:ui';

class RASettings {
  //Values
  String pushNotificationsServerKey = "";
  String logoUrl = "";
  String fontName = "Roboto";
  String companyName = "";
  String companyNumber = "";
  String companyEmail = "";

  //Theme
  List<int> topBarRGB = [0, 0, 0];
  List<int> topBarItemsRGB = [255, 255, 255];
  List<int> bottomBarRGB = [0, 0, 0];
  List<int> bottomBarItemsRGB = [255, 255, 255];
  List<int> bottomBarSelectedItemsRGB = [255, 255, 255];
  List<int> loadingRGB = [255, 255, 255];

  //Switchers
  bool instantUpdates = true;
  bool enabledAnalytics = true;
  bool enableShare = true;
  bool enableSafeArea = false;
  bool enableNoInternetPopup = true;
  bool enableConstructionMode = false;
  bool enableAuthorization = false;
  bool enableFacebookLogin = false;
  bool enableGoogleLogin = false;
  bool enableEmailLogin = false;
  bool enableRTL = false;
  bool enableScreenSecurity = false;
  bool enableExitApp = false;
  bool enableLandscape = false;
  bool enableShowTitlesAlwaysForBottomMenu = true;

  //Types
  int loadingType = 1;
  int bottomNavigationType = 1;
  int loadingSize = 30;

  //Social
  String facebook = "";
  String instagram = "";
  String twitter = "";
  String youtube = "";
  String vimeo = "";
  String pinterest = "";
  String linkedin = "";
  String tiktok = "";
  String aboutUs = "";

  RASettings();

  RASettings.fromJson(Map<dynamic, dynamic> json) {
    //Social
    youtube = json['youtube'] ?? "";
    instagram = json['instagram'] ?? "";
    twitter = json['twitter'] ?? "";
    facebook = json['facebook'] ?? "";
    vimeo = json['vimeo'] ?? "";
    pinterest = json['pinterest'] ?? "";
    linkedin = json['linkedin'] ?? "";
    tiktok = json['tiktok'] ?? "";
    aboutUs = json['aboutUs'] ?? "";

    //Values
    pushNotificationsServerKey = json['pushNotificationsServerKey'] ?? "";
    logoUrl = json['logoUrl'] ?? "";
    fontName = json['fontName'] ?? "Roboto";
    companyName = json['companyName'] ?? "";
    companyEmail = json['companyEmail'] ?? "";
    companyNumber = json['companyNumber'] ?? "";

    //Theme
    if (json['topBarRGB'] != null) {
      topBarRGB = json['topBarRGB'].cast<int>();
    }
    if (json['topBarItemsRGB'] != null) {
      topBarItemsRGB = json['topBarItemsRGB'].cast<int>();
    }
    if (json['bottomBarRGB'] != null) {
      bottomBarRGB = json['bottomBarRGB'].cast<int>();
    }
    if (json['bottomBarItemsRGB'] != null) {
      bottomBarItemsRGB = json['bottomBarItemsRGB'].cast<int>();
    }
    if (json['bottomBarSelectedItemsRGB'] != null) {
      bottomBarSelectedItemsRGB = json['bottomBarSelectedItemsRGB'].cast<int>();
    }
    if (json['loadingRGB'] != null) {
      loadingRGB = json['loadingRGB'].cast<int>();
    }
    //Switchers
    instantUpdates = json['instantUpdates'] ?? true;
    enabledAnalytics = json['enabledAnalytics'] ?? true;
    enableShare = json['enableShare'] ?? true;
    enableSafeArea = json['enableSafeArea'] ?? false;
    enableNoInternetPopup = json['enableNoInternetPopup'] ?? true;
    enableConstructionMode = json['enableConstructionMode'] ?? false;
    enableAuthorization = json['enableAuthorization'] ?? true;
    enableFacebookLogin = json['enableFacebookLogin'] ?? true;
    enableGoogleLogin = json['enableGoogleLogin'] ?? true;
    enableEmailLogin = json['enableEmailLogin'] ?? true;
    enableRTL = json['enableRTL'] ?? false;
    enableScreenSecurity = json['enableScreenSecurity'] ?? false;
    enableExitApp = json['enableExitApp'] ?? true;
    enableLandscape = json['enableLandscape'] ?? false;
    enableShowTitlesAlwaysForBottomMenu = json['enableShowTitlesAlwaysForBottomMenu'] ?? true;

    //Types
    loadingType = json['loadingType'] ?? 1;
    bottomNavigationType = json['bottomNavigationType'] ?? 1;
    loadingSize = json['loadingSize'] ?? 30;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    //Values
    data["pushNotificationsServerKey"] = pushNotificationsServerKey;
    data["logoUrl"] = logoUrl;
    data["fontName"] = fontName;
    data["companyName"] = companyName;
    data["companyNumber"] = companyNumber;
    data["companyEmail"] = companyEmail;

    //Theme
    data['topBarRGB'] = topBarRGB.cast<int>();
    data['topBarItemsRGB'] = topBarItemsRGB.cast<int>();
    data['bottomBarRGB'] = bottomBarRGB.cast<int>();
    data['bottomBarItemsRGB'] = bottomBarItemsRGB.cast<int>();
    data['bottomBarSelectedItemsRGB'] = bottomBarSelectedItemsRGB.cast<int>();
    data['loadingRGB'] = loadingRGB.cast<int>();

    //Switchers
    data['instantUpdates'] = instantUpdates;
    data['enabledAnalytics'] = enabledAnalytics;
    data['enableShare'] = enableShare;
    data['enableSafeArea'] = enableSafeArea;
    data['enableNoInternetPopup'] = enableNoInternetPopup;
    data['enableConstructionMode'] = enableConstructionMode;
    data['enableAuthorization'] = enableAuthorization;
    data['enableFacebookLogin'] = enableFacebookLogin;
    data['enableGoogleLogin'] = enableGoogleLogin;
    data['enableEmailLogin'] = enableEmailLogin;
    data['enableRTL'] = enableRTL;
    data['enableScreenSecurity'] = enableScreenSecurity;
    data['enableExitApp'] = enableExitApp;
    data['enableLandscape'] = enableLandscape;
    data['enableShowTitlesAlwaysForBottomMenu'] = enableShowTitlesAlwaysForBottomMenu;

    //Types
    data['loadingType'] = loadingType;
    data['loadingSize'] = loadingSize;
    data['bottomNavigationType'] = bottomNavigationType;

    //Social
    data["youtube"] = youtube;
    data["instagram"] = instagram;
    data["twitter"] = twitter;
    data["facebook"] = facebook;
    data["vimeo"] = vimeo;
    data["pinterest"] = pinterest;
    data["linkedin"] = linkedin;
    data["tiktok"] = tiktok;
    data["aboutUs"] = aboutUs;

    return data;
  }

  RASettings getCurrentSettings() {
    RASettings settings = RASettings();
    settings.pushNotificationsServerKey = pushNotificationsServerKey;
    settings.logoUrl = logoUrl;
    settings.fontName = fontName;
    settings.topBarRGB = topBarRGB;
    settings.topBarItemsRGB = topBarItemsRGB;
    settings.bottomBarRGB = bottomBarRGB;
    settings.bottomBarItemsRGB = bottomBarItemsRGB;
    settings.bottomBarSelectedItemsRGB = bottomBarSelectedItemsRGB;
    settings.companyEmail = companyEmail;
    settings.companyNumber = companyNumber;
    settings.companyName = companyName;
    settings.instantUpdates = instantUpdates;
    settings.enabledAnalytics = enabledAnalytics;
    settings.enableShare = enableShare;
    settings.enableSafeArea = enableSafeArea;
    settings.enableNoInternetPopup = enableNoInternetPopup;
    settings.enableConstructionMode = enableConstructionMode;
    settings.enableAuthorization = enableAuthorization;
    settings.enableFacebookLogin = enableFacebookLogin;
    settings.enableGoogleLogin = enableGoogleLogin;
    settings.enableEmailLogin = enableEmailLogin;
    settings.enableRTL = enableRTL;
    settings.enableScreenSecurity = enableScreenSecurity;
    settings.enableExitApp = enableExitApp;
    settings.enableLandscape = enableLandscape;
    settings.enableShowTitlesAlwaysForBottomMenu = enableShowTitlesAlwaysForBottomMenu;
    settings.loadingType = loadingType;
    settings.bottomNavigationType = bottomNavigationType;
    settings.fontName = fontName;
    settings.loadingSize = loadingSize;
    settings.loadingRGB = loadingRGB;
    settings.youtube = youtube;
    settings.instagram = instagram;
    settings.twitter = twitter;
    settings.facebook = facebook;
    settings.vimeo = vimeo;
    settings.pinterest = pinterest;
    settings.linkedin = linkedin;
    settings.tiktok = tiktok;
    settings.aboutUs = aboutUs;
    return settings;
  }

  Color getTopBarColor() {
    return Color.fromRGBO(topBarRGB[0], topBarRGB[1], topBarRGB[2], 1);
  }

  Color getTopBarItemsColor() {
    return Color.fromRGBO(topBarItemsRGB[0], topBarItemsRGB[1], topBarItemsRGB[2], 1);
  }

  Color getBottomBarColor() {
    return Color.fromRGBO(bottomBarRGB[0], bottomBarRGB[1], bottomBarRGB[2], 1);
  }

  Color getBottomBarItemsColor() {
    return Color.fromRGBO(bottomBarItemsRGB[0], bottomBarItemsRGB[1], bottomBarItemsRGB[2], 1);
  }

  Color getBottomBarSelectedItemsColor() {
    return Color.fromRGBO(bottomBarSelectedItemsRGB[0], bottomBarSelectedItemsRGB[1], bottomBarSelectedItemsRGB[2], 1);
  }

  Color getLoadingColor() {
    return Color.fromRGBO(loadingRGB[0], loadingRGB[1], loadingRGB[2], 1);
  }
}
