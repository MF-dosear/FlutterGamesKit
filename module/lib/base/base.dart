import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BasePage extends StatelessWidget {
  const BasePage({
    super.key,
    required this.titleImageName,
    this.isBack = true,
    this.isClose = false,
    this.child,
    this.edgeInsets,
    this.dismissBack,
  });

  final Widget? child;
  final String titleImageName;
  final bool isBack;
  final bool isClose;
  final EdgeInsets? edgeInsets;
  final VoidCallback? dismissBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Material(
        type: MaterialType.transparency,
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus &&
                currentFocus.focusedChild != null) {
              FocusManager.instance.primaryFocus?.unfocus();
            }
          },
          behavior: HitTestBehavior.translucent,
          child: Center(
            child: AspectRatio(
              aspectRatio: 1.2,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Colors.transparent,
                      image: DecorationImage(
                          image: AssetImage('assets/images/background.png')),
                    ),
                    alignment: Alignment.center,
                    child: Padding(
                      padding: edgeInsets ??
                          const EdgeInsets.only(top: 40, left: 40, right: 40),
                      child: child,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        isBack
                            ? CupertinoButton(
                                padding: const EdgeInsets.only(left: 5),
                                onPressed: dismissBack ??
                                    () {
                                      Navigator.pop(context);
                                    },
                                child: Image.asset(
                                  'assets/images/icon_back.png',
                                  height: 40,
                                ),
                              )
                            : const SizedBox(height: 40, width: 50),
                        Image.asset(
                          titleImageName,
                          height: 30,
                        ),
                        isClose
                            ? CupertinoButton(
                                padding: const EdgeInsets.only(right: 5),
                                onPressed: dismissBack ??
                                    () {
                                      Navigator.pop(context);
                                    },
                                child: Image.asset(
                                  'assets/images/icon_close.png',
                                  height: 40,
                                ),
                              )
                            : const SizedBox(height: 40, width: 50),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
