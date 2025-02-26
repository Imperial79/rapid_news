// ignore_for_file: unused_result

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:rapid_news/Components/KNavigationBar.dart';
import 'package:rapid_news/Components/KScaffold.dart';
import 'package:rapid_news/Components/KSearchbar.dart';
import 'package:rapid_news/Components/Label.dart';
import 'package:rapid_news/Components/kCard.dart';
import 'package:rapid_news/Components/kWidgets.dart';
import 'package:rapid_news/Helper/data.dart';
import 'package:rapid_news/Repository/newsRepo.dart';
import 'package:rapid_news/Resources/colors.dart';
import 'package:rapid_news/Resources/commons.dart';
import 'package:rapid_news/Resources/constants.dart';
import 'package:rapid_news/Resources/theme.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Home_UI extends ConsumerStatefulWidget {
  const Home_UI({super.key});

  @override
  ConsumerState<Home_UI> createState() => _Home_UIState();
}

class _Home_UIState extends ConsumerState<Home_UI> {
  FlutterCarouselController? carouselController;
  final activeCarousel = ValueNotifier(0);
  String category = "all";
  final pageNo = ValueNotifier(1);

  @override
  void initState() {
    super.initState();

    carouselController = FlutterCarouselController();
  }

  Future<void> _refresh() async {
    pageNo.value = 0;
    ref.refresh(trendingNewsFuture.future);
    ref.refresh(allNewsFuture(jsonEncode({
      "category": category,
      "pageNo": pageNo.value,
    })).future);
  }

  @override
  Widget build(BuildContext context) {
    final trendingList = ref.watch(trendingNewsFuture);
    final allNewsAsync = ref.watch(allNewsFuture(jsonEncode({
      "category": category == "all" ? "general" : category,
      "pageNo": pageNo.value,
    })));
    final allNewsList = ref.watch(allNewsListProvider);

    return RefreshIndicator(
      onRefresh: _refresh,
      child: KScaffold(
        body: DefaultTabController(
          length: kCategoryList.length,
          child: SafeArea(
            child: CustomScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(kPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Label("Rapid News", weight: 400, fontSize: 30).title,
                        height20,
                        GestureDetector(
                          onTap: () {
                            activePageNotifier.value = 1;
                          },
                          child: KCard(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 14),
                            radius: 100,
                            borderWidth: 1,
                            color: Kolor.scaffold,
                            borderColor: Kolor.border,
                            child: Row(
                              spacing: 10,
                              children: [
                                Icon(
                                  CupertinoIcons.search,
                                  size: 30,
                                ),
                                Label("Search",
                                        fontSize: 17, color: Kolor.border)
                                    .subtitle
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: ValueListenableBuilder(
                    valueListenable: activeCarousel,
                    builder: (context, value, child) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: kPadding),
                          child: Row(
                            children: [
                              Expanded(
                                  child:
                                      Label("Trending Now", weight: 500).title),
                              IconButton(
                                onPressed: () {
                                  if (carouselController != null && value > 0) {
                                    carouselController!
                                        .animateToPage(value - 1);
                                  }
                                },
                                visualDensity: VisualDensity.compact,
                                icon: RotatedBox(
                                  quarterTurns: 2,
                                  child: SvgPicture.asset(
                                    "$kIconPath/next.svg",
                                    height: 20,
                                    colorFilter: kSvgColor(
                                        value == 0 ? Kolor.border : Kolor.text),
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  if (carouselController != null) {
                                    carouselController!
                                        .animateToPage(value + 1);
                                  }
                                },
                                visualDensity: VisualDensity.compact,
                                icon: SvgPicture.asset(
                                  "$kIconPath/next.svg",
                                  height: 20,
                                  colorFilter: kSvgColor(
                                      value == 4 ? Kolor.border : Kolor.text),
                                ),
                              ),
                            ],
                          ),
                        ),
                        FlutterCarousel(
                          items: trendingList.when(
                              data: (data) {
                                if (data != null) {
                                  return List.generate(
                                    data["articles"].length > 5
                                        ? 5
                                        : data["articles"].length,
                                    (index) =>
                                        trendingCard(data["articles"][index]),
                                  );
                                }
                                return [];
                              },
                              error: (error, stackTrace) => [SizedBox()],
                              loading: () => loadingTrendingCard()),
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
                ),
                SliverAppBar(
                  surfaceTintColor: Kolor.scaffold,
                  pinned: true,
                  backgroundColor: Colors.white,
                  flexibleSpace: TabBar(
                    onTap: (value) {
                      setState(() {
                        category = kCategoryList[value];
                      });
                    },
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabAlignment: TabAlignment.start,
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
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(kPadding),
                    child: allNewsAsync.isLoading
                        ? loadingNewsCard()
                        : ListView.separated(
                            separatorBuilder: (context, index) => Divider(
                              height: 50,
                              color: Kolor.border.lighten(.6),
                            ),
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: allNewsList.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) =>
                                newsTile(allNewsList[index]),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget newsTile(Map data) {
    return InkWell(
      onTap: () => context.push("/news", extra: data),
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

  loadingNewsCard() {
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
        height: 50,
        color: Kolor.border.lighten(.6),
      ),
      itemCount: 5,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => Skeletonizer(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 15,
          children: [
            Container(
              color: Kolor.card,
              height: 150,
              width: 150,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Label("Source", weight: 500).regular,
                  height15,
                  Label("Title of the news Title of the newsTitle of the newsTitle of the newsTitle of the newsTitle of the news",
                          weight: 500, maxLines: 3, fontSize: 17)
                      .title,
                  height15,
                  Label("Anonymous • 25 Dec, 2025", weight: 500).subtitle,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  loadingTrendingCard() {
    return List.generate(
      2,
      (index) => Skeletonizer(
          child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10)
            .copyWith(right: 0),
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
                  child: kUnderline(
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
      )),
    );
  }

  Widget trendingCard(Map data) {
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
                decoration: BoxDecoration(
                  color: Kolor.border,
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
              SizedBox(height: constraints.maxHeight * 0.02),
              Label(
                data["title"],
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
