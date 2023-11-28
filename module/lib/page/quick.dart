import 'dart:math';

import 'package:flutter/material.dart';
import 'package:module/base/base.dart';
import 'package:module/base/hud.dart';
import 'package:module/base/manager.dart';
import 'package:module/base/net.dart';
import 'package:module/base/notifier.dart';
import 'package:module/base/route.dart';
import 'package:module/model/input.dart';
import 'package:module/view/button.dart';
import 'package:module/view/textfield.dart';
import 'package:provider/provider.dart';

class QuickLoginPage extends StatelessWidget {
  const QuickLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController accountController = TextEditingController()
      ..text = 'GY${DateTime.now().millisecondsSinceEpoch.toString()}';
    TextEditingController passwordController = TextEditingController()
      ..text = (60000000 + Random().nextInt(10000000)).toString();
    Input input = Input()
          ..account = accountController.text
          ..password = passwordController.text;

    return ChangeNotifierProvider(
      create: (context) => InputNotifier()..input = input,
      child: BasePage(
        titleImageName: 'assets/images/title_quick_regiest.png',
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '系统已自动分配账号，为了方便记忆，您可自行设置',
              style: TextStyle(
                fontSize: 13,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            UITextField(
              controller: accountController,
              mode: TextFieldMode.account,
            ),
            const SizedBox(height: 10),
            UITextField(
              controller: passwordController,
              mode: TextFieldMode.password,
            ),
            const SizedBox(height: 20),
            UITitleButton(
              title: '注册',
              onPressed: () {
                String account = input.account ?? '';
                String password = input.password ?? '';
                _regiest(account, password);
              },
            ),
            Align(
              alignment: Alignment.centerRight,
              child: UISmallButton(
                title: '手机注册',
                onPressed: () {
                  Routes.navigateTo(context, Routes.phoneRegiest);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _regiest(String account, String password) {
    if (account.isEmpty) {
      HUD.showInfo('请输入用户名');
      return;
    }
    if (password.isEmpty) {
      HUD.showInfo('请输入密码');
      return;
    }

    Net.regiest(account, password).then((value) {
      if (value.flag) {
        Manager.sdkLoginRequest(account, password);
      } else {
        HUD.showFail(value.msg);
      }
    });
  }
}
