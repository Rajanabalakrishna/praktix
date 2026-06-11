part of 'expert_feed_bloc.dart';

abstract class ExpertFeedEvent extends Equatable {
  const ExpertFeedEvent();

  @override
  List<Object?> get props => [];
}

class LoadExpertsEvent extends ExpertFeedEvent {
  const LoadExpertsEvent();
}

class LoadMoreExpertsEvent extends ExpertFeedEvent {
  const LoadMoreExpertsEvent();
}

class RefreshExpertsEvent extends ExpertFeedEvent {
  const RefreshExpertsEvent();
}

class ToggleLikeEvent extends ExpertFeedEvent {
  final int expertId;
  const ToggleLikeEvent(this.expertId);

  @override
  List<Object?> get props => [expertId];
}

class ToggleSaveEvent extends ExpertFeedEvent {
  final int expertId;
  const ToggleSaveEvent(this.expertId);

  @override
  List<Object?> get props => [expertId];
}