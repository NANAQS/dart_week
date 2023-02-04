//singleton pattern

import 'package:flutter/material.dart';

class ColorsApp {
  static ColorsApp? _intance;

  ColorsApp._();

  static ColorsApp get i {
    // se for nulo força a instancia dele
    _intance ??= ColorsApp._();
    return _intance!;
  }

  // cor em hexa é 007D21 para o flutter entender ela colocar 0xFF no começo
  Color get primary => const Color(0xFF007D21);
  Color get secondary => const Color(0xFFF88B0C);
}

extension ColorsAppExtensions on BuildContext {
  //criando shortcut para context.colors.primary
  ColorsApp get colors => ColorsApp.i;
}
