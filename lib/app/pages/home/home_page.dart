import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaquinha_burger_app/app/core/ui/base/base_state/base_state.dart';
import 'package:vaquinha_burger_app/app/pages/home/home_controller.dart';
import 'package:vaquinha_burger_app/app/pages/home/home_state.dart';
import '../../core/ui/widgets/delivery_appbar.dart';
import './widgets/delivery_product_tile.dart';
import './widgets/shopping_bag_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends BaseState<HomePage, HomeController> {
  @override
  void onReady() {
    super.onReady();
    controller.loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DeliveryAppbar(),
      body: BlocConsumer<HomeController, RegisterState>(
        listener: (context, state) {
          state.status.matchAny(
            any: () => hideLoader(),
            loading: () => showLoader(),
            error: () {
              hideLoader();
              showError(state.errorMessage ?? 'erro nao informado');
            },
          );
        },
        buildWhen: (previous, current) => current.status.matchAny(
          any: () => false,
          initial: () => true,
          loaded: () => true,
        ),
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: state.products.length,
                  itemBuilder: (context, index) {
                    final products = state.products[index];
                    final orders = state.shoppingBag.where(
                      (orders) => orders.produto == products,
                    );
                    return DeliveryProductTile(
                      product: products,
                      orderProduct: orders.isNotEmpty ? orders.first : null,
                    );
                  },
                ),
              ),
              Visibility(
                visible: state.shoppingBag.isNotEmpty,
                child: ShoppingBagWidget(
                  bag: state.shoppingBag,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
