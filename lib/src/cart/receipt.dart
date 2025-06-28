import 'cart_bloc.dart';

class ReceiptLine {
  final String name;
  final int qty;
  final double price;
  final double discount;
  final double total;

  ReceiptLine({
    required this.name,
    required this.qty,
    required this.price,
    required this.discount,
    required this.total,
  });
}

class Receipt {
  final DateTime dateTime;
  final List<ReceiptLine> lines;
  final double subtotal;
  final double vat;
  final double grandTotal;

  Receipt({
    required this.dateTime,
    required this.lines,
    required this.subtotal,
    required this.vat,
    required this.grandTotal,
  });
}

Receipt buildReceipt(CartState state, DateTime now) {
  return Receipt(
    dateTime: now,
    lines: state.lines
        .map((l) => ReceiptLine(
      name: l.item.name,
      qty: l.qty,
      price: l.item.price,
      discount: l.discount,
      total: l.lineNet,
    ))
        .toList(),
    subtotal: state.totals.subtotal,
    vat: state.totals.vat,
    grandTotal: state.totals.grandTotal,
  );
}
