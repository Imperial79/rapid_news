import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rapid_news/Components/KScaffold.dart';
import 'package:rapid_news/Components/KSearchbar.dart';
import 'package:rapid_news/Components/Label.dart';
import 'package:rapid_news/Helper/api_config.dart';
import 'package:rapid_news/Helper/data.dart';
import 'package:rapid_news/Resources/colors.dart';
import 'package:rapid_news/Resources/commons.dart';
import 'package:rapid_news/Resources/constants.dart';
import 'package:rapid_news/Resources/theme.dart';

class Home_UI extends StatefulWidget {
  const Home_UI({super.key});

  @override
  State<Home_UI> createState() => _Home_UIState();
}

class _Home_UIState extends State<Home_UI> {
  final searchKey = TextEditingController();
  FlutterCarouselController? carouselController;
  final activeCarousel = ValueNotifier(0);

  @override
  void initState() {
    super.initState();

    carouselController = FlutterCarouselController();
  }

  @override
  void dispose() {
    searchKey.dispose();

    super.dispose();
  }

  fetchNews() async {
    try {
      final res = await apiCallBack(path: "/news/fetch");
      log("$res");
    } catch (e) {
      log("$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return KScaffold(
      body: DefaultTabController(
        length: kCategoryList.length,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(kPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Label("Rapid News", weight: 400, fontSize: 30).title,
                      height20,
                      KSearchbar(controller: searchKey, hintText: "Search"),
                    ],
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: activeCarousel,
                  builder: (context, value, child) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(kPadding)
                            .copyWith(top: 15, bottom: 0),
                        child: Row(
                          children: [
                            Expanded(
                                child:
                                    Label("Trending Now", weight: 500).title),
                            IconButton(
                              onPressed: () {
                                if (carouselController != null && value > 0) {
                                  carouselController!.animateToPage(value - 1);
                                }
                              },
                              visualDensity: VisualDensity.compact,
                              icon: RotatedBox(
                                quarterTurns: 2,
                                child: SvgPicture.asset(
                                  "$kIconPath/next.svg",
                                  height: 20,
                                  colorFilter: kSvgColor(Kolor.fadeText),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                if (carouselController != null) {
                                  carouselController!.animateToPage(value + 1);
                                }
                              },
                              visualDensity: VisualDensity.compact,
                              icon: SvgPicture.asset(
                                "$kIconPath/next.svg",
                                height: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      FlutterCarousel(
                        items: [
                          trendingCard(),
                          trendingCard(),
                        ],
                        options: FlutterCarouselOptions(
                          controller: carouselController,
                          height: 450,
                          viewportFraction: .85,
                          pageSnapping: true,
                          showIndicator: false,
                          floatingIndicator: true,
                          padEnds: false,
                          enableInfiniteScroll: false,
                          autoPlay: false,
                          onPageChanged: (index, reason) {
                            activeCarousel.value = index;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                TabBar(
                  onTap: (value) {
                    log(kCategoryList[value]);
                  },
                  isScrollable: true,
                  indicatorColor: Colors.black,
                  labelColor: Colors.black,
                  labelStyle: TextStyle(
                      fontSize: 20,
                      fontFamily: kFont,
                      fontVariations: [FontVariation.weight(600)]),
                  unselectedLabelStyle: TextStyle(
                      fontSize: 20,
                      color: Kolor.fadeText,
                      fontVariations: [FontVariation.weight(400)],
                      fontFamily: kFont),
                  tabs: [
                    ...kCategoryList.map(
                      (e) => Tab(
                        text: e,
                      ),
                    ),
                  ],
                ),
                Container(
                    // content view
                    )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget trendingCard() {
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: 20, vertical: 10).copyWith(right: 0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: constraints.maxHeight * 0.7,
                width: double.infinity,
                color: Colors.black,
              ),
              SizedBox(height: constraints.maxHeight * 0.02),
              Label(
                "Apple and Google instructed by House Commitee to prepare to deduct expenses.",
                fontSize: constraints.maxHeight * 0.04,
                maxLines: 2,
                weight: 500,
              ).regular,
              SizedBox(height: constraints.maxHeight * 0.02),
              Flexible(
                child: Label(
                  "John Doe  •  20 Dec, 2020",
                  fontSize: constraints.maxHeight * 0.03,
                  weight: 500,
                  color: Kolor.fadeText,
                ).regular,
              ),
              height10,
              InkWell(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(width: 2))),
                  child: Row(
                    spacing: 10,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Label(
                        "Read Now",
                        fontSize: constraints.maxHeight * 0.03,
                      ).regular,
                      SvgPicture.asset(
                        "$kIconPath/next.svg",
                        height: constraints.maxHeight * 0.03,
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
