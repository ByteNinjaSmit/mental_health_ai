import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add forum post
  Future<void> addPost(String text, String userId) async {
    await _db.collection('posts').add({
      'text': text,
      'userId': userId,
      'timestamp': Timestamp.now(),
      'likes': 0,
    });
  }

  // Get posts stream
  Stream<QuerySnapshot> getPosts() {
    return _db.collection('posts').orderBy('timestamp', descending: true).snapshots();
  }

  // Book appointment
  Future<void> bookAppointment(String doctor, String date) async {
    await _db.collection('appointments').add({
      'doctor': doctor,
      'date': date,
      'timestamp': Timestamp.now(),
    });
  }
}