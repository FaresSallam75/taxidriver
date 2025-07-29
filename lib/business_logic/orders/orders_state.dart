import 'package:equatable/equatable.dart';

class OrdersState extends Equatable {
  const OrdersState();
  @override
  List<Object?> get props => [];
}

class OrdersStateLoading extends OrdersState {
  const OrdersStateLoading();
  @override
  List<Object?> get props => [];
}

// ignore: must_be_immutable
class OrdersStateLoaded extends OrdersState {
  List listOrders = [];
  OrdersStateLoaded({required this.listOrders});

  @override
  List<Object?> get props => [listOrders];
}

class OrdersStateError extends OrdersState {
  final String errorMessage;
  const OrdersStateError({required this.errorMessage});
  @override
  List<Object?> get props => [errorMessage];
}

class OrderReceivedState extends OrdersState {

  const OrderReceivedState();
  @override
  List<Object?> get props => [];
}
