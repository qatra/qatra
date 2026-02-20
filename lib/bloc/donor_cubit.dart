import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/firebase_repository.dart';

class DonorState {
  final bool isLoading;
  final List<QueryDocumentSnapshot> donors;
  final bool hasMore;
  final String? error;
  final String? bloodType;
  final String? currentCity;

  DonorState({
    required this.isLoading,
    required this.donors,
    required this.hasMore,
    this.error,
    this.bloodType,
    this.currentCity,
  });

  factory DonorState.initial() => DonorState(
        isLoading: false,
        donors: [],
        hasMore: true,
        bloodType: ' - عرض كل الفصائل -  ',
      );

  DonorState copyWith({
    bool? isLoading,
    List<QueryDocumentSnapshot>? donors,
    bool? hasMore,
    String? error,
    String? bloodType,
    String? currentCity,
  }) {
    return DonorState(
      isLoading: isLoading ?? this.isLoading,
      donors: donors ?? this.donors,
      hasMore: hasMore ?? this.hasMore,
      error: error,
      bloodType: bloodType ?? this.bloodType,
      currentCity: currentCity ?? this.currentCity,
    );
  }
}

class DonorCubit extends Cubit<DonorState> {
  final FirebaseRepository _firebaseRepo = FirebaseRepository.instance;

  DonorCubit() : super(DonorState.initial());

  Future<void> fetchDonors(String city, {bool refresh = false}) async {
    if (state.isLoading) return;
    if (!refresh && !state.hasMore && state.currentCity == city) return;

    final actualRefresh = refresh || state.currentCity != city;

    emit(state.copyWith(
      isLoading: true,
      error: null,
      currentCity: city,
      donors: actualRefresh ? [] : state.donors,
      hasMore: actualRefresh ? true : state.hasMore,
    ));

    try {
      final lastDoc = actualRefresh
          ? null
          : (state.donors.isNotEmpty ? state.donors.last : null);
      final querySnapshot = await _firebaseRepo.getDonors(
        city,
        lastDocument: lastDoc,
        bloodType: state.bloodType,
      );

      final newDonors = querySnapshot.docs;
      final updatedDonors =
          actualRefresh ? newDonors : [...state.donors, ...newDonors];

      emit(state.copyWith(
        isLoading: false,
        donors: updatedDonors,
        hasMore: newDonors.length == 10,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void setFilter(String bloodType, String city) {
    if (state.bloodType == bloodType && state.currentCity == city) return;
    emit(state.copyWith(
        bloodType: bloodType, donors: [], hasMore: true, currentCity: city));
    fetchDonors(city, refresh: true);
  }
}
