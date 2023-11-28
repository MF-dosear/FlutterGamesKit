import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:module/base/base.dart';
import 'package:module/base/hud.dart';
import 'package:module/base/net.dart';
import 'package:module/base/notifier.dart';
import 'package:module/view/button.dart';
import 'package:module/view/textfield.dart';
import 'package:provider/provider.dart';

class BindPhonePage extends StatelessWidget {
  const BindPhonePage({super.key});

  @override
  Widget build(BuildContext context) {
    final inputNotifier = InputNotifier();
    return ChangeNotifierProvider(
      create: (context) => inputNotifier,
      child: BasePage(
        isBack: false,
        isClose: true,
        titleImageName: 'assets/images/title_bind_phone.png',
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
              title: '立即绑定',
              onPressed: () {
                String phone = inputNotifier.input?.phone ?? '';
                String code = inputNotifier.input?.code ?? '';
                _bind(phone, code);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _bind(String phone, String code) {
    if (phone.isEmpty) {
      HUD.showInfo('请输入正确手机号');
      return;
    }
    if (code.isEmpty) {
      HUD.showInfo('请输入验证码');
      return;
    }
    Net.bindPhone(phone, code).then((value) {
      if (value.flag) {
        HUD.showSuccess('绑定成功');
      } else {
        HUD.showFail(value.msg);
      }
    });
  }
}
