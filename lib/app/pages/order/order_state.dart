// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:match/match.dart';

import 'package:vaquinha_burger_app/app/dto/order_product_dto.dart';

import '../../models/payment_type_model.dart';

part "order_state.g.dart";

@match
enum OrderStatus {
  initial,
  loaded,
  loading,
  error,
  updateOrder,
  confirmRemoveProduct,
  emptyBag,
  success,
}

class OrderState extends Equatable {
  final OrderStatus status;
  final List<OrderProductDto> orderProduct;
  final List<PaymentTypeModel> paymentTypes;
  final String? errorMessage;

  const OrderState({
    required this.paymentTypes,
    required this.status,
    required this.orderProduct,
    this.errorMessage,
  });

  const OrderState.initial()
      : status = OrderStatus.initial,
        paymentTypes = const [],
        errorMessage = null,
        orderProduct = const [];

  double get totalOrder =>
      orderProduct.fold(0, (pre, ele) => pre + ele.totalPrice);

  @override
  List<Object?> get props => [status, orderProduct, paymentTypes, errorMessage];

  OrderState copyWith({
    OrderStatus? status,
    List<OrderProductDto>? orderProduct,
    List<PaymentTypeModel>? paymentTypes,
    String? errorMessage,
  }) {
    return OrderState(
      status: status ?? this.status,
      orderProduct: orderProduct ?? this.orderProduct,
      paymentTypes: paymentTypes ?? this.paymentTypes,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class OrderConfirmDeleteProductState extends OrderState {
  final OrderProductDto orderProducts;
  final int index;

  const OrderConfirmDeleteProductState({
    required this.orderProducts,
    required this.index,
    required super.paymentTypes,
    required super.status,
    required super.orderProduct,
    super.errorMessage,
  });
}
