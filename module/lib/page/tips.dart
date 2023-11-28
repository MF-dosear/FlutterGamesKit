import 'package:flutter/material.dart';
import 'package:module/base/base.dart';
import 'package:module/view/button.dart';

class TipsPage extends StatelessWidget {
  const TipsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(
      titleImageName: 'assets/images/title_tips.png',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            '确定注销该账号吗？',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 50),
          Row(
            children: [
              Expanded(
                child: UITitleButton(
                  title: '确定',
                  onPressed: () {
                    // Routes.navigateTo(context, Routes.notice,
                    //     params: {'url': 'https://www.baidu.com/'});
                  },
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: UITitleButton(
                  title: '取消',
                  mode: ButtonBackgroundMode.seleted,
                  onPressed: () {
                    // Routes.navigateTo(context, Routes.notice,
                    //     params: {'url': 'https://www.baidu.com/'});
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
