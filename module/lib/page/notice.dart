import 'dart:io';
import 'package:flutter/material.dart';
import 'package:module/base/base.dart';
import 'package:module/base/manager.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NoticePage extends StatefulWidget {
  const NoticePage({super.key, required this.url});

  final String url;

  @override
  State<NoticePage> createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      titleImageName: 'assets/images/title_notice.png',
      isBack: false,
      isClose: true,
      dismissBack: () {
        Navigator.pop(context);
        Manager.sdkInitRequest();
      },
      edgeInsets:
          const EdgeInsets.only(top: 60, left: 15, right: 15, bottom: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: const WebView(
          initialUrl: 'https://www.baidu.com',
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }
}
