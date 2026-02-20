import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import '../repositories/firebase_repository.dart';
import '../user_model.dart';
import 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  final FirebaseRepository _firebaseRepo = FirebaseRepository.instance;
  StreamSubscription<auth.User?>? _authStateSubscription;

  AppCubit() : super(AppInitial());

  void appStarted() {
    _authStateSubscription?.cancel();
    _authStateSubscription = _firebaseRepo.authStateChanges.listen((user) {
      _onAppUserChanged(user);
    });
  }

  Future<void> _onAppUserChanged(auth.User? firebaseUser) async {
    if (firebaseUser == null) {
      emit(AppUnauthenticated());
    } else {
      emit(AppLoading());
      final userProfile = await _firebaseRepo.getUserProfile(firebaseUser.uid);
      final bool isAdmin = firebaseUser.email == "abdallah.azmy2016@gmail.com";
      emit(AppAuthenticated(
        firebaseUser: firebaseUser,
        userProfile: userProfile,
        isAdmin: isAdmin,
      ));
    }
  }

  void updateProfile(User user) {
    if (state is AppAuthenticated) {
      final currentState = state as AppAuthenticated;
      emit(AppAuthenticated(
        firebaseUser: currentState.firebaseUser,
        userProfile: user,
        isAdmin: currentState.isAdmin,
      ));
    }
  }

  Future<void> refreshUserProfile({User? user}) async {
    if (state is AppAuthenticated) {
      final currentState = state as AppAuthenticated;
      User? userProfile;
      if (user == null) {
        userProfile =
            await _firebaseRepo.getUserProfile(currentState.firebaseUser.uid);
      }

      emit(AppAuthenticated(
        firebaseUser: currentState.firebaseUser,
        userProfile: user ?? userProfile,
        isAdmin: currentState.isAdmin,
      ));
    }
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }
}
