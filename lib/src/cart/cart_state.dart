part of 'cart_bloc.dart';

class CartState extends Equatable {
  final List<CartLine> lines;
  final Totals totals;

  const CartState(this.lines, this.totals);

  factory CartState.empty() => const CartState([], Totals(subtotal: 0, vat: 0, grandTotal: 0));

  factory CartState.fromJson(Map<String, dynamic> json) => CartState(
      (json['lines'] as List).map((e) => CartLine.fromJson(e)).toList(),
      Totals.fromJson(json['totals'])
  );

  Map<String, dynamic> toJson() => {
    'lines': lines.map((e) => e.toJson()).toList(),
    'totals': totals.toJson(),
  };

  @override
  List<Object?> get props => [lines, totals];
}
