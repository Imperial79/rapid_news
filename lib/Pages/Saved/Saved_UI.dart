import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rapid_news/Components/KScaffold.dart';
import 'package:rapid_news/Resources/constants.dart';

import '../../Components/Label.dart';
import '../../Components/kWidgets.dart';
import '../../Resources/colors.dart';
import '../../Resources/commons.dart';

class Saved_UI extends StatefulWidget {
  const Saved_UI({super.key});

  @override
  State<Saved_UI> createState() => _Saved_UIState();
}

class _Saved_UIState extends State<Saved_UI> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        fetchSavedNews();
      },
    );
  }

  List bookmarkedNews = [];

  fetchSavedNews() {
    final hiveBox = Hive.box("hiveBox");
    bookmarkedNews = hiveBox.values.toList();
    log("$bookmarkedNews");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return KScaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(kPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Label("Bookmarked", weight: 400, fontSize: 30).title,
              height20,
              if (bookmarkedNews.isNotEmpty)
                ListView.separated(
                  separatorBuilder: (context, index) => Divider(
                    height: 50,
                    color: Kolor.border.lighten(.6),
                  ),
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: bookmarkedNews.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) =>
                      newsTile(bookmarkedNews[index]),
                )
              else
                kNoData(
                  context,
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget newsTile(Map data) {
    return InkWell(
      onTap: () => context.push("/news", extra: data).then(
            (value) => fetchSavedNews(),
          ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 15,
        children: [
          Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: data["urlToImage"] != null
                    ? NetworkImage(
                        data["urlToImage"],
                      )
                    : AssetImage("$kImagePath/no-image.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                kUnderline(
                  child: Label(data["source"]["name"], weight: 500).regular,
                ),
                height15,
                Label(data["title"], weight: 500, maxLines: 3, fontSize: 17)
                    .title,
                height15,
                Label("${data["author"] ?? "Anonymous"} • ${kDateFormat(data["publishedAt"])}",
                        weight: 500)
                    .subtitle,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
