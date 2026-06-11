import 'package:equatable/equatable.dart';

class WorkshopEntity extends Equatable {
  const WorkshopEntity({
    required this.id,
    required this.title,
    required this.host,
    required this.date,
    required this.time,
    required this.isFree,
    required this.spotsLeft,
    required this.imageUrl,
  });

  final String id;
  final String title;
  final String host;
  final String date;
  final String time;
  final bool isFree;
  final int spotsLeft;
  final String imageUrl;

  @override
  List<Object?> get props => [id];
}