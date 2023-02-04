import 'package:bloc/bloc.dart';
import 'package:vaquinha_burger_app/app/pages/home/home_state.dart';
import 'package:vaquinha_burger_app/app/repositories/products/products_repository.dart';
import '../../dto/order_product_dto.dart';

class HomeController extends Cubit<RegisterState> {
  final ProductsRepository _productsRepository;
  HomeController(this._productsRepository)
      : super(const RegisterState.initial());

  Future<void> loadProducts() async {
    emit(state.copyWith(status: HomeStateStatus.loading));
    try {
      final products = await _productsRepository.findAllProducts();
      emit(state.copyWith(status: HomeStateStatus.loaded, products: products));
    } catch (e, s) {
      print("error: $e \n stack: $s");
      emit(
        state.copyWith(
          status: HomeStateStatus.error,
          errorMessage: "Erro ao buscar produtos",
        ),
      );
    }
  }

  void addOrUpdateBag(OrderProductDto orderProduct) {
    final shoppingBag = [...state.shoppingBag];
    final orderIndex = shoppingBag
        .indexWhere((orderP) => orderP.produto == orderProduct.produto);

    if (orderIndex > -1) {
      if (orderProduct.amount == 0) {
        shoppingBag.removeAt(orderIndex);
      } else {
        shoppingBag[orderIndex] = orderProduct;
      }
    } else {
      shoppingBag.add(orderProduct);
    }

    emit(state.copyWith(shoppingBag: shoppingBag));
  }

  void updateBag(List<OrderProductDto> updateBag) {
    emit(state.copyWith(shoppingBag: updateBag));
  }
}
