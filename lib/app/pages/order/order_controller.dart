import 'package:bloc/bloc.dart';
import 'package:flutter/src/widgets/editable_text.dart';
import 'package:vaquinha_burger_app/app/dto/order_product_dto.dart';
import 'package:vaquinha_burger_app/app/pages/order/order_state.dart';
import 'package:vaquinha_burger_app/app/repositories/order/order_repository.dart';

import '../../dto/order_dto.dart';

class OrderController extends Cubit<OrderState> {
  final OrderRepository _orderRepository;
  OrderController(this._orderRepository) : super(const OrderState.initial());

  void load(List<OrderProductDto> product) async {
    try {
      emit(state.copyWith(status: OrderStatus.loading));

      final paymentTypes = await _orderRepository.getAllPaymentTypes();

      emit(state.copyWith(
        orderProduct: product,
        status: OrderStatus.loaded,
        paymentTypes: paymentTypes,
      ));
    } catch (e, s) {
      print("Erro ao carregar pagina");
      emit(state.copyWith(
          status: OrderStatus.error, errorMessage: "Erro ao carregar pagina"));
    }
  }

  void incrementProduct(int index) {
    final orders = [...state.orderProduct];
    final order = orders[index];
    orders[index] = order.copyWith(amount: order.amount + 1);
    emit(state.copyWith(
      orderProduct: orders,
      status: OrderStatus.updateOrder,
    ));
  }

  void decrementProduct(int index) {
    final orders = [...state.orderProduct];
    final order = orders[index];
    final amount = order.amount;

    if (amount == 1) {
      if (state.status != OrderStatus.confirmRemoveProduct) {
        emit(OrderConfirmDeleteProductState(
          orderProducts: order,
          index: index,
          paymentTypes: state.paymentTypes,
          status: OrderStatus.confirmRemoveProduct,
          orderProduct: state.orderProduct,
          errorMessage: state.errorMessage,
        ));
        return;
      } else {
        orders.removeAt(index);
      }
      if (orders.isEmpty) {
        emit(state.copyWith(status: OrderStatus.emptyBag));
        return;
      }
    } else {
      orders[index] = order.copyWith(amount: order.amount - 1);
    }
    emit(state.copyWith(
      orderProduct: orders,
      status: OrderStatus.updateOrder,
    ));
  }

  void cancelDeleteProcess() {
    emit(state.copyWith(status: OrderStatus.loaded));
  }

  void emptyBag() {
    emit(state.copyWith(status: OrderStatus.emptyBag));
  }

  void saveOrder(
      {required String address,
      required String document,
      required int paymentMethodId}) async {
    emit(state.copyWith(status: OrderStatus.loading));

    await _orderRepository.saveOrder(
      OrderDto(
        product: state.orderProduct,
        address: address,
        document: document,
        paymentMethodId: paymentMethodId,
      ),
    );
    emit(state.copyWith(status: OrderStatus.success));
  }
}
