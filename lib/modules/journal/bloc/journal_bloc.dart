import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wandersync/modules/feed/models/journal_entry.dart';
import 'package:wandersync/modules/journal/repository/journal_repository.dart';

abstract class JournalEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadUserJournalsRequested extends JournalEvent {}

class UserJournalsUpdated extends JournalEvent {
  final List<JournalEntry> journals;
  UserJournalsUpdated(this.journals);

  @override
  List<Object?> get props => [journals];
}

class AddJournalEntryRequested extends JournalEvent {
  final String destination;
  final String note;
  AddJournalEntryRequested(this.destination, this.note);

  @override
  List<Object?> get props => [destination, note];
}

abstract class JournalState extends Equatable {
  @override
  List<Object?> get props => [];
}

class JournalInitial extends JournalState {}

class JournalLoading extends JournalState {}

class JournalLoaded extends JournalState {
  final List<JournalEntry> journals;
  JournalLoaded(this.journals);

  @override
  List<Object?> get props => [journals];
}

class JournalBloc extends Bloc<JournalEvent, JournalState> {
  final JournalRepository journalRepository;
  StreamSubscription? _journalSubscription;

  JournalBloc({required this.journalRepository}) : super(JournalInitial()) {
    on<LoadUserJournalsRequested>((event, emit) {
      emit(JournalLoading());
      _journalSubscription?.cancel();
      _journalSubscription = journalRepository.getUserJournals().listen(
        (journals) => add(UserJournalsUpdated(journals)),
      );
    });

    on<UserJournalsUpdated>((event, emit) {
      emit(JournalLoaded(event.journals));
    });

    on<AddJournalEntryRequested>((event, emit) async {
      await journalRepository.addEntry(event.destination, event.note);
    });
  }

  @override
  Future<void> close() {
    _journalSubscription?.cancel();
    return super.close();
  }
}
