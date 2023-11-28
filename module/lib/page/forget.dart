import 'package:flutter/material.dart';
import 'package:module/base/base.dart';
import 'package:module/base/hud.dart';
import 'package:module/base/manager.dart';
import 'package:module/base/net.dart';
import 'package:module/base/notifier.dart';
import 'package:module/view/button.dart';
import 'package:module/view/textfield.dart';
import 'package:provider/provider.dart';

class ForgetPage extends StatefulWidget {
  const ForgetPage({super.key});

  @override
  State<ForgetPage> createState() => _ForgetPageState();
}

class _ForgetPageState extends State<ForgetPage> {
  @override
  Widget build(BuildContext context) {
    final inputNotifier = InputNotifier();
    return ChangeNotifierProvider(
      create: (context) => inputNotifier,
      child: BasePage(
      titleImageName: 'assets/images/title_forget_pwd.png',
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
          const SizedBox(height: 10),
          const UITextField(
            mode: TextFieldMode.password,
          ),
          const SizedBox(height: 20),
          UITitleButton(
            title: '确认修改',
            onPressed: () {
                String phone = inputNotifier.input?.phone ?? '';
                String code = inputNotifier.input?.code ?? '';
                String password = inputNotifier.input?.password ?? '';
                _resetPwd(phone, code,password);
              },
          ),
        ],
      ),
    ),);
  }

  void _resetPwd(String phone, String code, String password) {
    if (phone.isEmpty) {
      HUD.showInfo('请输入正确手机号');
      return;
    }
    if (code.isEmpty) {
      HUD.showInfo('请输入验证码');
      return;
    }
    if (password.isEmpty) {
      HUD.showInfo('请输入密码');
      return;
    }

    Net.resetPwd(phone, code, password).then((value) {
      if (value.flag) {
        final username = value.data['user_name'];
        Manager.sdkLoginRequest(username, password);
      } else {
        HUD.showFail(value.msg);
      }
    });
  }
}
