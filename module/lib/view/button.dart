import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:module/base/call.dart';
import 'package:url_launcher/url_launcher_string.dart';

enum ButtonBackgroundMode {
  normal,
  seleted,
}

class UITitleButton extends StatelessWidget {
  const UITitleButton(
      {super.key,
      required this.title,
      required this.onPressed,
      this.mode = ButtonBackgroundMode.normal,
      this.width});

  final String title;
  final VoidCallback? onPressed;
  final ButtonBackgroundMode? mode;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(vertical: 0),
      onPressed: onPressed,
      child: Container(
        width: width ?? double.infinity,
        height: 45,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(mode == ButtonBackgroundMode.normal
                ? 'assets/images/btn_sel.png'
                : 'assets/images/btn_nor.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 17,
            // fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class UISmallButton extends StatelessWidget {
  const UISmallButton(
      {super.key, required this.title, required this.onPressed});

  final String title;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.all(0),
      onPressed: onPressed,
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black54,
          fontSize: 15,
        ),
      ),
    );
  }
}

class UIAgreementButton extends StatefulWidget {
  const UIAgreementButton(
      {super.key,
      required this.onChick,
      this.title = '《隐私政策、用户协议》',
      this.url});

  final String title;
  final String? url;
  final BoolCallback onChick;

  @override
  State<UIAgreementButton> createState() => _UIAgreementButtonState();
}

class _UIAgreementButtonState extends State<UIAgreementButton> {
  bool _isSeleted = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CupertinoButton(
          padding: const EdgeInsets.all(0),
          onPressed: () {
            setState(() {
              _isSeleted = !_isSeleted;
            });
            widget.onChick(_isSeleted);
          },
          child: Icon(
            Icons.check_box_rounded,
            color: _isSeleted ? Colors.blueAccent : Colors.grey,
          ),
        ),
        const Text(
          '请阅读并同意',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
        CupertinoButton(
            padding: const EdgeInsets.all(0),
            child: Text(
              widget.title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.blueAccent,
              ),
            ),
            onPressed: () {
              launchUrlString(widget.url ?? '');
            }),
      ],
    );
  }
}
