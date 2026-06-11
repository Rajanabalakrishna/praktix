

import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

class EmailAlreadyInUseFailure extends Failure {
  const EmailAlreadyInUseFailure()
      : super('This email is already registered. Try signing in instead.');
}

class InvalidEmailFailure extends Failure {
  const InvalidEmailFailure() : super('Enter a valid email address.');
}

class WeakPasswordFailure extends Failure {
  const WeakPasswordFailure()
      : super('Password must be at least 8 characters.');
}

class WrongPasswordFailure extends Failure {
  const WrongPasswordFailure()
      : super('Incorrect password. Please try again.');
}

class UserNotFoundFailure extends Failure {
  const UserNotFoundFailure()
      : super('No account found with this email address.');
}

class TooManyRequestsFailure extends Failure {
  const TooManyRequestsFailure()
      : super('Too many attempts. Please wait a moment and try again.');
}

class NetworkFailure extends Failure {
  const NetworkFailure()
      : super('No internet connection. Check your network and retry.');
}

class UnknownFailure extends Failure {
  const UnknownFailure([String? msg])
      : super(msg ?? 'Something went wrong. Please try again.');
}