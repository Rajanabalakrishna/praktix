

import 'package:equatable/equatable.dart';

enum UserRole { learner, professional, expert }

/// Immutable domain entity — no Firebase types leak into domain.
class UserEntity extends Equatable {
  const UserEntity({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
  });

  final String uid;
  final String name;
  final String email;
  final UserRole role;

  @override
  List<Object?> get props => [uid, name, email, role];
}