import 'package:equatable/equatable.dart';

class ExpertEntity extends Equatable {
  final int id;
  final String expertName;
  final String expertTitle;
  final String expertImage;
  final String videoTitle;
  final String videoThumbnail;
  final int likeCount;
  final bool isLiked;
  final bool isSaved;
  final double rating;
  final int totalStudents;
  final String category;
  final bool isPremium;

  const ExpertEntity({
    required this.id,
    required this.expertName,
    required this.expertTitle,
    required this.expertImage,
    required this.videoTitle,
    required this.videoThumbnail,
    required this.likeCount,
    required this.isLiked,
    required this.isSaved,
    required this.rating,
    required this.totalStudents,
    required this.category,
    this.isPremium=false
  });

  ExpertEntity copyWith({
    bool? isLiked,
    bool? isSaved,
    int? likeCount,
    bool? isPremium,
  }) {
    return ExpertEntity(
      id: id,
      expertName: expertName,
      expertTitle: expertTitle,
      expertImage: expertImage,
      videoTitle: videoTitle,
      videoThumbnail: videoThumbnail,
      likeCount: likeCount ?? this.likeCount,
      isLiked: isLiked ?? this.isLiked,
      isSaved: isSaved ?? this.isSaved,
      rating: rating,
      isPremium: isPremium ?? this.isPremium,
      totalStudents: totalStudents,
      category: category,
    );
  }

  @override
  List<Object?> get props => [
    id, expertName, expertTitle, expertImage,
    videoTitle, videoThumbnail, likeCount,
    isLiked, isSaved, rating, totalStudents, category,isPremium
  ];
}