import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:praktix/core/constants/app_constants.dart';
import 'package:praktix/features/feed/domain/entities/expert_entity.dart';
import 'package:praktix/features/feed/domain/usecases/get_experts_usecase.dart';



part 'expert_feed_event.dart';
part 'expert_feed_state.dart';

class ExpertFeedBloc extends Bloc<ExpertFeedEvent, ExpertFeedState> {
  final GetExpertsUseCase getExpertsUseCase;
  int _currentSkip = 0;

  ExpertFeedBloc({required this.getExpertsUseCase})
      : super(const ExpertFeedInitial()) {
    on<LoadExpertsEvent>(_onLoad);
    on<LoadMoreExpertsEvent>(_onLoadMore);
    on<RefreshExpertsEvent>(_onRefresh);
    on<ToggleLikeEvent>(_onToggleLike);
    on<ToggleSaveEvent>(_onToggleSave);
  }

  Future<void> _onLoad(
      LoadExpertsEvent event,
      Emitter<ExpertFeedState> emit,
      ) async {
    emit(const ExpertFeedLoading());
    _currentSkip = 0;
    final result = await getExpertsUseCase(
      GetExpertsParams(skip: 0, limit: AppConstants.pageSize),
    );
    result.fold(
          (failure) => emit(ExpertFeedError(failure.message)),
          (experts) {
        _currentSkip = experts.length;
        emit(ExpertFeedLoaded(
          experts: experts,
          hasReachedMax: experts.length < AppConstants.pageSize,
        ));
      },
    );
  }

  Future<void> _onLoadMore(
      LoadMoreExpertsEvent event,
      Emitter<ExpertFeedState> emit,
      ) async {
    final current = state;
    if (current is! ExpertFeedLoaded) return;
    if (current.hasReachedMax || current.isLoadingMore) return;

    emit(current.copyWith(isLoadingMore: true));

    final result = await getExpertsUseCase(
      GetExpertsParams(skip: _currentSkip, limit: AppConstants.pageSize),
    );

    result.fold(
          (failure) => emit(ExpertFeedError(failure.message)),
          (newExperts) {
        _currentSkip += newExperts.length;
        emit(current.copyWith(
          experts: [...current.experts, ...newExperts],
          hasReachedMax: newExperts.length < AppConstants.pageSize,
          isLoadingMore: false,
        ));
      },
    );
  }

  Future<void> _onRefresh(
      RefreshExpertsEvent event,
      Emitter<ExpertFeedState> emit,
      ) async {
    add(const LoadExpertsEvent());
  }

  void _onToggleLike(
      ToggleLikeEvent event,
      Emitter<ExpertFeedState> emit,
      ) {
    final current = state;
    if (current is! ExpertFeedLoaded) return;

    final updated = current.experts.map((e) {
      if (e.id != event.expertId) return e;
      final liked = !e.isLiked;
      return e.copyWith(
        isLiked: liked,
        likeCount: liked ? e.likeCount + 1 : e.likeCount - 1,
      );
    }).toList();

    emit(current.copyWith(experts: updated));
  }

  void _onToggleSave(
      ToggleSaveEvent event,
      Emitter<ExpertFeedState> emit,
      ) {
    final current = state;
    if (current is! ExpertFeedLoaded) return;

    final updated = current.experts.map((e) {
      if (e.id != event.expertId) return e;
      return e.copyWith(isSaved: !e.isSaved);
    }).toList();

    emit(current.copyWith(experts: updated));
  }
}