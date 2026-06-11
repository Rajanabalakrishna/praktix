import '../../domain/entities/expert_entity.dart';

class ExpertModel extends ExpertEntity {
  const ExpertModel({
    required super.id,
    required super.expertName,
    required super.expertTitle,
    required super.expertImage,
    required super.videoTitle,
    required super.videoThumbnail,
    required super.likeCount,
    required super.isLiked,
    required super.isSaved,
    required super.rating,
    required super.totalStudents,
    required super.category,
  });

  factory ExpertModel.fromDummyJson({
    required Map<String, dynamic> product,
    required Map<String, dynamic> user,
    required int index,
  }) {
    final firstName = (user['firstName'] as String? ?? 'Expert').trim();
    final lastName = (user['lastName'] as String? ?? '').trim();
    final expertImage = user['image'] as String? ??
        'https://i.pravatar.cc/150?img=${(index % 70) + 1}';

    final productTitle = product['title'] as String? ?? 'Course';
    final thumbnail = product['thumbnail'] as String? ?? '';
    final images = (product['images'] as List<dynamic>?)?.cast<String>() ?? [];
    final videoThumbnail = images.isNotEmpty ? images.first : thumbnail;
    final category = product['category'] as String? ?? 'technology';
    final rating = (product['rating'] as num?)?.toDouble() ?? 4.5;
    final stock = (product['stock'] as num?)?.toInt() ?? 50;
    final price = (product['price'] as num?)?.toDouble() ?? 99.0;

    return ExpertModel(
      id: product['id'] as int? ?? index,
      expertName: '$firstName $lastName',
      expertTitle: _categoryToTitle(index),
      expertImage: expertImage,
      videoTitle: _generateVideoTitle(productTitle, index),
      videoThumbnail: videoThumbnail,
      likeCount: (rating * price * 10).toInt(),
      isLiked: false,
      isSaved: false,
      rating: rating,
      totalStudents: stock * 120,
      category: category,
    );
  }

  static const _titles = [
    'Senior Flutter Developer',
    'Full Stack Architect',
    'Mobile App Engineer',
    'UI/UX & Flutter Expert',
    'Backend & Mobile Dev',
    'DevOps & Flutter Lead',
    'AI/ML Mobile Specialist',
    'Cross-Platform Expert',
    'Tech Lead & Mentor',
    'Software Engineer',
  ];

  static const _prefixes = [
    'Master',
    'Complete Guide to',
    'Zero to Hero:',
    'Advanced',
    'Pro Tips for',
    'Building with',
    'Deep Dive into',
    'Practical',
  ];

  static String _categoryToTitle(int index) => _titles[index % _titles.length];

  static String _generateVideoTitle(String name, int index) =>
      '${_prefixes[index % _prefixes.length]} $name';
}