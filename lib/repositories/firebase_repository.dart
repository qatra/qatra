import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:universal_io/io.dart';

import '../user_model.dart';

class FirebaseRepository {
  static final FirebaseRepository instance = FirebaseRepository._();
  FirebaseRepository._();

  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // --- Authentication ---

  auth.User? get currentUser => _auth.currentUser;

  Stream<auth.User?> get authStateChanges => _auth.authStateChanges();

  Future<auth.UserCredential> loginWithGoogle(
      {required String? idToken, required String? accessToken}) async {
    return await _auth.signInWithCredential(auth.GoogleAuthProvider.credential(
        idToken: idToken, accessToken: accessToken));
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<auth.UserCredential> login(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<auth.UserCredential> register(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  // --- User Profile ---

  Future<User?> getUserProfile(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return User.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> createUserProfile(User user) async {
    await _firestore.collection('users').doc(user.uid).set(user.toMap());
  }

  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(uid).update(data);
  }

  // --- Storage ---

  Future<String> uploadUserImage(String uid, File imageFile) async {
    final ref = _storage.ref().child('user_images').child('$uid.jpg');
    final uploadTask = ref.putFile(imageFile);
    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  // --- Donation Orders / Posts ---

  Future<QuerySnapshot> getPosts(
      {DocumentSnapshot? lastDocument,
      int limit = 10,
      String? bloodType}) async {
    var query = _firestore.collection('post').orderBy('date', descending: true);

    if (bloodType != null && bloodType != ' - عرض كل الطلبات - ') {
      query = query.where('fasila', isEqualTo: bloodType);
    }

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    return await query.limit(limit).get();
  }

  Future<void> sendDonationRequest(
      Map<String, dynamic> postData, String requestId) async {
    await _firestore.collection("post").doc(requestId).set(postData);
  }

  Future<void> updatePostStatus(String requestId, bool isStillNeeded) async {
    await _firestore
        .collection('post')
        .doc(requestId)
        .update({'postColor': isStillNeeded});
  }

  Future<void> deleteDonationRequest(String requestId) async {
    await _firestore.collection('post').doc(requestId).delete();
  }

  // --- Blood Bank / Donors ---

  Future<QuerySnapshot> getDonors(String governrate,
      {DocumentSnapshot? lastDocument,
      int limit = 10,
      String? bloodType,
      String? searchAddress}) async {
    Query<Map<String, dynamic>> query =
        _firestore.collection('bank').doc(governrate).collection('doners');

    if (searchAddress != null && searchAddress.isNotEmpty) {
      // Prefix search using range query
      // Order must be by address when using range filter on it
      query = query
          .where('address', isGreaterThanOrEqualTo: searchAddress)
          .where('address', isLessThanOrEqualTo: '$searchAddress\uf8ff')
          .orderBy('address');
    } else {
      query = query.orderBy('date', descending: true);
    }

    if (bloodType != null && bloodType != ' - عرض كل الفصائل - ') {
      query = query.where('fasila', isEqualTo: bloodType);
    }

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    return await query.limit(limit).get();
  }

  Future<void> addDonorToBank(String governrate, User user) async {
    await _firestore
        .collection('bank')
        .doc(governrate)
        .collection('doners')
        .doc(user.uid)
        .set(user.toMap());
  }

  Future<void> updateDonorInBank(
      String uid, String governrate, Map<String, dynamic> data) async {
    await _firestore
        .collection('bank')
        .doc(governrate)
        .collection('doners')
        .doc(uid)
        .update(data);
  }

  Future<void> updateUserBank(String uid, String governrate) async {
    await _firestore.collection('users').doc(uid).update({
      'registeredBanks': FieldValue.arrayUnion([governrate])
    });
  }

  Future<void> removeUserBank(String uid, String governrate) async {
    await _firestore.collection('users').doc(uid).update({
      'registeredBanks': FieldValue.arrayRemove([governrate])
    });
  }

  Future<User?> getUserByEmail(String email) async {
    final querySnapshot = await _firestore
        .collection("users")
        .where("email", isEqualTo: email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return User.fromMap(querySnapshot.docs.first.data());
    }
    return null;
  }

  Future<void> deleteDonorFromBank(String governrate, String docId) async {
    await _firestore
        .collection('bank')
        .doc(governrate)
        .collection('doners')
        .doc(docId)
        .delete();
  }
}
