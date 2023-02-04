// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:vaquinha_burger_app/app/models/product_model.dart';

class OrderProductDto {
  final ProductModel produto;
  final int amount;
  OrderProductDto({
    required this.produto,
    required this.amount,
  });

  double get totalPrice => amount * produto.price;

  OrderProductDto copyWith({
    ProductModel? produto,
    int? amount,
  }) {
    return OrderProductDto(
      produto: produto ?? this.produto,
      amount: amount ?? this.amount,
    );
  }
}
