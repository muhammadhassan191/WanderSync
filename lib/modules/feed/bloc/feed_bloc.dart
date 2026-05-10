import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:wandersync/modules/feed/models/journal_entry.dart';
import 'package:wandersync/modules/feed/repository/feed_repository.dart';

abstract class FeedEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadFeedRequested extends FeedEvent {}

class FeedUpdated extends FeedEvent {
  final List<JournalEntry> journals;
  FeedUpdated(this.journals);

  @override
  List<Object?> get props => [journals];
}

abstract class FeedState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FeedInitial extends FeedState {}

class FeedLoading extends FeedState {}

class FeedLoaded extends FeedState {
  final List<JournalEntry> journals;
  FeedLoaded(this.journals);

  @override
  List<Object?> get props => [journals];
}

class FeedError extends FeedState {
  final String message;
  FeedError(this.message);

  @override
  List<Object?> get props => [message];
}

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final FeedRepository feedRepository;
  StreamSubscription? _feedSubscription;

  FeedBloc({required this.feedRepository}) : super(FeedInitial()) {
    on<LoadFeedRequested>((event, emit) {
      emit(FeedLoading());
      _feedSubscription?.cancel();
      _feedSubscription = feedRepository.getRecentJournals().listen(
        (journals) => add(FeedUpdated(journals)),
        onError: (error) {
          debugPrint('Feed Error: $error');
        },
      );
    });

    on<FeedUpdated>((event, emit) {
      emit(FeedLoaded(event.journals));
    });
  }

  @override
  Future<void> close() {
    _feedSubscription?.cancel();
    return super.close();
  }
}
