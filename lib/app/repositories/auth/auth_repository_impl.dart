// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:vaquinha_burger_app/app/core/exceptions/repository_exception.dart';
import 'package:vaquinha_burger_app/app/core/exceptions/unauthorized_exception.dart';
import 'package:vaquinha_burger_app/app/core/rest_client/custom_dio.dart';
import 'package:vaquinha_burger_app/app/models/auth_model.dart';

import './auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final CustomDio dio;

  AuthRepositoryImpl({
    required this.dio,
  });

  @override
  Future<AuthModel> login(String email, String password) async {
    try {
      final result = await dio.unauth().post('/auth', data: {
        'email': email,
        "password": password,
      });

      return AuthModel.fromMap(result.data);
    } on DioError catch (e, s) {
      if (e.response!.statusCode == 403) {
        print("Permissao negada");
        throw UnauthorizedException();
      }

      print("error: $e, stack: $s");
      throw RepositoryException(message: 'Erro ao realizar login');
    }
  }

  @override
  Future<void> register(String name, String email, String password) async {
    try {
      await dio.unauth().post('/users', data: {
        'name': name,
        'email': email,
        'password': password,
      });
    } on DioError catch (e, s) {
      print("erro: $e, stack: $s");
      throw RepositoryException(message: 'Erro ao registrar usuario');
    }
  }
}
