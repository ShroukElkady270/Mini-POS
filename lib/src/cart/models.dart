import 'package:equatable/equatable.dart';
import 'package:izam_task/src/catalog/item.dart';

class CartLine extends Equatable {
  final Item item;
  final int qty;
  final double discount;

  const CartLine({
    required this.item,
    required this.qty,
    required this.discount,
  });

  double get lineNet => item.price * qty * (1 - discount / 100);

  CartLine copyWith({int? qty, double? discount}) => CartLine(
        item: item,
        qty: qty ?? this.qty,
        discount: discount ?? this.discount,
      );

  factory CartLine.fromJson(Map<String, dynamic> json) => CartLine(
        item: Item.fromJson(json['item']),
        qty: json['qty'],
        discount: json['discount'],
      );

  Map<String, dynamic> toJson() => {
        'item': item.toJson(),
        'qty': qty,
        'discount': discount,
      };

  @override
  List<Object?> get props => [item, qty, discount];
}

class Totals extends Equatable {
  final double subtotal;
  final double vat;
  final double grandTotal;

  const Totals({
    required this.subtotal,
    required this.vat,
    required this.grandTotal,
  });

  factory Totals.fromJson(Map<String, dynamic> json) => Totals(
        subtotal: json['subtotal'],
        vat: json['vat'],
        grandTotal: json['grandTotal'],
      );

  Map<String, dynamic> toJson() => {
    'subtotal': subtotal,
    'vat': vat,
    'grandTotal': grandTotal,
  };

  @override
  List<Object?> get props => [subtotal, vat, grandTotal];
}
