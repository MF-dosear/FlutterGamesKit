class Info {
  Info();

  String? gameName;
  String? isopensmrz;
  String? isopenyange;
  String? isopenwxlogin;
  String? wxappid;
  String? qqappid;
  String? isShare;
  String? isuserprotocol;
  String? userprotocol;
  String? universalLink;
  String? exitimageurl;
  String? exitimageclickurl;
  int? bftime;
  String? isgdt;
  String? userprivate;
  String? smrzshowclosebutton;
  String? cpfangchenmi;
  String? isjmreglogin;
  int? newsid;
  int? questionid;
  int? iosgameid;
  int? androidgameid;

  // 弹框
  Map? red;

  ///// 统计
  //bool? isTT;
  bool? isGDT;
  bool? isAQY;

  // 其他信息
  bool? isInit; // 是否初始化
  bool? isLogin; // 是否登录

  // 分享
  bool? isWx;
  bool? isQQ;

  String? userAgent; // userAgent
}
// flutter packages pub run buildrunner build --delete-conflicting-outputs