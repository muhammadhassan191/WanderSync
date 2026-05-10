import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wandersync/modules/auth/repository/auth_repository.dart';

@GenerateMocks([FirebaseAuth, UserCredential, User, FirebaseFirestore])
import 'auth_test.mocks.dart';

void main() {
  late AuthRepository authRepository;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockFirebaseFirestore mockFirestore;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockFirestore = MockFirebaseFirestore();
    authRepository = AuthRepository(
      firebaseAuth: mockFirebaseAuth,
      firestore: mockFirestore,
    );
  });

  group('AuthRepository Tests', () {
    test('signIn returns UserCredential on success', () async {
      final mockCredential = MockUserCredential();
      final mockUser = MockUser();
      
      when(mockCredential.user).thenReturn(mockUser);
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: 'test@example.com',
        password: 'password123',
      )).thenAnswer((_) async => mockCredential);

      final result = await authRepository.signIn(
        email: 'test@example.com',
        password: 'password123',
      );

      expect(result.user, mockUser);
      verify(mockFirebaseAuth.signInWithEmailAndPassword(
        email: 'test@example.com',
        password: 'password123',
      )).called(1);
    });

    test('signIn throws exception on failure', () async {
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: 'wrong@example.com',
        password: 'wrong',
      )).thenThrow(FirebaseAuthException(code: 'user-not-found'));

      expect(
        () => authRepository.signIn(email: 'wrong@example.com', password: 'wrong'),
        throwsException,
      );
    });
  });
}
