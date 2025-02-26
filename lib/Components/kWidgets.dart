import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../Resources/colors.dart';
import '../Resources/commons.dart';
import 'Label.dart';
import 'kButton.dart';

Widget kUnderline({Widget? child}) {
  return Container(
    decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 2))),
    child: child,
  );
}

Widget kNoData(
  BuildContext context, {
  String? imagePath,
  String? title,
  Widget? action,
  String? subtitle,
  bool? showHome = false,
}) =>
    Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // SvgPicture.asset(
          //   imagePath ?? "$kIconPath/panda.svg",
          //   height: 200,
          // ),
          height10,
          Label(title ?? "Sorry!", fontSize: 20).title,
          Label(
            subtitle ?? "No data found.",
            fontSize: 17,
            weight: 300,
            textAlign: TextAlign.center,
          ).regular,
          height20,
          if (action == null && showHome!)
            KButton(
              onPressed: () {
                context.go("/");
              },
              label: "Go Home",
              style: KButtonStyle.regular,
              radius: 100,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              backgroundColor: kColor(context).tertiaryContainer,
              foregroundColor: kColor(context).tertiary,
            ),
          if (action != null) action
        ],
      ),
    );
