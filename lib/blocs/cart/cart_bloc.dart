import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/cart_item_model.dart';

// Events
abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class AddToCart extends CartEvent {
  final CartItem item;
  const AddToCart(this.item);

  @override
  List<Object> get props => [item];
}

class RemoveFromCart extends CartEvent {
  final String productId;
  const RemoveFromCart(this.productId);

  @override
  List<Object> get props => [productId];
}

class UpdateQuantity extends CartEvent {
  final String productId;
  final int quantity;
  const UpdateQuantity(this.productId, this.quantity);

  @override
  List<Object> get props => [productId, quantity];
}

class ClearCart extends CartEvent {}

// State
class CartState extends Equatable {
  final List<CartItem> items;

  const CartState({this.items = const []});

  double get totalAmount => items.fold(0, (sum, item) => sum + item.total);

  @override
  List<Object> get props => [items];
}

// Bloc
class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateQuantity>(_onUpdateQuantity);
    on<ClearCart>(_onClearCart);
  }

  void _onAddToCart(AddToCart event, Emitter<CartState> emit) {
    // Check if shop is different? For now, assume mixed bags are allowed or handle in UI
    // Ideally, clear cart if adding from different shop or warn user.
    // Let's implement: unique shop constraint?
    // Or just simple add for now.

    // Check if item exists
    final index = state.items.indexWhere(
      (i) => i.productId == event.item.productId,
    );
    if (index >= 0) {
      final updatedItems = List<CartItem>.from(state.items);
      updatedItems[index] = updatedItems[index].copyWith(
        quantity: updatedItems[index].quantity + event.item.quantity,
      );
      emit(CartState(items: updatedItems));
    } else {
      emit(CartState(items: [...state.items, event.item]));
    }
  }

  void _onRemoveFromCart(RemoveFromCart event, Emitter<CartState> emit) {
    final updatedItems = state.items
        .where((i) => i.productId != event.productId)
        .toList();
    emit(CartState(items: updatedItems));
  }

  void _onUpdateQuantity(UpdateQuantity event, Emitter<CartState> emit) {
    final updatedItems = state.items.map((item) {
      if (item.productId == event.productId) {
        return item.copyWith(quantity: event.quantity);
      }
      return item;
    }).toList();
    emit(CartState(items: updatedItems));
  }

  void _onClearCart(ClearCart event, Emitter<CartState> emit) {
    emit(const CartState(items: []));
  }
}
