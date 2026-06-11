import 'package:equatable/equatable.dart';

class JobEntity extends Equatable {
  const JobEntity({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.type,
    required this.salary,
    required this.logoUrl,
    required this.isRemote,
    required this.postedAgo,
  });

  final String id;
  final String title;
  final String company;
  final String location;
  final String type;
  final String salary;
  final String logoUrl;
  final bool isRemote;
  final String postedAgo;

  @override
  List<Object?> get props => [id];
}