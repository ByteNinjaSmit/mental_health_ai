import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get currentUserId => _auth.currentUser?.uid;

  // Add forum post
  Future<void> addPost(String text) async {
    if (currentUserId == null) return;
    await _db.collection('posts').add({
      'text': text,
      'userId': currentUserId,
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
    if (currentUserId == null) return;
    await _db.collection('appointments').add({
      'doctor': doctor,
      'date': date,
      'userId': currentUserId,
      'status': 'pending',
      'timestamp': Timestamp.now(),
    });
  }

  // Log emergency/therapy call
  Future<void> logCall(String type) async {
    if (currentUserId == null) return;
    await _db.collection('calls').add({
      'type': type,
      'userId': currentUserId,
      'timestamp': Timestamp.now(),
    });
  }

  // Generate systematic notification
  Future<void> sendNotification(String title, String message) async {
    if (currentUserId == null) return;
    await _db.collection('notification').add({
      'title': title,
      'message': message,
      'userId': currentUserId,
      'read': false,
      'timestamp': Timestamp.now(),
    });
  }
}