import 'package:equatable/equatable.dart';

class JournalEntry extends Equatable {
  final String id;
  final String userId;
  final String destination;
  final String? imageUrl;
  final String note;
  final DateTime timestamp;

  const JournalEntry({
    required this.id,
    required this.userId,
    required this.destination,
    this.imageUrl,
    required this.note,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'destination': destination,
      'imageUrl': imageUrl,
      'note': note,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory JournalEntry.fromMap(Map<String, dynamic> map, String id) {
    DateTime parsedDate;
    final timestamp = map['timestamp'];
    
    if (timestamp is String) {
      parsedDate = DateTime.parse(timestamp);
    } else if (timestamp is dynamic && timestamp?.runtimeType.toString() == 'Timestamp') {
      // Handle Firestore Timestamp object
      parsedDate = timestamp.toDate();
    } else {
      parsedDate = DateTime.now();
    }

    return JournalEntry(
      id: id,
      userId: map['userId'] ?? '',
      destination: map['destination'] ?? '',
      imageUrl: map['imageUrl'],
      note: map['note'] ?? '',
      timestamp: parsedDate,
    );
  }

  @override
  List<Object?> get props => [id, userId, destination, imageUrl, note, timestamp];
}
