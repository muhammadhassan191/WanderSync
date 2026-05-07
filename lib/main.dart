import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:wandersync/core/theme.dart';
import 'package:wandersync/modules/auth/bloc/auth_bloc.dart';
import 'package:wandersync/modules/auth/repository/auth_repository.dart';
import 'package:wandersync/modules/auth/ui/login_screen.dart';
import 'package:wandersync/modules/feed/bloc/feed_bloc.dart';
import 'package:wandersync/modules/feed/repository/feed_repository.dart';
import 'package:wandersync/modules/feed/ui/feed_screen.dart';
import 'package:wandersync/modules/wishlist/bloc/wishlist_bloc.dart';
import 'package:wandersync/modules/wishlist/repository/wishlist_repository.dart';
import 'package:wandersync/modules/wishlist/ui/wishlist_screen.dart';
import 'package:wandersync/modules/journal/bloc/journal_bloc.dart';
import 'package:wandersync/modules/journal/repository/journal_repository.dart';
import 'package:wandersync/modules/journal/ui/journal_screen.dart';
import 'package:wandersync/modules/checklist/bloc/checklist_bloc.dart';
import 'package:wandersync/modules/checklist/repository/checklist_repository.dart';
import 'package:wandersync/modules/checklist/ui/checklist_screen.dart';

import 'package:wandersync/firebase_options.dart';

final getIt = GetIt.instance;

void setupLocator() {
  // Repositories
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepository());
  getIt.registerLazySingleton<FeedRepository>(() => FeedRepository());
  getIt.registerLazySingleton<WishlistRepository>(() => WishlistRepository());
  getIt.registerLazySingleton<JournalRepository>(() => JournalRepository());
  getIt.registerLazySingleton<ChecklistRepository>(() => ChecklistRepository());

  // Blocs
  getIt.registerFactory(() => AuthBloc(authRepository: getIt<AuthRepository>()));
  getIt.registerFactory(() => FeedBloc(feedRepository: getIt<FeedRepository>()));
  getIt.registerFactory(() => WishlistBloc(wishlistRepository: getIt<WishlistRepository>()));
  getIt.registerFactory(() => JournalBloc(journalRepository: getIt<JournalRepository>()));
  getIt.registerFactory(() => ChecklistBloc(checklistRepository: getIt<ChecklistRepository>()));
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initializing Firebase with manual options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  setupLocator();
  runApp(const WanderSyncApp());
}

class WanderSyncApp extends StatelessWidget {
  const WanderSyncApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<AuthBloc>()),
        BlocProvider(create: (context) => getIt<FeedBloc>()..add(LoadFeedRequested())),
        BlocProvider(create: (context) => getIt<WishlistBloc>()..add(LoadWishlistRequested())),
        BlocProvider(create: (context) => getIt<JournalBloc>()..add(LoadUserJournalsRequested())),
        BlocProvider(create: (context) => getIt<ChecklistBloc>()..add(LoadChecklistRequested())),
      ],
      child: MaterialApp(
        title: 'WanderSync',
        theme: AppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasData) {
          return const MainNavigationScreen();
        }
        return const LoginScreen();
      },
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const FeedScreen(),
    const WishlistScreen(),
    const JournalScreen(),
    const ChecklistScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1E1E1E),
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.white24,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Feed'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Wishlist'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Journal'),
          BottomNavigationBarItem(icon: Icon(Icons.checklist), label: 'Prep'),
        ],
      ),
    );
  }
}
