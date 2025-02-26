import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rapid_news/Components/KScaffold.dart';
import 'package:rapid_news/Components/Label.dart';
import 'package:rapid_news/Components/kWidgets.dart';
import 'package:rapid_news/Resources/colors.dart';
import 'package:rapid_news/Resources/commons.dart';
import 'package:rapid_news/Resources/constants.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

class News_UI extends StatefulWidget {
  final Map<String, dynamic> newsData;
  const News_UI({super.key, required this.newsData});

  @override
  State<News_UI> createState() => _News_UIState();
}

class _News_UIState extends State<News_UI> {
  addToBookmark() async {
    try {
      final hiveBox = Hive.box("hiveBox");
      await hiveBox.add(widget.newsData);
      KSnackbar(context, message: "Added to bookmark");
    } catch (e) {
      KSnackbar(context, message: "$e", error: true);
    }
  }

  bool isBookmarked() {
    final hiveBox = Hive.box("hiveBox");
    final bookmarkedNews =
        hiveBox.values.where((news) => news["url"] == widget.newsData["url"]);

    return bookmarkedNews.isNotEmpty;
  }

  removeFromBookmark() async {
    try {
      final hiveBox = Hive.box("hiveBox");
      final bookmarkedNews = hiveBox.values
          .where((news) => news["url"] == widget.newsData["url"])
          .toList();
      if (bookmarkedNews.isNotEmpty) {
        final key = hiveBox
            .keyAt(hiveBox.values.toList().indexOf(bookmarkedNews.first));
        await hiveBox.delete(key);
      }
      KSnackbar(context, message: "Removed from bookmark");
    } catch (e) {
      KSnackbar(context, message: "$e", error: true);
    }
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
              Row(
                children: [
                  IconButton.outlined(
                    onPressed: () {
                      context.pop();
                    },
                    style: IconButton.styleFrom(
                      side: BorderSide(
                        color: Kolor.border,
                      ),
                    ),
                    icon: Icon(Icons.arrow_back),
                  ),
                  Spacer(),
                  IconButton.outlined(
                      onPressed: () async {
                        await Share.share(
                            'check out this article ${widget.newsData["url"]}');
                      },
                      style: IconButton.styleFrom(
                        side: BorderSide(
                          color: Kolor.border,
                        ),
                      ),
                      icon: Icon(
                        Icons.share,
                        size: 20,
                      )),
                  IconButton.outlined(
                    onPressed: () async {
                      if (isBookmarked()) {
                        await removeFromBookmark();
                      } else {
                        await addToBookmark();
                      }
                      setState(() {});
                    },
                    style: IconButton.styleFrom(
                      side: BorderSide(
                        color: Kolor.border,
                      ),
                    ),
                    icon: SvgPicture.asset(
                      isBookmarked()
                          ? "$kIconPath/navigation/bookmark-filled.svg"
                          : "$kIconPath/navigation/bookmark.svg",
                      height: 17,
                    ),
                  )
                ],
              ),
              height15,
              Label(widget.newsData["title"], weight: 500, fontSize: 22).title,
              height10,
              Row(
                spacing: 10,
                children: [
                  InkWell(
                    onTap: () async {
                      if (widget.newsData["author"] != null) {
                        await launchUrlString(
                            "https://www.google.com/search?q=${widget.newsData["author"]}");
                      }
                    },
                    child: kUnderline(
                        child: Label(widget.newsData["author"] ?? "Anonymous",
                                weight: 500)
                            .regular),
                  ),
                  Label("•").regular,
                  Label(kDateFormat(widget.newsData["publishedAt"])).regular,
                ],
              ),
              height20,
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Kolor.border.lighten(),
                  image: DecorationImage(
                    image: widget.newsData["urlToImage"] != null
                        ? NetworkImage(widget.newsData["urlToImage"])
                        : AssetImage("$kImagePath/no-image.jpg"),
                    fit: widget.newsData["urlToImage"] == null
                        ? BoxFit.cover
                        : BoxFit.contain,
                  ),
                ),
              ),
              height10,
              Label(widget.newsData["source"]["name"]).subtitle,
              height20,
              Label(widget.newsData["description"], weight: 400).regular,
              Label(widget.newsData["content"], weight: 400).regular,
              height15,
              InkWell(
                onTap: () async {
                  await launchUrlString(widget.newsData["url"]);
                },
                child: kUnderline(
                  child: Row(
                    spacing: 5,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Label("Read").regular,
                      Icon(
                        Icons.insert_link_rounded,
                        size: 20,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
