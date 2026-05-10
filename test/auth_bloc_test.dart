import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wandersync/modules/auth/bloc/auth_bloc.dart';
import 'package:wandersync/modules/auth/bloc/auth_event.dart';
import 'package:wandersync/modules/auth/bloc/auth_state.dart';
import 'package:wandersync/modules/auth/repository/auth_repository.dart';

import 'auth_bloc_test.mocks.dart';

@GenerateMocks([AuthRepository, UserCredential, User])
void main() {
  late AuthBloc authBloc;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    authBloc = AuthBloc(authRepository: mockAuthRepository);
  });

  tearDown(() {
    authBloc.close();
  });

  group('AuthBloc Tests', () {
    test('initial state is AuthInitial', () {
      expect(authBloc.state, AuthInitial());
    });

    test('emits [AuthLoading, Authenticated] when SignInRequested is successful', () async {
      final mockCredential = MockUserCredential();
      final mockUser = MockUser();
      when(mockCredential.user).thenReturn(mockUser);
      when(mockAuthRepository.signIn(
        email: 'test@example.com',
        password: 'password123',
      )).thenAnswer((_) async => mockCredential);

      final expectedStates = [
        AuthLoading(),
        Authenticated(mockUser),
      ];

      expectLater(authBloc.stream, emitsInOrder(expectedStates));

      authBloc.add(SignInRequested('test@example.com', 'password123'));
    });

    test('emits [AuthLoading, AuthError] when SignInRequested fails', () async {
      when(mockAuthRepository.signIn(
        email: 'wrong@example.com',
        password: 'wrong',
      )).thenThrow(Exception('Login Failed'));

      final expectedStates = [
        AuthLoading(),
        AuthError('Exception: Login Failed'),
      ];

      expectLater(authBloc.stream, emitsInOrder(expectedStates));

      authBloc.add(SignInRequested('wrong@example.com', 'wrong'));
    });
  });
}
