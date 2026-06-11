enum ProgramCategory { ai, cybersecurity, mobile, leadership, data }
enum ProgramType { masterclass, course, internship, bootcamp }

class ProgramEntity {
  final String id;
  final String title;
  final String description;
  final String instructorName;
  final String instructorTitle;
  final String thumbnailUrl;
  final ProgramType type;
  final ProgramCategory category;
  final String duration;
  final bool hasCertificate;
  final bool isPaid;
  final double? rating;
  final int? studentsEnrolled;
  final bool isFeatured;

  const ProgramEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.instructorName,
    required this.instructorTitle,
    required this.thumbnailUrl,
    required this.type,
    required this.category,
    required this.duration,
    this.hasCertificate = false,
    this.isPaid = false,
    this.rating,
    this.studentsEnrolled,
    this.isFeatured = false,
  });
}