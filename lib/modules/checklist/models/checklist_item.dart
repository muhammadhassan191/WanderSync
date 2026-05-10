import 'package:equatable/equatable.dart';

class ChecklistItem extends Equatable {
  final String id;
  final String title;
  final bool isCompleted;

  const ChecklistItem({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isCompleted': isCompleted,
    };
  }

  factory ChecklistItem.fromMap(Map<String, dynamic> map, String id) {
    return ChecklistItem(
      id: id,
      title: map['title'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
    );
  }

  @override
  List<Object?> get props => [id, title, isCompleted];
}
