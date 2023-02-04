import 'package:vaquinha_burger_app/app/models/payment_type_model.dart';

import '../../dto/order_dto.dart';

abstract class OrderRepository {
  Future<List<PaymentTypeModel>> getAllPaymentTypes();

  Future<void> saveOrder(OrderDto order);
}
