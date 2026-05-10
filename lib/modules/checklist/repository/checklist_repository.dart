import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wandersync/modules/checklist/models/checklist_item.dart';

class ChecklistRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String get _uid => FirebaseAuth.instance.currentUser?.uid ?? '';

  Stream<List<ChecklistItem>> getChecklist() {
    if (_uid.isEmpty) return Stream.value([]);
    return _firestore
        .collection('users')
        .doc(_uid)
        .collection('checklists')
        .snapshots()
        .map((snapshot) {
      final realData = snapshot.docs.map((doc) {
        return ChecklistItem.fromMap(doc.data(), doc.id);
      }).toList();

      return [
        ...realData,
        const ChecklistItem(id: 'check1', title: 'Renew Passport', isCompleted: true),
        const ChecklistItem(id: 'check2', title: 'Book International Flight', isCompleted: true),
        const ChecklistItem(id: 'check3', title: 'Buy Travel Insurance', isCompleted: false),
        const ChecklistItem(id: 'check4', title: 'Pack Universal Adapter', isCompleted: false),
        const ChecklistItem(id: 'check5', title: 'Download Offline Maps', isCompleted: false),
      ];
    });
  }

  Future<void> addItem(String title) async {
    print('Attempting to add checklist item: $title (UID: $_uid)');
    if (_uid.isEmpty) {
      print('Error: User ID is empty. Cannot add item.');
      return;
    }
    try {
      await _firestore
          .collection('users')
          .doc(_uid)
          .collection('checklists')
          .add({
        'title': title,
        'isCompleted': false,
        'timestamp': FieldValue.serverTimestamp(),
      });
      print('Successfully added item to Firebase!');
    } catch (e) {
      print('Firebase Error: $e');
    }
  }

  Future<void> toggleItem(String id, bool currentStatus) async {
    print('Toggling checklist item: $id (New Status: ${!currentStatus})');
    if (_uid.isEmpty) return;
    await _firestore
        .collection('users')
        .doc(_uid)
        .collection('checklists')
        .doc(id)
        .update({'isCompleted': !currentStatus});
  }
}
