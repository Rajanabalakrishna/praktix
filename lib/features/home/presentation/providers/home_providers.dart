import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:praktix/features/home/data/mock/home_mock_data.dart';
import 'package:praktix/features/home/domain/entities/expert_entity.dart';
import 'package:praktix/features/home/domain/entities/job_entity.dart';
import 'package:praktix/features/home/domain/entities/program_entity.dart';
import 'package:praktix/features/home/domain/entities/video_entity.dart';
import 'package:praktix/features/home/domain/entities/workshop_entity.dart';

final expertsProvider = Provider<List<ExpertEntity>>((_) => mockExperts);
final programsProvider = Provider<List<ProgramEntity>>((_) => mockPrograms);
final videosProvider = Provider<List<VideoEntity>>((_) => mockVideos);
final workshopsProvider = Provider<List<WorkshopEntity>>((_) => mockWorkshops);
final jobsProvider = Provider<List<JobEntity>>((_) => mockJobs);

// tracks which video cards are actively playing
final playingVideoProvider =
StateProvider<String?>((ref) => null);

// tracks locally unlocked premium videos
final unlockedVideosProvider =
StateProvider<Set<String>>((ref) => {});