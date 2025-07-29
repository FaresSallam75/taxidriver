import 'package:equatable/equatable.dart';

class DriverState extends Equatable {
  const DriverState();
  @override
  List<Object?> get props => [];
}

class DriverStateLoading extends DriverState {
  const DriverStateLoading();
  @override
  List<Object?> get props => [];
}

// ignore: must_be_immutable
class DriverStateLoaded extends DriverState {
  List nearbyDrivers = [];
  List cars = [];
  DriverStateLoaded({required this.nearbyDrivers, required this.cars});

  @override
  List<Object?> get props => [nearbyDrivers, cars];
}

class DriverStateError extends DriverState {
  final String errorMessage;
  const DriverStateError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
