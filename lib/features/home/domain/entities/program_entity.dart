import 'package:equatable/equatable.dart';

class ProgramEntity extends Equatable {
  const ProgramEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.hasCertificate,
    required this.iconName,
    required this.accentHex,
  });

  final String id;
  final String title;
  final String description;
  final String duration;
  final bool hasCertificate;
  final String iconName;
  final String accentHex;

  @override
  List<Object?> get props => [id];
}