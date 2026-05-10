import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wandersync/modules/auth/bloc/auth_event.dart';
import 'package:wandersync/modules/auth/bloc/auth_state.dart';
import 'package:wandersync/modules/auth/repository/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<SignInRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final credential = await authRepository.signIn(
          email: event.email,
          password: event.password,
        );
        if (credential.user != null) {
          emit(Authenticated(credential.user!));
        } else {
          emit(Unauthenticated());
        }
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(Unauthenticated());
      }
    });

    on<SignUpRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final credential = await authRepository.signUp(
          email: event.email,
          password: event.password,
        );
        if (credential.user != null) {
          emit(Authenticated(credential.user!));
        } else {
          emit(Unauthenticated());
        }
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(Unauthenticated());
      }
    });

    on<SignOutRequested>((event, emit) async {
      emit(AuthLoading());
      await authRepository.signOut();
      emit(Unauthenticated());
    });
  }
}
