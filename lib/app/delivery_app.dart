import 'package:flutter/material.dart';
import 'package:vaquinha_burger_app/app/pages/auth/login/login_router.dart';
import 'package:vaquinha_burger_app/app/pages/auth/register/register_router.dart';
import 'package:vaquinha_burger_app/app/pages/home/home_router.dart';
import 'package:vaquinha_burger_app/app/pages/order/order_router.dart';
import 'package:vaquinha_burger_app/app/pages/order/widget/order_completed/order_completed_page.dart';
import 'package:vaquinha_burger_app/app/pages/product_detail/product_detail_router.dart';
import 'package:vaquinha_burger_app/app/pages/splash/splash_page.dart';
import 'core/global/globa_context.dart';
import 'core/ui/theme/theme_config.dart';
import 'core/provider/application_binding.dart';

class DeliveryApp extends StatelessWidget {
  final _navKey = GlobalKey<NavigatorState>();
  DeliveryApp({super.key}) {
    GlobaContext.i.navigatorKey = _navKey;
  }

  @override
  Widget build(BuildContext context) {
    return ApplicationBinding(
      child: MaterialApp(
        navigatorKey: _navKey,
        theme: ThemeConfig.theme,
        title: "Delivery App",
        routes: {
          "/": (context) => const SplashPage(),
          "/home": (context) => HomeRouter.page,
          "/productDetail": (context) => ProductDetailRouter.page,
          "/order": (context) => OrderRouter.page,
          "/auth/login": (context) => LoginRouter.page,
          "/auth/register": (context) => RegisterRouter.page,
          "/ordercompleted": (context) => const OrderCompletedPage(),
        },
      ),
    );
  }
}
