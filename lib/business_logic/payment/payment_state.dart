// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

class PaymentState extends Equatable {
  @override
  List<Object?> get props => [];
  const PaymentState();
}

class PaymentStateLoading extends PaymentState {
  const PaymentStateLoading() : super();
  @override
  List<Object?> get props => [];
}

class PaymentStateLoaded extends PaymentState {
  final String successMessage;
  const PaymentStateLoaded({required this.successMessage}) : super();
  @override
  List<Object?> get props => [];
}

class PaymentStateError extends PaymentState {
  final String errorMessage;
  const PaymentStateError({required this.errorMessage}) : super();
  @override
  List<Object?> get props => [];
}
