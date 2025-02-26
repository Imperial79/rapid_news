// ignore_for_file: unused_result

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rapid_news/Components/KScaffold.dart';
import 'package:rapid_news/Components/KSearchbar.dart';
import 'package:rapid_news/Resources/constants.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../Components/Label.dart';
import '../../Components/kWidgets.dart';
import '../../Repository/newsRepo.dart';
import '../../Resources/colors.dart';
import '../../Resources/commons.dart';

class Explore_UI extends ConsumerStatefulWidget {
  const Explore_UI({super.key});

  @override
  ConsumerState<Explore_UI> createState() => _Explore_UIState();
}

class _Explore_UIState extends ConsumerState<Explore_UI> {
  final searchKey = TextEditingController();
  final pageNo = ValueNotifier(1);
  final sortBy = ValueNotifier("relevancy");
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreNews();
    }
  }

  void _loadMoreNews() {
    if (!ref
        .read(allNewsFuture(jsonEncode({
          "sortBy": sortBy.value,
          "searchKey": searchKey.text.trim(),
          "pageNo": pageNo.value,
        })))
        .isRefreshing) {
      pageNo.value += 1;
      ref.refresh(allNewsFuture(jsonEncode({
        "sortBy": sortBy.value,
        "searchKey": searchKey.text.trim(),
        "pageNo": pageNo.value,
      })).future);
    }
  }

  List<String> sortList = [
    "relevancy",
    "popularity",
    "publishedAt",
  ];

  Future<void> _refresh() async {
    pageNo.value = 1;
    ref.refresh(allNewsFuture(jsonEncode({
      "sortBy": sortBy.value,
      "searchKey": searchKey.text.trim(),
      "pageNo": pageNo.value,
    })).future);
    setState(() {});
  }

  @override
  void dispose() {
    searchKey.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allNewsAsync = ref.watch(allNewsFuture(jsonEncode({
      "sortBy": sortBy.value,
      "searchKey": searchKey.text.trim(),
      "pageNo": pageNo.value,
    })));
    final allNewsList = ref.watch(allNewsListProvider);
    return RefreshIndicator(
      onRefresh: _refresh,
      child: KScaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(kPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Label("Explore", weight: 400, fontSize: 30).title,
                height20,
                KSearchbar(
                  controller: searchKey,
                  hintText: "Search",
                  onFieldSubmitted: (val) {
                    _refresh();
                  },
                ),
                height10,
                Row(
                  spacing: 5,
                  children: [
                    Label("Sort by").regular,
                    ValueListenableBuilder(
                        valueListenable: sortBy,
                        builder: (context, value, _) {
                          return kUnderline(
                            child: DropdownButton(
                              value: value,
                              items: sortList
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Label(
                                        e,
                                        weight: 400,
                                      ).regular,
                                    ),
                                  )
                                  .toList(),
                              isDense: true,
                              underline: SizedBox(),
                              elevation: 0,
                              dropdownColor: Kolor.card,
                              icon: Icon(
                                Icons.keyboard_arrow_down_sharp,
                                size: 20,
                              ),
                              onChanged: (value) {
                                if (value != null) {
                                  sortBy.value = value;
                                  _refresh();
                                }
                              },
                            ),
                          );
                        }),
                  ],
                ),
                height20,
                allNewsAsync.isLoading
                    ? loadingNewsCard()
                    : allNewsList.isEmpty
                        ? kNoData(context)
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
}
