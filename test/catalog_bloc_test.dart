import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:izam_task/src/catalog/catalog_bloc.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const testCatalogJson = '''
  [
    { "id": "p01", "name": "Coffee", "price": 2.50 },
    { "id": "p02", "name": "Bagel", "price": 3.20 }
  ]
  ''';

  setUp(() {
    ServicesBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
      'flutter/assets',
          (ByteData? message) async {
        final assetKey = utf8.decode(message!.buffer.asUint8List());
        if (assetKey == 'assets/catalog.json') {
          return ByteData.view(utf8.encode(testCatalogJson).buffer);
        }
        return null;
      },
    );
  });

  group('CatalogBloc', () {
    blocTest<CatalogBloc, CatalogState>(
      'emits CatalogLoaded on LoadCatalog',
      build: () => CatalogBloc(),
      act: (bloc) => bloc.add(LoadCatalog()),
      wait: const Duration(milliseconds: 100),
      expect: () => [isA<CatalogLoaded>()],
    );
  });
}
