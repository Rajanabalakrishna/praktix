import 'package:equatable/equatable.dart';

class ExpertEntity extends Equatable {
  const ExpertEntity({
    required this.id,
    required this.name,
    required this.title,
    required this.imageUrl,
    required this.tags,
    required this.isVerified,
    required this.rating,
    required this.sessionRate,
  });

  final String id;
  final String name;
  final String title;
  final String imageUrl;
  final List<String> tags;
  final bool isVerified;
  final double rating;
  final String sessionRate;

  @override
  List<Object?> get props => [id];
}