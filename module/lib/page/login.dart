import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:module/base/base.dart';
import 'package:module/base/hud.dart';
import 'package:module/base/manager.dart';
import 'package:module/base/notifier.dart';
import 'package:module/base/route.dart';
import 'package:module/model/input.dart';
import 'package:module/view/button.dart';
import 'package:module/view/textfield.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController commonController = TextEditingController()
      ..text = Manager.global.user?.username ?? '';
    TextEditingController passwordController = TextEditingController()
      ..text = Manager.global.user?.password ?? '';

    Input input = Input()
      ..common = commonController.text
      ..password = passwordController.text;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          final inputNotifier = UserChangeNotifier();
          inputNotifier.addListener(() {
            input = inputNotifier.input!;
            commonController.text = input.common ?? '';
            passwordController.text = input.password ?? '';
          });
          return inputNotifier;
        }),
        ChangeNotifierProvider(
            create: (context) => InputNotifier()..input = input),
      ],
      child: BasePage(
        titleImageName: 'assets/images/title_account_login.png',
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            UITextField(
              controller: commonController,
              mode: TextFieldMode.common,
            ),
            const SizedBox(height: 10),
            UITextField(
              controller: passwordController,
              mode: TextFieldMode.password,
            ),
            const SizedBox(height: 20),
            UITitleButton(
              title: '登录',
              onPressed: () {
                String common = input.common ?? '';
                String password = input.password ?? '';
                _login(common, password);
              },
            ),
            Align(
              alignment: Alignment.centerRight,
              child: UISmallButton(
                title: '忘记密码',
                onPressed: () {
                  Routes.navigateTo(context, Routes.forget);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _login(String common, String password) {
    if (common.isEmpty) {
      HUD.showInfo('请输入用户名');
      return;
    }
    if (password.isEmpty) {
      HUD.showInfo('请输入密码');
      return;
    }

    Manager.sdkLoginRequest(common, password);
  }
}
