import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rapid_news/Resources/colors.dart';
import 'package:rapid_news/Resources/constants.dart';

ValueNotifier activePageNotifier = ValueNotifier(0);

class KNavigationBar extends StatelessWidget {
  final List navList;
  String get navIconPath => "$kIconPath/navigation";
  const KNavigationBar({super.key, required this.navList});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Kolor.scaffold,
        boxShadow: [
          BoxShadow(
            color: Kolor.border.lighten(),
            offset: Offset(0, 5),
            blurRadius: 20,
            spreadRadius: 10,
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: navList
              .map(
                (e) => btn(
                    iconPath: e['iconPath'],
                    index: e['index'],
                    label: e['label']),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget btn({
    required String iconPath,
    required int index,
    required String label,
  }) {
    return Expanded(
      child: ValueListenableBuilder(
        valueListenable: activePageNotifier,
        builder: (context, activePage, _) {
          final selected = activePage == index;
          return IconButton(
            onPressed: () {
              activePageNotifier.value = index;
            },
            icon: Column(
              spacing: 7,
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  selected
                      ? "$navIconPath/$iconPath-filled.svg"
                      : "$navIconPath/$iconPath.svg",
                  height: 17,
                  colorFilter: ColorFilter.mode(
                    selected ? Kolor.primary : Kolor.fadeText,
                    BlendMode.srcIn,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: "",
                    fontVariations: [
                      FontVariation.weight(selected ? 700 : 600)
                    ],
                    color: selected ? null : Kolor.fadeText,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
