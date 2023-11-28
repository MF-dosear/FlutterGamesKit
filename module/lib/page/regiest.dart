import 'package:flutter/material.dart';
import 'package:module/base/base.dart';
import 'package:module/base/hud.dart';
import 'package:module/base/manager.dart';
import 'package:module/base/net.dart';
import 'package:module/base/notifier.dart';
import 'package:module/view/button.dart';
import 'package:module/view/textfield.dart';
import 'package:provider/provider.dart';

class PhoneRegPage extends StatefulWidget {
  const PhoneRegPage({super.key});

  @override
  State<PhoneRegPage> createState() => _PhoneRegPageState();
}

class _PhoneRegPageState extends State<PhoneRegPage> {
  @override
  Widget build(BuildContext context) {
    final inputNotifier = InputNotifier();
    return ChangeNotifierProvider(
      create: (context) => inputNotifier,
      child: BasePage(
        titleImageName: 'assets/images/title_phone_regiest.png',
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
              smsType: 3,
            ),
            const SizedBox(height: 10),
            const UITextField(
              mode: TextFieldMode.password,
            ),
            const SizedBox(height: 20),
            UITitleButton(
              title: '注册',
              onPressed: () {
                String phone = inputNotifier.input?.phone ?? '';
                String code = inputNotifier.input?.code ?? '';
                String password = inputNotifier.input?.password ?? '';
                _regiest(phone, code,password);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _regiest(String phone, String code, String password) {
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

    Net.phoneRegiest(phone, code, password).then((value) {
      if (value.flag) {
        Manager.sdkLoginRequest(phone, password);
      } else {
        HUD.showFail(value.msg);
      }
    });
  }
}
