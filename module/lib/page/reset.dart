import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:module/base/base.dart';
import 'package:module/view/button.dart';
import 'package:module/view/textfield.dart';

class ResetPage extends StatelessWidget {
  const ResetPage({super.key});

  @override
  Widget build(BuildContext context) {
    String account = '';
    String password = '';

    return BasePage(
      titleImageName: 'assets/images/title_reset_pwd.png',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          const UITextField(
            mode: TextFieldMode.common,
          ),
          const SizedBox(height: 10),
          const UITextField(
            mode: TextFieldMode.password,
          ),
          const SizedBox(height: 20),
          UITitleButton(
            title: '登录',
            onPressed: () {
              debugPrint('name = $account, password = $password');
            },
          )
        ],
      ),
    );
  }
}
