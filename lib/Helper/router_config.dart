import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rapid_news/Pages/News_UI.dart';
import 'package:rapid_news/Pages/Root_UI.dart';

final goRouterProvider = Provider<GoRouter>(
  (ref) {
    return GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const Root_UI(),
        ),
        GoRoute(
          path: '/news',
          builder: (context, state) {
            final newsData = state.extra as Map<String, dynamic>;
            return News_UI(
              newsData: newsData,
            );
          },
        ),
      ],
    );
  },
);
