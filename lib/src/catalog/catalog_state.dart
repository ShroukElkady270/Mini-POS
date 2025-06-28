part of 'catalog_bloc.dart';

abstract class CatalogState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CatalogInitial extends CatalogState {}

class CatalogLoaded extends CatalogState {
  final List<Item> items;

  CatalogLoaded(this.items);

  @override
  List<Object?> get props => [items];
}
