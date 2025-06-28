import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:equatable/equatable.dart';
import '../catalog/item.dart';
import 'models.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends HydratedBloc<CartEvent, CartState> {
  final List<CartState> _undoStack = [];
  final List<CartState> _redoStack = [];

  CartBloc() : super(CartState.empty()) {
    on<AddItem>(_onAddItem);
    on<RemoveItem>(_onRemoveItem);
    on<ChangeQty>(_onChangeQty);
    on<ChangeDiscount>(_onChangeDiscount);
    on<ClearCart>(_onClearCart);
    on<UndoCartAction>(_onUndo);
    on<RedoCartAction>(_onRedo);
  }

  void _recalculate(Emitter<CartState> emit, List<CartLine> lines) {
    final subtotal = lines.fold(0.0, (s, l) => s + l.lineNet);
    final vat = double.parse((subtotal * 0.15).toStringAsFixed(2));
    final grandTotal = double.parse((subtotal + vat).toStringAsFixed(2));
    final newState = CartState(lines, Totals(subtotal: subtotal, vat: vat, grandTotal: grandTotal));
    _undoStack.add(state);
    _redoStack.clear();
    emit(newState);
  }

  void _onAddItem(AddItem e, Emitter<CartState> emit) {
    final lines = List<CartLine>.from(state.lines);
    final i = lines.indexWhere((l) => l.item.id == e.item.id);
    if (i >= 0) {
      lines[i] = lines[i].copyWith(qty: lines[i].qty + 1);
    } else {
      lines.add(CartLine(item: e.item, qty: 1, discount: 0));
    }
    _recalculate(emit, lines);
  }

  void _onRemoveItem(RemoveItem e, Emitter<CartState> emit) {
    final lines = state.lines.where((l) => l.item.id != e.item.id).toList();
    _recalculate(emit, lines);
  }

  void _onChangeQty(ChangeQty e, Emitter<CartState> emit) {
    final lines = state.lines.map((l) => l.item.id == e.item.id ? l.copyWith(qty: e.qty) : l).toList();
    _recalculate(emit, lines);
  }

  void _onChangeDiscount(ChangeDiscount e, Emitter<CartState> emit) {
    final lines = state.lines.map((l) => l.item.id == e.item.id ? l.copyWith(discount: e.discount) : l).toList();
    _recalculate(emit, lines);
  }

  void _onClearCart(ClearCart e, Emitter<CartState> emit) {
    _undoStack.add(state);
    _redoStack.clear();
    emit(CartState.empty());
  }

  void _onUndo(UndoCartAction e, Emitter<CartState> emit) {
    if (_undoStack.isNotEmpty) {
      final prev = _undoStack.removeLast();
      _redoStack.add(state);
      emit(prev);
    }
  }

  void _onRedo(RedoCartAction e, Emitter<CartState> emit) {
    if (_redoStack.isNotEmpty) {
      final next = _redoStack.removeLast();
      _undoStack.add(state);
      emit(next);
    }
  }

  @override
  CartState? fromJson(Map<String, dynamic> json) => CartState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(CartState state) => state.toJson();
}
