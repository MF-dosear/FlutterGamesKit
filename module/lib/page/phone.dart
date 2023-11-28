import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:module/base/base.dart';
import 'package:module/base/hud.dart';
import 'package:module/base/manager.dart';
import 'package:module/base/net.dart';
import 'package:module/base/notifier.dart';
import 'package:module/base/route.dart';
import 'package:module/model/user.dart';
import 'package:module/view/button.dart';
import 'package:module/view/textfield.dart';
import 'package:provider/provider.dart';

class PhoneLoginPage extends StatelessWidget {
  const PhoneLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final inputNotifier = InputNotifier();
    return ChangeNotifierProvider(
      create: (context) => inputNotifier,
      child: BasePage(
        titleImageName: 'assets/images/title_phone_login.png',
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            const UITextField(
              mode: TextFieldMode.phone,
            ),
            const SizedBox(height: 10),
            const UITextField(
              mode: TextFieldMode.code,
              smsType: 6,
            ),
            const SizedBox(height: 20),
            UITitleButton(
              title: '登录',
              onPressed: () {
                String phone = inputNotifier.input?.phone ?? '';
                String code = inputNotifier.input?.code ?? '';
                _login(phone, code);
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                UISmallButton(
                  title: '账号登录',
                  onPressed: () {
                    Routes.navigateTo(context, Routes.login);
                  },
                ),
                UISmallButton(
                  title: '快速注册',
                  onPressed: () {
                    Routes.navigateTo(context, Routes.quickLogin);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _login(String phone, String code) {
    if (phone.isEmpty) {
      HUD.showInfo('请输入正确手机号');
      return;
    }
    if (code.isEmpty) {
      HUD.showInfo('请输入验证码');
      return;
    }
    Net.phoneLogin(phone, code).then((value) {
      if (value.flag) {
        Map data = value.data;

        User user = User();
        user.uid = data['uid'];
        user.username = data['user_name'];
        user.nickname = data['nick_name'];
        user.profile = data['profile'];
        user.sid = data['sid'];
        user.trueName = data['trueName'];
        user.userSex = data['userSex'];
        user.idCard = data['idCard'];
        user.age = data['age'];
        user.birthday = data['birthday'];
        user.trueNameSwitch = data['trueNameSwitch'];
        user.buoyState = data['buoyState'];
        user.isshowbinding = data['is_show_binding'];
        user.mobile = data['mobile'];
        user.isBindMobile = data['isBindMobile'];
        user.drurl = data['drurl'];
        user.isShare = data['isShare'];
        user.isOldUser = data['isOldUser'];
        user.adult = data['adult'];
        user.issmrz = data['is_smrz'];
        user.wxappid = data['wx_appid'];
        user.qqappid = data['qqappid'];
        user.password = data['userPass'];
        Manager.global.user = user;

        HUD.showSuccess('登录成功').then((value) {
          Manager.methods.dismiss();
          Manager.methods.sdkLoginResult(true,
              {'uid': user.uid, 'name': user.username, 'session': user.sid});
        });
      } else {
        Manager.methods.sdkLoginResult(false, {});
        HUD.showFail(value.msg);
      }
    });
  }
}
