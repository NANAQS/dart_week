// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:vaquinha_burger_app/app/core/rest_client/custom_dio.dart';
import 'package:vaquinha_burger_app/app/models/product_model.dart';

import '../../core/exceptions/repository_exception.dart';
import './products_repository.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final CustomDio dio;

  ProductsRepositoryImpl({
    required this.dio,
  });

  @override
  Future<List<ProductModel>> findAllProducts() async {
    try {
      final result = await dio.unauth().get('/products');
      final resultFi = result.data;

      return (resultFi as List)
          .map<ProductModel>((p) => ProductModel.fromMap(p))
          .toList();
    } on DioError catch (e, s) {
      print('erro: ' + e.toString() + ' stack: ' + s.toString());
      throw RepositoryException(message: 'erro ao buscar produto');
    }
  }
}
