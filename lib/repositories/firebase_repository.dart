import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:universal_io/io.dart';
import '../user_model.dart';
import '../message_model.dart';

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

  // --- Messages / Chat ---

  Stream<QuerySnapshot> getMessagesStream() {
    return _firestore
        .collection('messages')
        .orderBy('date', descending: true)
        .snapshots();
  }

  Future<void> sendMessage(MessageModel message) async {
    await _firestore
        .collection('messages')
        .doc(message.now.toString())
        .set(message.toMap());
  }

  // --- Donation Orders / Posts ---

  Future<QuerySnapshot> getPosts(
      {DocumentSnapshot? lastDocument,
      int limit = 10,
      String? bloodType}) async {
    var query = _firestore.collection('post').orderBy('date', descending: true);

    if (bloodType != null &&
        bloodType != ' - عرض كل الطلبات -  ' &&
        bloodType != 'اي فصيلة') {
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

  Future<QuerySnapshot> getDonors(String city,
      {DocumentSnapshot? lastDocument,
      int limit = 10,
      String? bloodType}) async {
    var query = _firestore
        .collection('bank')
        .doc(city)
        .collection('doners')
        .orderBy('date', descending: true);

    if (bloodType != null &&
        bloodType != ' - عرض كل الفصائل -  ' &&
        bloodType != 'اي فصيلة') {
      query = query.where('fasila', isEqualTo: bloodType);
    }

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    return await query.limit(limit).get();
  }

  Future<void> addDonorToBank(String city, User user) async {
    await _firestore
        .collection('bank')
        .doc(city)
        .collection('doners')
        .doc(user.uid)
        .set(user.toMap());
  }

  Future<void> updateUserPhoneInBank(
      String uid, String city, String phone) async {
    await _firestore
        .collection('bank')
        .doc(city)
        .collection('doners')
        .doc(uid)
        .update({'phone': phone});
  }

  Future<void> updateUserDateOfDonationInBank(
      String uid, String city, String date) async {
    await _firestore
        .collection('bank')
        .doc(city)
        .collection('doners')
        .doc(uid)
        .update({'dateOfDonation': date});
  }

  Future<void> updateUserDateOfDonationInBlazmaBank(
      String uid, String city, String date) async {
    await _firestore
        .collection('blazmaBank')
        .doc(city)
        .collection('doners')
        .doc(uid)
        .update({'dateOfDonation': date});
  }

  Future<void> updateUserBank(String uid, String city) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .update({'governrateBank': city});
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

  Future<void> deleteDonorFromBank(String city, String docId) async {
    await _firestore
        .collection('bank')
        .doc(city)
        .collection('doners')
        .doc(docId)
        .delete();
  }
}
