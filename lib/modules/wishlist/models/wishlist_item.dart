import 'package:equatable/equatable.dart';

class WishlistItem extends Equatable {
  final String id;
  final String destination;
  final double budget;
  final String notes;
  final String? imageUrl;

  const WishlistItem({
    required this.id,
    required this.destination,
    required this.budget,
    required this.notes,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'destination': destination,
      'budget': budget,
      'notes': notes,
      'imageUrl': imageUrl,
    };
  }

  factory WishlistItem.fromMap(Map<String, dynamic> map, String id) {
    return WishlistItem(
      id: id,
      destination: map['destination'] ?? '',
      budget: (map['budget'] ?? 0.0).toDouble(),
      notes: map['notes'] ?? '',
      imageUrl: map['imageUrl'],
    );
  }

  @override
  List<Object?> get props => [id, destination, budget, notes, imageUrl];
}
