part of 'expert_feed_bloc.dart';

abstract class ExpertFeedState extends Equatable {
  const ExpertFeedState();

  @override
  List<Object?> get props => [];
}

class ExpertFeedInitial extends ExpertFeedState {
  const ExpertFeedInitial();
}

class ExpertFeedLoading extends ExpertFeedState {
  const ExpertFeedLoading();
}

class ExpertFeedLoaded extends ExpertFeedState {
  final List<ExpertEntity> experts;
  final bool hasReachedMax;
  final bool isLoadingMore;

  const ExpertFeedLoaded({
    required this.experts,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
  });

  ExpertFeedLoaded copyWith({
    List<ExpertEntity>? experts,
    bool? hasReachedMax,
    bool? isLoadingMore,
  }) {
    return ExpertFeedLoaded(
      experts: experts ?? this.experts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [experts, hasReachedMax, isLoadingMore];
}

class ExpertFeedError extends ExpertFeedState {
  final String message;
  const ExpertFeedError(this.message);

  @override
  List<Object?> get props => [message];
}