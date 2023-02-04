import 'package:flutter/material.dart';
import 'package:vaquinha_burger_app/app/core/ui/helpers/size_extensions.dart';
import 'package:vaquinha_burger_app/app/core/ui/styles/text_styles.dart';

import '../../../../core/ui/widgets/delivery_button.dart';

class OrderCompletedPage extends StatelessWidget {
  const OrderCompletedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: context.percentHeight(.3),
              ),
              Image.asset("assets/images/logo_rounded.png"),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Pedido realizado com sucesso, em breve voce recabera a confirmação do seu pedido",
                style: context.textStyles.textExtraBold.copyWith(fontSize: 18),
              ),
              const SizedBox(
                height: 40,
              ),
              DeliveryButton(
                width: context.percentWidth(.8),
                label: "FECHAR",
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
