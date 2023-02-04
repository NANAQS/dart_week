// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'order_product_dto.dart';

class OrderDto {
  List<OrderProductDto> product;
  String address;
  String document;
  int paymentMethodId;

  OrderDto({
    required this.product,
    required this.address,
    required this.document,
    required this.paymentMethodId,
  });
}
