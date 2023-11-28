import 'package:flutter/material.dart';
import 'package:module/base/base.dart';
import 'package:module/base/hud.dart';
import 'package:module/base/manager.dart';
import 'package:module/base/route.dart';
import 'package:module/view/button.dart';

class CheckPage extends StatelessWidget {
  const CheckPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isSeleted = false;

    return BasePage(
      titleImageName: 'assets/images/title_one_login.png',
      isBack: false,
      isClose: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 18, bottom: 18),
            child: Text(
              '15072****60',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          UITitleButton(
            title: '本机号码一键登录',
            onPressed: () {
              if (isSeleted || Manager.global.info?.isuserprotocol == '0') {
                HUD.showSuccess('登录成功').then((value) {
                  Navigator.pop(context);
                  Manager.methods.sdkLoginResult(true, {
                    'uid': Manager.global.user?.uid,
                    'name': Manager.global.user?.username,
                    'session': Manager.global.user?.sid
                  });
                });
              } else {
                HUD.showFail('请阅读并同意《注册协议及隐私条款》').then((value) {
                  debugPrint('弹框结束');
                });
              }
            },
          ),
          const SizedBox(height: 10),
          UITitleButton(
            title: '其他手机号码登录',
            mode: ButtonBackgroundMode.seleted,
            onPressed: () {
              Routes.navigateTo(context, Routes.phoneLogin);
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
          Manager.global.info?.isuserprotocol == '0'
              ? const SizedBox(
                  height: 1,
                )
              : UIAgreementButton(
                  url: Manager.global.info?.userprotocol,
                  onChick: (flag) {
                    isSeleted = flag;
                  }),
        ],
      ),
    );
  }
}
