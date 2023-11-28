import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:module/base/base.dart';
import 'package:module/base/hud.dart';
import 'package:module/base/manager.dart';
import 'package:module/base/net.dart';
import 'package:module/base/notifier.dart';
import 'package:module/view/button.dart';
import 'package:module/view/textfield.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final inputNotifier = InputNotifier();
    return ChangeNotifierProvider(
      create: (context) => inputNotifier,
      child: BasePage(
        titleImageName: 'assets/images/title_auth.png',
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            const UITextField(
              mode: TextFieldMode.name,
            ),
            const SizedBox(height: 10),
            const UITextField(
              mode: TextFieldMode.idCard,
            ),
            const SizedBox(height: 20),
            UITitleButton(
              title: '确定',
              onPressed: () {
                String name = inputNotifier.input?.name ?? '';
                String idCard = inputNotifier.input?.idCard ?? '';
                _auth(name, idCard, context);
              },
            ),
            const SizedBox(height: 10),
            const Text('1、根据国家规定，游戏用户需进行实名认证!\n2、我们承诺将严格保护您的个人信息，不会对外泄漏!'),
          ],
        ),
      ),
    );
  }

  void _auth(String name, String idcard, BuildContext context) {
    if (name.isEmpty) {
      HUD.showInfo('请输入姓名');
      return;
    }
    if (idcard.isEmpty) {
      HUD.showInfo('请输入身份证号');
      return;
    }

    Net.auth(name, idcard).then((value) {
      if (value.flag) {
        Manager.global.user?.issmrz = value.data['is_smrz'];
        final msg = value.data['msg'] ?? '';
        if (Manager.global.user?.issmrz == 0) {
          HUD.showFail(msg);
        } else {
          HUD.showSuccess(msg).then((value) {
            Navigator.pop(context);
          });
        }
      } else {
        HUD.showFail(value.msg);
      }
    });
  }
}
