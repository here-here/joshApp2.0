import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class CheckinState extends Equatable {
  const CheckinState();

  @override
  List<Object> get props => [];
}

class CheckinInitial extends CheckinState {}

class CheckinLoading extends CheckinState {}

class CheckinFailure extends CheckinState {
  final String error;

  const CheckinFailure({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'CheckinFailure { error: $error }';
}

class RegisterLoading extends CheckinState {}