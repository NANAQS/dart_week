import 'package:flutter/material.dart';
import 'package:vaquinha_burger_app/app/core/ui/styles/colors_app.dart';
import 'package:vaquinha_burger_app/app/core/ui/styles/text_styles.dart';

class DeliveryIncrementDecrement extends StatelessWidget {
  final bool _compact;
  final int amout;
  final VoidCallback incrementPress;
  final VoidCallback decrementPress;

  const DeliveryIncrementDecrement({
    super.key,
    required this.amout,
    required this.incrementPress,
    required this.decrementPress,
  }) : _compact = false;

  const DeliveryIncrementDecrement.compact({
    super.key,
    required this.amout,
    required this.incrementPress,
    required this.decrementPress,
  }) : _compact = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: _compact ? const EdgeInsets.all(5) : null,
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(7)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: decrementPress,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                '-',
                style: context.textStyles.textMedium
                    .copyWith(fontSize: _compact ? 10 : 22, color: Colors.grey),
              ),
            ),
          ),
          Text(
            amout.toString(),
            style: context.textStyles.textRegular.copyWith(
              fontSize: _compact ? 13 : 17,
              color: context.colors.secondary,
            ),
          ),
          InkWell(
            onTap: incrementPress,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                '+',
                style: context.textStyles.textMedium.copyWith(
                    fontSize: _compact ? 10 : 22,
                    color: context.colors.secondary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
