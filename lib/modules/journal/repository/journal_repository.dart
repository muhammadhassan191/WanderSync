import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wandersync/modules/feed/models/journal_entry.dart';

class JournalRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String get _uid => FirebaseAuth.instance.currentUser?.uid ?? '';

  Stream<List<JournalEntry>> getUserJournals() {
    if (_uid.isEmpty) return Stream.value([]);
    return _firestore
        .collection('journals')
        .where('userId', isEqualTo: _uid)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      final realData = snapshot.docs.map((doc) {
        return JournalEntry.fromMap(doc.data(), doc.id);
      }).toList();

      return [
        ...realData,
        JournalEntry(
          id: 'journ1',
          userId: _uid,
          destination: 'New York City, USA',
          note: 'The city that never sleeps! Walking through Central Park was a dream.',
          timestamp: DateTime(2023, 10, 15),
        ),
        JournalEntry(
          id: 'journ2',
          userId: _uid,
          destination: 'Rome, Italy',
          note: 'History at every corner. The pasta was just as good as they say.',
          timestamp: DateTime(2022, 5, 20),
        ),
      ];
    });
  }

  Future<void> addEntry(String destination, String note) async {
    if (_uid.isEmpty) return;
    await _firestore.collection('journals').add({
      'userId': _uid,
      'destination': destination,
      'note': note,
      'timestamp': FieldValue.serverTimestamp(),
      'imageUrl': 'https://images.unsplash.com/photo-1503220317375-aaad61436b1b',
    });
  }
}
