import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validatorless/validatorless.dart';
import 'package:vaquinha_burger_app/app/core/extensions/formatter_extensions.dart';
import 'package:vaquinha_burger_app/app/core/ui/styles/text_styles.dart';
import 'package:vaquinha_burger_app/app/core/ui/widgets/delivery_button.dart';
import 'package:vaquinha_burger_app/app/dto/order_product_dto.dart';
import 'package:vaquinha_burger_app/app/models/payment_type_model.dart';
import 'package:vaquinha_burger_app/app/pages/order/order_controller.dart';
import 'package:vaquinha_burger_app/app/pages/order/order_state.dart';
import 'package:vaquinha_burger_app/app/pages/order/widget/order_field.dart';
import 'package:vaquinha_burger_app/app/pages/order/widget/payments_type_field.dart';
import '../../core/ui/base/base_state/base_state.dart';
import '../../core/ui/widgets/delivery_appbar.dart';
import '../../dto/order_dto.dart';
import './widget/order_product_tile.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends BaseState<OrderPage, OrderController> {
  final formKey = GlobalKey<FormState>();
  final addressEC = TextEditingController();
  final documentEC = TextEditingController();
  int? paymentTypeId;
  final paymentTypeValid = ValueNotifier<bool>(true);

  @override
  void onReady() {
    final product =
        ModalRoute.of(context)!.settings.arguments as List<OrderProductDto>;
    controller.load(product);
  }

  void _showConfirmProductDialog(OrderConfirmDeleteProductState state) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Deseja excluir o produto ${state.orderProducts.produto.name}?",
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
                  controller.cancelDeleteProcess();
                },
                child: Text(
                  'Cancelar',
                  style: context.textStyles.textBold,
                )),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  controller.decrementProduct(state.index);
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
    return BlocListener<OrderController, OrderState>(
      listener: (context, state) {
        state.status.matchAny(
          any: () => hideLoader(),
          loading: () => showLoader(),
          loaded: () => hideLoader(),
          error: () {
            hideLoader();
            showError(state.errorMessage ?? 'Erro nao informado');
          },
          confirmRemoveProduct: () {
            hideLoader();
            if (state is OrderConfirmDeleteProductState) {
              _showConfirmProductDialog(state);
            }
          },
          emptyBag: () {
            showInfo(
                "Sua sacola está vazia por favor selecione um item para continuar a compra");
            Navigator.pop(context, <OrderProductDto>[]);
          },
          success: () {
            hideLoader();
            Navigator.of(context).popAndPushNamed("/ordercompleted",
                result: <OrderProductDto>[]);
          },
        );
      },
      child: WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop(controller.state.orderProduct);
          return false;
        },
        child: Scaffold(
          appBar: DeliveryAppbar(),
          body: Form(
            key: formKey,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Row(
                      children: [
                        Text(
                          "Carrinho",
                          style: context.textStyles.textTitle,
                        ),
                        IconButton(
                            onPressed: () => controller.emptyBag(),
                            icon:
                                Image.asset('assets/images/trashRegular.png')),
                      ],
                    ),
                  ),
                ),
                BlocSelector<OrderController, OrderState,
                    List<OrderProductDto>>(
                  selector: (state) => state.orderProduct,
                  builder: (context, orderProducts) {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        childCount: orderProducts.length,
                        (context, index) {
                          final orderProduct = orderProducts[index];
                          return Column(
                            children: [
                              OrderProductTile(
                                index: index,
                                orderProduct: orderProduct,
                              ),
                              const Divider(),
                            ],
                          );
                        },
                      ),
                    );
                  },
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Total do pedido",
                                style: context.textStyles.textExtraBold
                                    .copyWith(fontSize: 16)),
                            BlocSelector<OrderController, OrderState, double>(
                              selector: (state) => state.totalOrder,
                              builder: (context, totalOrder) {
                                return Text(totalOrder.currencyPTBR,
                                    style: context.textStyles.textExtraBold
                                        .copyWith(fontSize: 20));
                              },
                            )
                          ],
                        ),
                      ),
                      const Divider(
                        color: Colors.grey,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      OrderField(
                        title: "Endereço de entrega",
                        controller: addressEC,
                        validator:
                            Validatorless.required("Endereço Obrigatorio"),
                        hintText: "Digite um endereço",
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      OrderField(
                        title: "Digite o CPF",
                        controller: documentEC,
                        validator: Validatorless.required("CPF Obrigatorio"),
                        hintText: "Digite um endereço",
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      BlocSelector<OrderController, OrderState,
                          List<PaymentTypeModel>>(
                        selector: (state) => state.paymentTypes,
                        builder: (context, paymentTypes) {
                          return ValueListenableBuilder(
                              valueListenable: paymentTypeValid,
                              builder: (_, paymentTypeValidValue, __) {
                                return PaymentsTypeField(
                                  paymentTypes: paymentTypes,
                                  valueChange: (value) {
                                    paymentTypeId = value;
                                  },
                                  valid: paymentTypeValidValue,
                                  valueSelected: paymentTypeId.toString(),
                                );
                              });
                        },
                      ),
                    ],
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Divider(
                        color: Colors.grey,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DeliveryButton(
                          label: "finalizar",
                          onPressed: () {
                            final valid =
                                formKey.currentState?.validate() ?? false;
                            final paymentTypeSelected = paymentTypeId != null;
                            paymentTypeValid.value = paymentTypeSelected;

                            if (valid && paymentTypeSelected) {
                              controller.saveOrder(
                                  address: addressEC.text,
                                  document: documentEC.text,
                                  paymentMethodId: paymentTypeId!);
                            }
                          },
                          width: double.infinity,
                          height: 48,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
