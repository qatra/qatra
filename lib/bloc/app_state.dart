import 'package:equatable/equatable.dart';
import '../user_model.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

abstract class AppState extends Equatable {
  const AppState();

  @override
  List<Object?> get props => [];
}

class AppInitial extends AppState {}

class AppLoading extends AppState {}

class AppAuthenticated extends AppState {
  final auth.User firebaseUser;
  final User? userProfile;
  final bool isAdmin;

  const AppAuthenticated({
    required this.firebaseUser,
    this.userProfile,
    this.isAdmin = false,
  });

  @override
  List<Object?> get props => [firebaseUser, userProfile, isAdmin];
}

class AppUnauthenticated extends AppState {}
