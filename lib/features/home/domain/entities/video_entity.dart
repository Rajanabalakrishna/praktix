import 'package:equatable/equatable.dart';

class VideoEntity extends Equatable {
  const VideoEntity({
    required this.id,
    required this.title,
    required this.expertName,
    required this.expertImageUrl,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.duration,
    required this.isPremium,
    required this.likes,
    required this.topic,
  });

  final String id;
  final String title;
  final String expertName;
  final String expertImageUrl;
  final String thumbnailUrl;
  final String videoUrl;
  final String duration;
  final bool isPremium;
  final int likes;
  final String topic;

  @override
  List<Object?> get props => [id];
}