import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:module/base/base.dart';
import 'package:module/view/button.dart';
import 'package:url_launcher/url_launcher_string.dart';

class UpdatePage extends StatelessWidget {
  const UpdatePage({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return BasePage(
      isBack: false,
      titleImageName: 'assets/images/title_update.png',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/jsons/update.json',
            height: 180,
            fit: BoxFit.fill,
          ),
          const SizedBox(height: 8),
          UITitleButton(
            title: '下载更新',
            onPressed: () {
              launchUrlString(url);
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
