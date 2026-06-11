import 'package:equatable/equatable.dart';

abstract class ApplicationEvent extends Equatable {
  const ApplicationEvent();
  @override
  List<Object?> get props => [];
}

class SubmitApplicationEvent extends ApplicationEvent {
  final String name;
  final String email;
  final String phone;
  final String programTitle;

  const SubmitApplicationEvent({
    required this.name,
    required this.email,
    required this.phone,
    required this.programTitle,
  });

  @override
  List<Object?> get props => [name, email, phone, programTitle];
}