import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:module/base/hud.dart';
import 'package:module/base/manager.dart';
import 'package:module/base/net.dart';
import 'package:module/base/notifier.dart';
import 'package:module/model/input.dart';
import 'package:provider/provider.dart';

enum TextFieldMode { common, account, password, phone, code, name, idCard }

class UITextField extends StatefulWidget {
  const UITextField({
    super.key,
    required this.mode,
    this.smsType,
    this.controller,
  });

  final TextFieldMode mode;
  final int? smsType;
  final TextEditingController? controller;

  @override
  State<UITextField> createState() => _UITextFieldState();
}

class _UITextFieldState extends State<UITextField> {
  final Color color = Colors.amber;
  bool obscureText = true;
  bool enabled = true;
  String codeText = '获取验证码';
  Timer? timer;

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      controller: widget.controller,
      prefix: SizedBox(
          width: 43,
          height: 43,
          child: Icon(prefixImage(widget.mode), color: color)),
      placeholder: name(widget.mode),
      placeholderStyle: const TextStyle(
        color: Colors.black38,
        fontSize: 16,
      ),
      suffix: suffixWidget(widget.mode),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/tx_background.png'),
          fit: BoxFit.fill,
        ),
      ),
      keyboardType: type(widget.mode),
      onChanged: (value) {
        final input = context.read<InputNotifier>().input ?? Input();

        switch (widget.mode) {
          case TextFieldMode.common:
            input.common = value;
            break;
          case TextFieldMode.account:
            input.account = value;
            break;
          case TextFieldMode.phone:
            input.phone = value;
            break;
          case TextFieldMode.password:
            input.password = value;
            break;
          case TextFieldMode.code:
            input.code = value;
            break;
          case TextFieldMode.name:
            input.name = value;
            break;
          case TextFieldMode.idCard:
            input.idCard = value;
            break;
          default:
            input.common = value;
            break;
        }
        Provider.of<InputNotifier>(context, listen: false).input = input;
      },
      obscureText: widget.mode == TextFieldMode.password ? obscureText : false,
      clearButtonMode: OverlayVisibilityMode.editing,
      maxLength: max(widget.mode),
    );
  }

  String hasPrefix(TextFieldMode mode) {
    switch (mode) {
      case TextFieldMode.common:
        return '手机号/用户名';
      case TextFieldMode.account:
        return '用户名';
      case TextFieldMode.phone:
        return '手机号';
      case TextFieldMode.password:
        return '密码';
      case TextFieldMode.code:
        return '验证码';
      case TextFieldMode.name:
        return '真实姓名';
      case TextFieldMode.idCard:
        return '身份证号';
      default:
        return '未选择类型';
    }
  }

  int max(TextFieldMode mode) {
    switch (mode) {
      case TextFieldMode.common:
        return 20;
      case TextFieldMode.account:
        return 20;
      case TextFieldMode.phone:
        return 11;
      case TextFieldMode.password:
        return 20;
      case TextFieldMode.code:
        return 6;
      case TextFieldMode.name:
        return 25;
      case TextFieldMode.idCard:
        return 18;
      default:
        return 20;
    }
  }

  String name(TextFieldMode mode) {
    switch (mode) {
      case TextFieldMode.common:
        return '请输入用户名';
      case TextFieldMode.account:
        return '请输入账号';
      case TextFieldMode.phone:
        return '请输入手机号';
      case TextFieldMode.password:
        return '请输入密码';
      case TextFieldMode.code:
        return '请输入验证码';
      case TextFieldMode.name:
        return '请输入真实姓名';
      case TextFieldMode.idCard:
        return '请输入身份证号';
      default:
        return '未选择类型';
    }
  }

  IconData prefixImage(TextFieldMode mode) {
    switch (mode) {
      case TextFieldMode.common:
        return Icons.person_rounded;
      case TextFieldMode.account:
        return Icons.person_rounded;
      case TextFieldMode.phone:
        return Platform.isIOS
            ? Icons.phone_iphone_rounded
            : Icons.phone_android_rounded;
      case TextFieldMode.password:
        return Icons.password_rounded;
      case TextFieldMode.code:
        return Icons.mark_email_unread_rounded;
      case TextFieldMode.name:
        return Icons.person_rounded;
      case TextFieldMode.idCard:
        return Icons.quick_contacts_mail_rounded;
      default:
        return Icons.person_rounded;
    }
  }

  Widget? suffixWidget(TextFieldMode mode) {
    switch (mode) {
      case TextFieldMode.phone:
        return null;
      case TextFieldMode.name:
        return null;
      case TextFieldMode.idCard:
        return null;
      case TextFieldMode.account:
        return null;
      case TextFieldMode.code:
        return SendCode(
          title: codeText,
          onPressed: _sendMsg,
        );
      case TextFieldMode.password:
        return EyeSeleted(
          color: color,
          obscureText: obscureText,
          onPressed: () {
            setState(() {
              obscureText = !obscureText;
            });
          },
        );
      default:
        return UserItems(
          color: color,
          onChanged: (value) {},
        );
    }
  }

  TextInputType type(TextFieldMode mode) {
    switch (mode) {
      case TextFieldMode.common:
        return TextInputType.visiblePassword;
      case TextFieldMode.account:
        return TextInputType.visiblePassword;
      case TextFieldMode.phone:
        return TextInputType.phone;
      case TextFieldMode.password:
        return TextInputType.visiblePassword;
      case TextFieldMode.code:
        return TextInputType.number;
      case TextFieldMode.name:
        return TextInputType.name;
      case TextFieldMode.idCard:
        return TextInputType.datetime;
      default:
        return TextInputType.name;
    }
  }

  void _sendMsg() {
    final input = context.read<InputNotifier>().input;
    final phone = input?.phone ?? '';
    if (phone.length != 11) {
      HUD.showInfo('请输入正确手机号');
      return;
    }

    if (enabled) {
      enabled = false;
      Net.sendMsg('', phone, widget.smsType!).then((value) {
        if (value.flag) {
          HUD.showSuccess('发送验证码成功');
          int i = 61;
          timer = Timer.periodic(const Duration(seconds: 1), (timer) {
            i--;
            if (i == 0) {
              enabled = true;
              setState(() {
                codeText = '发送验证码';
                timer.cancel();
              });
            } else {
              // debugPrint('$i');
              setState(() {
                codeText = '$i秒';
              });
            }
          });
        } else {
          HUD.showFail(value.msg);
          enabled = true;
        }
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
    debugPrint('TextField销毁');
  }
}

class UserItems extends StatelessWidget {
  const UserItems({super.key, required this.color, required this.onChanged});

  final Color color;
  final ValueChanged onChanged;

  @override
  Widget build(BuildContext context) {
    List list = Manager.global.list ?? [];
    return SizedBox(
      width: 43,
      height: 43,
      child: PopupMenuButton(
        constraints: const BoxConstraints(maxHeight: 200),
        itemBuilder: (BuildContext context) {
          return list
              .map(
                (dict) => UserMenuItem(
                  dict: dict,
                  isSeleted: list.indexOf(dict) == 0,
                ),
              )
              .toList();
        },
        onSelected: (map) {
          list.remove(map);
          list.insert(0, map);
          Manager.global.list = list;
          Manager.pref.setString('userCache', json.encode(list));

          final input = Input();
          input.common = map['username'];
          input.password = map['password'];
          Provider.of<UserChangeNotifier>(context, listen: false).input = input;
        },
        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: color,
        ),
      ),
    );
  }
}

class EyeSeleted extends StatelessWidget {
  const EyeSeleted(
      {super.key,
      required this.color,
      required this.onPressed,
      required this.obscureText});

  final Color color;
  final VoidCallback? onPressed;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(vertical: 5),
      onPressed: onPressed,
      child: Icon(
        obscureText ? Icons.blur_off_rounded : Icons.blur_on_rounded,
        color: color,
      ),
    );
  }
}

class SendCode extends StatelessWidget {
  const SendCode({
    super.key,
    required this.title,
    required this.onPressed,
  });

  final String title;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.only(right: 5, top: 0, bottom: 0),
      onPressed: onPressed,
      child: Container(
        height: 30,
        width: 85,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/tx_code.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class UserMenuItem extends PopupMenuItem {
  UserMenuItem({
    super.key,
    dynamic dict,
    bool isSeleted = false,
  }) : super(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          value: dict,
          child: ListTile(
            leading: Icon(
              Icons.person_rounded,
              color: isSeleted ? Colors.amber : Colors.black54,
            ),
            title: Text(
              dict['username'] ?? '标题',
              style: TextStyle(
                  color: isSeleted ? Colors.amber : Colors.black54,
                  fontSize: 16),
            ),
          ),
        );
}
