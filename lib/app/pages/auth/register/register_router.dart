import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaquinha_burger_app/app/pages/auth/register/register_controller.dart';
import 'package:vaquinha_burger_app/app/pages/auth/register/register_page.dart';
import 'package:provider/provider.dart';

class RegisterRouter {
  RegisterRouter._();

  static Widget get page => MultiProvider(providers: [
        Provider(
          create: (context) => RegisterController(
            context.read(),
          ),
        )
      ], child: const RegisterPage());
}
