import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rapid_news/Pages/Root_UI.dart';

final goRouterProvider = Provider<GoRouter>(
  (ref) {
    // final authState = ref.watch(authFuture);

    return GoRouter(
        // redirect: (context, state) {
        //   if (authState.isLoading) return "/splash";
        //   if (authState.hasError) return "/server-error";
        //   return null;
        // },
        // redirectLimit: 1,
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const Root_UI(),
          ),
        ]
        // errorBuilder: (context, state) => Path_Error_UI(),
        // routes: [
        //   GoRoute(
        //     path: '/server-error',
        //     builder: (context, state) => const Server_Error_UI(),
        //   ),
        //   GoRoute(
        //     path: '/splash',
        //     builder: (context, state) => const Splash_UI(),
        //   ),
        //   GoRoute(
        //     path: '/register',
        //     builder: (context, state) => const Register_UI(),
        //   ),
        //   GoRoute(
        //     path: '/login',
        //     builder: (context, state) {
        //       final data = (state.extra as Map<String, dynamic>);
        //       final redirectPath = data["redirectPath"];
        //       final referCode = data["referCode"];

        //       return Login_UI(
        //         redirectPath: redirectPath,
        //         referCode: referCode,
        //       );
        //     },
        //     routes: [
        //       GoRoute(
        //         path: 'otp',
        //         builder: (context, state) {
        //           final extra = state.extra as Map<String, dynamic>;
        //           final phone = extra["phone"];
        //           final redirectPath = extra["redirectPath"];
        //           final referrerCode = extra["referrerCode"];
        //           return OTP_UI(
        //             phone: phone,
        //             redirectPath: redirectPath,
        //             referrerCode: referrerCode,
        //           );
        //         },
        //       ),
        //     ],
        //   ),

        //   GoRoute(
        //     path: '/product/:name/:id',
        //     builder: (context, state) {
        //       final id = state.pathParameters["id"];
        //       final referCode = state.uri.queryParameters["referCode"];
        //       final sku = state.uri.queryParameters["sku"];
        //       return Product_Detail_UI(
        //         id: int.parse("$id"),
        //         sku: sku,
        //         referCode: referCode,
        //       );
        //     },
        //   ),
        //   GoRoute(
        //     path: '/search-products',
        //     builder: (context, state) {
        //       final catgeory = state.uri.queryParameters["category"];
        //       return Search_Products_UI(
        //         category: catgeory ?? "All",
        //       );
        //     },
        //   ),
        //   GoRoute(
        //     path: '/cart',
        //     builder: (context, state) {
        //       return const Cart_UI();
        //     },
        //     routes: [
        //       GoRoute(
        //         path: 'coupons',
        //         builder: (context, state) {
        //           return Coupons_UI();
        //         },
        //       ),
        //       GoRoute(
        //         path: 'checkout',
        //         builder: (context, state) {
        //           final data = state.extra as Map;
        //           return Checkout_UI(
        //             checkoutData: data["checkoutData"] as ResponseModel,
        //             discountCoupon: data["discountCoupon"],
        //           );
        //         },
        //       ),
        //       GoRoute(
        //         path: 'confirmation',
        //         builder: (context, state) {
        //           final data = state.extra as Map;
        //           return Confirmation_UI(
        //             deliveryDays: int.parse("${data["deliveryDays"]}"),
        //             orderId: data["orderId"],
        //             totalItems: int.parse("${data["totalItems"]}"),
        //           );
        //         },
        //       ),
        //     ],
        //   ),
        //   GoRoute(
        //     path: "/affiliate",
        //     builder: (context, state) => Affiliate_UI(),
        //   ),
        //   GoRoute(
        //     path: '/profile',
        //     builder: (context, state) {
        //       return const Profile_UI();
        //     },
        //     routes: [
        //       GoRoute(
        //         path: 'edit',
        //         builder: (context, state) {
        //           return const Edit_Profile_UI();
        //         },
        //       ),
        //       GoRoute(
        //         path: 'saved-address',
        //         builder: (context, state) {
        //           return const Saved_Address_UI();
        //         },
        //       ),
        //       GoRoute(
        //         path: 'orders',
        //         builder: (context, state) {
        //           return const Orders_UI();
        //         },
        //         routes: [
        //           GoRoute(
        //             path: 'details/:orderedItemId',
        //             builder: (context, state) {
        //               String orderedItemId =
        //                   state.pathParameters["orderedItemId"]!;
        //               return Order_Detail_UI(
        //                 orderedItemId: orderedItemId,
        //               );
        //             },
        //           ),
        //         ],
        //       ),
        //       GoRoute(
        //         path: 'transactions',
        //         builder: (context, state) {
        //           return const Transactions_UI();
        //         },
        //       ),
        //     ],
        //   ),
        //   GoRoute(
        //     path: "/help",
        //     builder: (context, state) => ContactUsUI(),
        //   ),
        // ],
        );
  },
);
