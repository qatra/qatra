import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/firebase_repository.dart';

class PostState {
  final bool isLoading;
  final List<QueryDocumentSnapshot> posts;
  final bool hasMore;
  final String? error;
  final String? bloodType;

  PostState({
    required this.isLoading,
    required this.posts,
    required this.hasMore,
    this.error,
    this.bloodType,
  });

  factory PostState.initial() => PostState(
        isLoading: false,
        posts: [],
        hasMore: true,
        bloodType: ' - عرض كل الطلبات - ',
      );

  PostState copyWith({
    bool? isLoading,
    List<QueryDocumentSnapshot>? posts,
    bool? hasMore,
    String? error,
    String? bloodType,
  }) {
    return PostState(
      isLoading: isLoading ?? this.isLoading,
      posts: posts ?? this.posts,
      hasMore: hasMore ?? this.hasMore,
      error: error,
      bloodType: bloodType ?? this.bloodType,
    );
  }
}

class PostCubit extends Cubit<PostState> {
  final FirebaseRepository _firebaseRepo = FirebaseRepository.instance;

  PostCubit() : super(PostState.initial());

  Future<void> fetchPosts({bool refresh = false}) async {
    if (state.isLoading) return;
    if (!refresh && !state.hasMore) return;

    emit(state.copyWith(isLoading: true, error: null));

    try {
      final lastDoc =
          refresh ? null : (state.posts.isNotEmpty ? state.posts.last : null);
      final querySnapshot = await _firebaseRepo.getPosts(
        lastDocument: lastDoc,
        bloodType: state.bloodType,
      );

      final newPosts = querySnapshot.docs;
      final updatedPosts = refresh ? newPosts : [...state.posts, ...newPosts];

      emit(state.copyWith(
        isLoading: false,
        posts: updatedPosts,
        hasMore: newPosts.length == 10,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void setFilter(String bloodType) {
    if (state.bloodType == bloodType) return;
    emit(state.copyWith(bloodType: bloodType, posts: [], hasMore: true));
    fetchPosts(refresh: true);
  }
}
