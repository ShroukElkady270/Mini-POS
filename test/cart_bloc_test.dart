import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:izam_task/src/catalog/item.dart';
import 'package:izam_task/src/cart/cart_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

const coffee = Item(id: 'p01', name: 'Coffee', price: 2.5);
const bagel = Item(id: 'p02', name: 'Bagel', price: 3.2);

class TestPathProviderPlatform extends PathProviderPlatform {
  @override
  Future<String?> getApplicationDocumentsPath() async {
    final dir = Directory.systemTemp.createTempSync();
    return dir.path;
  }
}

void main() {
  setUpAll(() async {
    PathProviderPlatform.instance = TestPathProviderPlatform();

    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: await Directory.systemTemp.createTemp('hydrated_test'),
    );
  });

  setUp(() async {
    await HydratedBloc.storage.clear();
  });

  group('CartBloc', () {
    blocTest<CartBloc, CartState>(
      'adds two items → correct totals',
      build: () => CartBloc(),
      act: (bloc) => bloc
        ..add(AddItem(coffee))
        ..add(AddItem(bagel)),
      wait: const Duration(milliseconds: 50),
      verify: (bloc) {
        final totals = bloc.state.totals;
        expect(bloc.state.lines.length, 2);
        expect(totals.subtotal, closeTo(5.7, 0.01));
        expect(totals.vat, closeTo(0.855, 0.01));
        expect(totals.grandTotal, closeTo(6.56, 0.01));
      },
    );

    blocTest<CartBloc, CartState>(
      'changing qty and discount updates totals',
      build: () => CartBloc(),
      act: (bloc) async {
        bloc.add(AddItem(coffee));
        await Future.delayed(Duration.zero);
        bloc.add(ChangeQty(coffee, 2));
        await Future.delayed(Duration.zero);
        bloc.add(ChangeDiscount(coffee, 20));
      },
      wait: const Duration(milliseconds: 50),
      verify: (bloc) {
        final line = bloc.state.lines.first;
        final totals = bloc.state.totals;

        expect(line.qty, 2);
        expect(line.discount, 20);
        expect(totals.subtotal, closeTo(4.0, 0.01));
        expect(totals.vat, closeTo(0.6, 0.01));
        expect(totals.grandTotal, closeTo(4.6, 0.01));
      },
    );

    blocTest<CartBloc, CartState>(
      'clearing cart resets state',
      build: () => CartBloc(),
      act: (bloc) => bloc
        ..add(AddItem(coffee))
        ..add(ClearCart()),
      wait: const Duration(milliseconds: 50),
      verify: (bloc) {
        expect(bloc.state.lines.isEmpty, true);
        expect(bloc.state.totals.subtotal, 0);
        expect(bloc.state.totals.vat, 0);
        expect(bloc.state.totals.grandTotal, 0);
      },
    );

    blocTest<CartBloc, CartState>(
      'undo and redo work as expected',
      build: () => CartBloc(),
      act: (bloc) async {
        bloc.add(AddItem(coffee));
        await Future.delayed(Duration.zero);
        bloc.add(UndoCartAction());
        await Future.delayed(Duration.zero);
        bloc.add(RedoCartAction());
      },
      wait: const Duration(milliseconds: 50),
      verify: (bloc) {
        final state = bloc.state;
        expect(state.lines.length, 1);
        expect(state.lines.first.item.name, 'Coffee');
      },
    );
  });
}
