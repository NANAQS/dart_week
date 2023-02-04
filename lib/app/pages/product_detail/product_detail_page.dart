import 'package:flutter/material.dart';
import 'package:vaquinha_burger_app/app/core/extensions/formatter_extensions.dart';
import 'package:vaquinha_burger_app/app/core/ui/helpers/size_extensions.dart';
import 'package:vaquinha_burger_app/app/core/ui/styles/text_styles.dart';
import 'package:vaquinha_burger_app/app/core/ui/widgets/delivery_appbar.dart';
import 'package:vaquinha_burger_app/app/core/ui/widgets/delivery_increment_decrement.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:vaquinha_burger_app/app/models/product_model.dart';

import '../../core/ui/base/base_state/base_state.dart';
import './product_detail_controller.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../dto/order_product_dto.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductModel product;
  final OrderProductDto? order;

  const ProductDetailPage({
    super.key,
    required this.product,
    this.order,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState
    extends BaseState<ProductDetailPage, ProductDetailController> {
  @override
  void initState() {
    super.initState();
    final amount = widget.order?.amount ?? 1;
    controller.initial(amount, widget.order != null);
  }

  void _showConfirmDelete(int amnt) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Deseja excluir o produto?",
            style: context.textStyles.textExtraBold.copyWith(fontSize: 25),
          ),
          content: Text(
            "Você podera perder a oportunidade de perder um lanche delicioso!!!",
            style: context.textStyles.textMedium,
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancelar',
                  style: context.textStyles.textBold,
                )),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.of(context).pop(
                      OrderProductDto(produto: widget.product, amount: amnt));
                },
                child: Text(
                  'Confirmar',
                  style:
                      context.textStyles.textBold.copyWith(color: Colors.red),
                )),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DeliveryAppbar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: context.screenWidth,
            height: context.percentHeight(.4),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.product.image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              widget.product.name,
              style: context.textStyles.textExtraBold.copyWith(fontSize: 22),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SingleChildScrollView(
                  child: Text(widget.product.description)),
            ),
          ),
          const Divider(),
          Row(
            children: [
              Container(
                width: context.percentWidth(.5),
                height: 68,
                padding: const EdgeInsets.all(8),
                child: BlocBuilder<ProductDetailController, int>(
                  builder: (context, amount) {
                    return DeliveryIncrementDecrement(
                      amout: amount,
                      decrementPress: () {
                        controller.decrement();
                      },
                      incrementPress: () {
                        controller.increment();
                      },
                    );
                  },
                ),
              ),
              Container(
                width: context.percentWidth(.5),
                height: 68,
                padding: const EdgeInsets.all(8),
                child: BlocBuilder<ProductDetailController, int>(
                  builder: (context, amount) {
                    return ElevatedButton(
                      style: amount == 0
                          ? ElevatedButton.styleFrom(
                              backgroundColor: Colors.red)
                          : null,
                      onPressed: () {
                        if (amount == 0) {
                          _showConfirmDelete(amount);
                        } else {
                          Navigator.of(context).pop(OrderProductDto(
                              produto: widget.product, amount: amount));
                        }
                      },
                      child: Visibility(
                        visible: amount > 0,
                        replacement: Text(
                          'Excluir Produto',
                          style: context.textStyles.textExtraBold,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Adicionar',
                              style: context.textStyles.textExtraBold
                                  .copyWith(fontSize: 13),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: AutoSizeText(
                                (widget.product.price * amount).currencyPTBR,
                                maxFontSize: 13,
                                minFontSize: 5,
                                maxLines: 1,
                                style: context.textStyles.textExtraBold,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
