import 'package:equatable/equatable.dart';

abstract class ApplicationState extends Equatable {
  const ApplicationState();
  @override
  List<Object?> get props => [];
}

class ApplicationInitial extends ApplicationState {}

class ApplicationSubmitting extends ApplicationState {}

class ApplicationSuccess extends ApplicationState {
  final String message;
  const ApplicationSuccess({required this.message});
  @override
  List<Object?> get props => [message];
}

class ApplicationFailure extends ApplicationState {
  final String error;
  const ApplicationFailure({required this.error});
  @override
  List<Object?> get props => [error];
}