import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wandersync/modules/feed/models/journal_entry.dart';

class FeedRepository {
  final FirebaseFirestore _firestore;

  FeedRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<List<JournalEntry>> getRecentJournals() {
    return _firestore
        .collection('journals')
        .orderBy('timestamp', descending: true)
        .limit(20)
        .snapshots()
        .map((snapshot) {
      final realData = snapshot.docs.map((doc) {
        return JournalEntry.fromMap(doc.data(), doc.id);
      }).toList();

      // Combine with stunning mock data for a full feed
      return [
        ...realData,
        JournalEntry(
          id: 'mock1',
          userId: 'system',
          destination: 'Bali, Indonesia',
          imageUrl: 'https://images.unsplash.com/photo-1537996194471-e657df975ab4',
          note: 'The sunsets at Uluwatu are absolutely breathtaking. A must-visit for every soul seeker! 🌅',
          timestamp: DateTime.now().subtract(const Duration(days: 2)),
        ),
        JournalEntry(
          id: 'mock2',
          userId: 'system',
          destination: 'Paris, France',
          imageUrl: 'https://images.unsplash.com/photo-1502602898657-3e91760cbb34',
          note: 'Lost in the streets of Montmartre. Found the best croissant in the city today! 🥐✨',
          timestamp: DateTime.now().subtract(const Duration(days: 5)),
        ),
        JournalEntry(
          id: 'mock3',
          userId: 'system',
          destination: 'Kyoto, Japan',
          imageUrl: 'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e',
          note: 'The serenity of the bamboo forest is unmatched. Feeling truly at peace. 🎋🧘‍♂️',
          timestamp: DateTime.now().subtract(const Duration(days: 10)),
        ),
      ];
    });
  }
}
