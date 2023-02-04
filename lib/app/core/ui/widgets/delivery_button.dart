import 'package:flutter/material.dart';

class DeliveryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final double? width, height;
  const DeliveryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.width,
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    // o elevated button segue o tamanho do seu pai
    // para evitar confitos circular ele em vonta de um Sizedbox
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}
