// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

class NotificationsState extends Equatable {
  @override
  List<Object?> get props => [];
  const NotificationsState();
}

class NotificationsStateLoading extends NotificationsState {
  const NotificationsStateLoading() : super();
  @override
  List<Object?> get props => [];
}

class NotificationsStateLoaded extends NotificationsState {
  final List? notifications;
  const NotificationsStateLoaded({required this.notifications}) : super();
  @override
  List<Object?> get props => [];
}

class NotificationsStateError extends NotificationsState {
  final String errorMessage;
  const NotificationsStateError({required this.errorMessage}) : super();
  @override
  List<Object?> get props => [];
}
