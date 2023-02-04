// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vaquinha_burger_app/app/core/extensions/formatter_extensions.dart';
import 'package:vaquinha_burger_app/app/core/ui/styles/colors_app.dart';
import 'package:vaquinha_burger_app/app/core/ui/styles/text_styles.dart';
import 'package:vaquinha_burger_app/app/core/ui/widgets/delivery_increment_decrement.dart';

import 'package:vaquinha_burger_app/app/dto/order_product_dto.dart';
import 'package:vaquinha_burger_app/app/pages/order/order_controller.dart';

class OrderProductTile extends StatelessWidget {
  final int index;
  final OrderProductDto orderProduct;

  const OrderProductTile({
    super.key,
    required this.index,
    required this.orderProduct,
  });

  @override
  Widget build(BuildContext context) {
    final produto = orderProduct.produto;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Image.network(
            produto.image,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    produto.name,
                    style:
                        context.textStyles.textRegular.copyWith(fontSize: 16),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        (produto.price * orderProduct.amount).currencyPTBR,
                        style: context.textStyles.textMedium.copyWith(
                            fontSize: 14, color: context.colors.secondary),
                      ),
                      DeliveryIncrementDecrement.compact(
                          amout: orderProduct.amount,
                          incrementPress: () {
                            context
                                .read<OrderController>()
                                .incrementProduct(index);
                          },
                          decrementPress: () {
                            context
                                .read<OrderController>()
                                .decrementProduct(index);
                          })
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
