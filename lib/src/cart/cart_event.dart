part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddItem extends CartEvent {
  final Item item;
  AddItem(this.item);
  @override
  List<Object?> get props => [item];
}

class RemoveItem extends CartEvent {
  final Item item;
  RemoveItem(this.item);
  @override
  List<Object?> get props => [item];
}

class ChangeQty extends CartEvent {
  final Item item;
  final int qty;
  ChangeQty(this.item, this.qty);
  @override
  List<Object?> get props => [item, qty];
}

class ChangeDiscount extends CartEvent {
  final Item item;
  final double discount;
  ChangeDiscount(this.item, this.discount);
  @override
  List<Object?> get props => [item, discount];
}

class ClearCart extends CartEvent {}
class UndoCartAction extends CartEvent {}
class RedoCartAction extends CartEvent {}
