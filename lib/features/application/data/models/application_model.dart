import '../../domain/entities/application_entity.dart';

class ApplicationModel extends ApplicationEntity {
  const ApplicationModel({
    required super.name,
    required super.email,
    required super.phone,
    required super.programTitle,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'phone': phone,
    'programTitle': programTitle,
  };

  factory ApplicationModel.fromEntity(ApplicationEntity entity) =>
      ApplicationModel(
        name: entity.name,
        email: entity.email,
        phone: entity.phone,
        programTitle: entity.programTitle,
      );
}