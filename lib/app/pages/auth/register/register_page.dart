import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaquinha_burger_app/app/core/ui/styles/text_styles.dart';
import 'package:vaquinha_burger_app/app/core/ui/widgets/delivery_appbar.dart';
import 'package:vaquinha_burger_app/app/core/ui/widgets/delivery_button.dart';
import 'package:validatorless/validatorless.dart';
import 'package:vaquinha_burger_app/app/pages/auth/register/register_controller.dart';
import 'package:vaquinha_burger_app/app/pages/auth/register/register_state.dart';

import '../../../core/ui/base/base_state/base_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends BaseState<RegisterPage, RegisterController> {
  final _formKey = GlobalKey<FormState>();
  final _nameEC = TextEditingController();
  final _emailEC = TextEditingController();
  final _passwordEC = TextEditingController();

  @override
  void dispose() {
    _emailEC.dispose();
    _nameEC.dispose();
    _passwordEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterController, RegisterState>(
      listener: (context, state) {
        state.status.matchAny(
            any: () => hideLoader(),
            register: () => showLoader(),
            error: () {
              hideLoader();
              showError('Erro ao register usuario');
            },
            success: () {
              hideLoader();
              showSuccess('Cadastro Realizado com sucesso');
              Navigator.pop(context);
            });
      },
      child: Scaffold(
        appBar: DeliveryAppbar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Cadastro",
                    style: context.textStyles.textTitle,
                  ),
                  Text(
                    "Preencha os campos abaixo para criar o cadastro",
                    style: context.textStyles.textMedium.copyWith(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Nome"),
                    validator: Validatorless.required('Nome Obrigatorio'),
                    controller: _nameEC,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "E-mail"),
                    validator: Validatorless.multiple([
                      Validatorless.required('Email Obrigatorio'),
                      Validatorless.email('Email invalido')
                    ]),
                    controller: _emailEC,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Senha"),
                    obscureText: true,
                    validator: Validatorless.multiple([
                      Validatorless.required('Senha Obrigatoria'),
                      Validatorless.min(
                          6, 'Senha deve ter pelo menos 6 caracteres')
                    ]),
                    controller: _passwordEC,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration:
                        const InputDecoration(labelText: "Confirma Senha"),
                    validator: Validatorless.multiple([
                      Validatorless.required("Confirme sua senha"),
                      Validatorless.compare(
                          _passwordEC, "Senhas nao sao iguais")
                    ]),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  DeliveryButton(
                    label: 'Cadastrar',
                    onPressed: () {
                      final valid = _formKey.currentState?.validate() ?? false;
                      if (valid) {
                        controller.register(
                            _nameEC.text, _emailEC.text, _passwordEC.text);
                      }
                    },
                    width: double.infinity,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
