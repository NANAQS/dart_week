import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaquinha_burger_app/app/core/exceptions/unauthorized_exception.dart';
import 'package:vaquinha_burger_app/app/pages/auth/login/login_state.dart';
import 'package:vaquinha_burger_app/app/repositories/auth/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends Cubit<LoginState> {
  final AuthRepository _authRepository;

  LoginController(this._authRepository) : super(const LoginState.initial());

  Future<void> login(String email, String password) async {
    try {
      emit(state.copyWith(status: LoginStatus.login));
      final authModel = await _authRepository.login(email, password);
      final sp = await SharedPreferences.getInstance();
      sp.setString('accessToken', authModel.accesstoken);
      sp.setString('refreshToken', authModel.refreshToken);
      emit(state.copyWith(status: LoginStatus.success));
    } on UnauthorizedException catch (e) {
      emit(state.copyWith(
          status: LoginStatus.loginError,
          errorMessage: 'Login ou senha invalido'));
    } catch (e, s) {
      emit(state.copyWith(
          status: LoginStatus.error, errorMessage: 'Login ao realizar login'));
      print('error: $e, stack: $s');
    }
  }
}
