import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wandersync/modules/checklist/models/checklist_item.dart';
import 'package:wandersync/modules/checklist/repository/checklist_repository.dart';

abstract class ChecklistEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadChecklistRequested extends ChecklistEvent {}

class ChecklistUpdated extends ChecklistEvent {
  final List<ChecklistItem> items;
  ChecklistUpdated(this.items);

  @override
  List<Object?> get props => [items];
}

class ToggleChecklistItemRequested extends ChecklistEvent {
  final ChecklistItem item;
  ToggleChecklistItemRequested(this.item);

  @override
  List<Object?> get props => [item];
}

class AddChecklistItemRequested extends ChecklistEvent {
  final String title;
  AddChecklistItemRequested(this.title);

  @override
  List<Object?> get props => [title];
}

abstract class ChecklistState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChecklistInitial extends ChecklistState {}

class ChecklistLoading extends ChecklistState {}

class ChecklistLoaded extends ChecklistState {
  final List<ChecklistItem> items;
  ChecklistLoaded(this.items);

  @override
  List<Object?> get props => [items];
}

class ChecklistBloc extends Bloc<ChecklistEvent, ChecklistState> {
  final ChecklistRepository checklistRepository;
  StreamSubscription? _checklistSubscription;

  ChecklistBloc({required this.checklistRepository}) : super(ChecklistInitial()) {
    on<LoadChecklistRequested>((event, emit) {
      emit(ChecklistLoading());
      _checklistSubscription?.cancel();
      _checklistSubscription = checklistRepository.getChecklist().listen(
        (items) => add(ChecklistUpdated(items)),
      );
    });

    on<ChecklistUpdated>((event, emit) {
      emit(ChecklistLoaded(event.items));
    });

    on<ToggleChecklistItemRequested>((event, emit) async {
      await checklistRepository.toggleItem(event.item.id, event.item.isCompleted);
    });

    on<AddChecklistItemRequested>((event, emit) async {
      await checklistRepository.addItem(event.title);
    });
  }

  @override
  Future<void> close() {
    _checklistSubscription?.cancel();
    return super.close();
  }
}
