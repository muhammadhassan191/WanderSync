import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wandersync/modules/wishlist/models/wishlist_item.dart';
import 'package:wandersync/modules/wishlist/repository/wishlist_repository.dart';

abstract class WishlistEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadWishlistRequested extends WishlistEvent {}

class WishlistUpdated extends WishlistEvent {
  final List<WishlistItem> items;
  WishlistUpdated(this.items);

  @override
  List<Object?> get props => [items];
}

class AddWishlistItemRequested extends WishlistEvent {
  final WishlistItem item;
  AddWishlistItemRequested(this.item);

  @override
  List<Object?> get props => [item];
}

abstract class WishlistState extends Equatable {
  @override
  List<Object?> get props => [];
}

class WishlistInitial extends WishlistState {}

class WishlistLoading extends WishlistState {}

class WishlistLoaded extends WishlistState {
  final List<WishlistItem> items;
  WishlistLoaded(this.items);

  @override
  List<Object?> get props => [items];
}

class WishlistError extends WishlistState {
  final String message;
  WishlistError(this.message);

  @override
  List<Object?> get props => [message];
}

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  final WishlistRepository wishlistRepository;
  StreamSubscription? _wishlistSubscription;

  WishlistBloc({required this.wishlistRepository}) : super(WishlistInitial()) {
    on<LoadWishlistRequested>((event, emit) {
      emit(WishlistLoading());
      _wishlistSubscription?.cancel();
      _wishlistSubscription = wishlistRepository.getWishlist().listen(
        (items) => add(WishlistUpdated(items)),
        onError: (error) => print('Wishlist Error: $error'),
      );
    });

    on<WishlistUpdated>((event, emit) {
      emit(WishlistLoaded(event.items));
    });

    on<AddWishlistItemRequested>((event, emit) async {
      try {
        await wishlistRepository.addWishlistItem(event.item);
      } catch (e) {
        emit(WishlistError(e.toString()));
      }
    });
  }

  @override
  Future<void> close() {
    _wishlistSubscription?.cancel();
    return super.close();
  }
}
