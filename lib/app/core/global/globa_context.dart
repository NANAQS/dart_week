import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class GlobaContext {
  //! atencao nao deixar navigator publico
  late final GlobalKey<NavigatorState> _navigatorKey;

  static GlobaContext? _instance;
  // Avoid self isntance
  GlobaContext._();
  static GlobaContext get i {
    _instance ??= GlobaContext._();
    return _instance!;
  }

  set navigatorKey(GlobalKey<NavigatorState> key) => _navigatorKey = key;

  Future<void> LoginExpire() async {
    final sp = await SharedPreferences.getInstance();
    sp.clear();
    showTopSnackBar(
      _navigatorKey.currentState!.overlay!,
      const CustomSnackBar.error(
        message: "Login Expirado, Click na sacola novamente",
        backgroundColor: Colors.black,
      ),
    );
    _navigatorKey.currentState!.popUntil(ModalRoute.withName("/home"));
  }
}
