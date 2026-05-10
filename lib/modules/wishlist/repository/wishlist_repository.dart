import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wandersync/modules/wishlist/models/wishlist_item.dart';

class WishlistRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  WishlistRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  String get _uid => _auth.currentUser?.uid ?? '';

  Stream<List<WishlistItem>> getWishlist() {
    if (_uid.isEmpty) return Stream.value([]);
    return _firestore
        .collection('users')
        .doc(_uid)
        .collection('wishlist')
        .snapshots()
        .map((snapshot) {
      final realData = snapshot.docs.map((doc) {
        return WishlistItem.fromMap(doc.data(), doc.id);
      }).toList();

      return [
        ...realData,
        const WishlistItem(
          id: 'wish1',
          destination: 'Santorini, Greece',
          budget: 2500,
          notes: 'Stay in a white villa overlooking the Aegean Sea.',
          imageUrl: 'https://images.unsplash.com/photo-1570077188670-e3a8d69ac5ff',
        ),
        const WishlistItem(
          id: 'wish2',
          destination: 'Reykjavik, Iceland',
          budget: 3500,
          notes: 'Chase the Northern Lights and soak in the Blue Lagoon.',
          imageUrl: 'https://images.unsplash.com/photo-1504109586057-7a2ae83d1338',
        ),
      ];
    });
  }

  Future<void> addWishlistItem(WishlistItem item) async {
    await _firestore
        .collection('users')
        .doc(_uid)
        .collection('wishlist')
        .add(item.toMap());
  }

  Future<void> deleteWishlistItem(String id) async {
    await _firestore
        .collection('users')
        .doc(_uid)
        .collection('wishlist')
        .doc(id)
        .delete();
  }
}
