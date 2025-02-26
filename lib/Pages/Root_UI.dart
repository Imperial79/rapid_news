import 'package:flutter/material.dart';
import 'package:rapid_news/Components/KNavigationBar.dart';
import 'package:rapid_news/Resources/colors.dart';
import 'package:rapid_news/Resources/commons.dart';
import 'package:animations/animations.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'Home/Home_UI.dart';

class Root_UI extends StatefulWidget {
  const Root_UI({super.key});

  @override
  State<Root_UI> createState() => _Root_UIState();
}

class _Root_UIState extends State<Root_UI> {
  final List<Widget> _screens = [
    const Home_UI(),
    const Home_UI(),
    const Home_UI(),
    const Home_UI(),
  ];

  final List _navs = [
    {"label": "Home", "iconPath": "home", "index": 0},
    {"label": "Explore", "iconPath": "explore", "index": 1},
    {"label": "Saved", "iconPath": "bookmark", "index": 2},
    {"label": "Profile", "iconPath": "profile", "index": 3},
  ];

  bool canPop = false;

  Future<void> onWillPop(didPop, result) async {
    setState(() {
      canPop = true;
    });
    KSnackbar(context, message: "Press back again to exit");

    await Future.delayed(
      Duration(seconds: 3),
      () {
        setState(() {
          canPop = false;
        });
      },
    );
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    systemColors();

    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: onWillPop,
      child: Scaffold(
        body: ValueListenableBuilder(
          valueListenable: activePageNotifier,
          builder: (context, activePage, _) {
            return PageTransitionSwitcher(
              transitionBuilder: (child, animation, secondaryAnimation) {
                return FadeThroughTransition(
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                  fillColor: Kolor.scaffold,
                  child: child,
                );
              },
              child: _screens[activePage],
            );
          },
        ),
        bottomNavigationBar: KNavigationBar(
          navList: _navs,
        ),
      ),
    );
  }
}
