import 'dart:convert';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rapid_news/Helper/api_config.dart';

final trendingNewsFuture = FutureProvider.autoDispose<Map?>(
  (ref) async {
    final res = await apiCallBack(path: "/news/fetch-trending");
    if (!res.error) {
      return res.data;
    }
    return null;
  },
);

final allNewsListProvider = StateProvider.autoDispose<List>((ref) => []);
final allNewsFuture = FutureProvider.autoDispose.family<void, String>(
  (ref, params) async {
    try {
      Map<String, dynamic> body = jsonDecode(params);

      final pageNo = body["pageNo"];
      final res = await apiCallBack(path: "/news/fetch", body: body);

      if (!res.error) {
        final dataList = res.data["articles"] as List;
        if (pageNo == 1) {
          ref.read(allNewsListProvider.notifier).state = [];
        }
        ref.read(allNewsListProvider.notifier).state.addAll(dataList);
      }
    } catch (e) {
      log("$e");
    }
  },
);
