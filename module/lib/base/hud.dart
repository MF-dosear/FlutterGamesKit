import 'package:module/base/manager.dart';
import 'package:module/base/method.dart';

class HUD {
  static Future showSuccess(String text) async {
    return Manager.methods.show(HUDMode.success, title: text);
  }

  static Future showFail(String text) async {
    return Manager.methods.show(HUDMode.fail, title: text);
  }

  static Future showInfo(String text) async {
    return Manager.methods.show(HUDMode.info, title: text);
  }

  static Future show() async {
    return Manager.methods.show(HUDMode.none);
  }

  static Future dismiss() async {
    return Manager.methods.show(HUDMode.dismiss);
  }
}
