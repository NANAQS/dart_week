import 'package:flutter/material.dart';
import 'app/delivery_app.dart';
import './app/core/config/env/env.dart';

void main() async {
  await Env.i.load();
  runApp(DeliveryApp());
}
