// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:vaquinha_burger_app/app/core/exceptions/repository_exception.dart';
import 'package:vaquinha_burger_app/app/dto/order_dto.dart';
import 'package:vaquinha_burger_app/app/models/payment_type_model.dart';

import '../../core/rest_client/custom_dio.dart';
import './order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final CustomDio dio;

  OrderRepositoryImpl({
    required this.dio,
  });
  @override
  Future<List<PaymentTypeModel>> getAllPaymentTypes() async {
    try {
      final result = await dio.auth().get("/payment-types");

      return result.data
          .map<PaymentTypeModel>((p) => PaymentTypeModel.fromMap(p))
          .toList();
    } on DioError catch (e, s) {
      print("Erro ao buscar formas de pagamento");
      print("erro: $e, stack: $s");
      throw RepositoryException(message: "Erro ao buscar formas de pagamento");
    }
  }

  @override
  Future<void> saveOrder(OrderDto order) async {
    try {
      await dio.auth().post("/orders", data: {
        "products": order.product
            .map((e) => {
                  'id': e.produto.id,
                  'amount': e.amount,
                  'totat_price': e.totalPrice,
                })
            .toList(),
        'user_id': '#userAuthRef',
        'address': order.address,
        'CPF': order.document,
        'payment_method_id': order.paymentMethodId,
      });
    } on DioError catch (e, s) {
      print("erro ao registrar pedido \n error: $e \n stack:  $s");
      throw RepositoryException(message: "erro ao registrar pedido");
    }
  }
}
