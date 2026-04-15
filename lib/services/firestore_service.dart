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

  // Book appointment (enhanced — used by BookingService now, kept for backward compat)
  Future<void> bookAppointment(String doctor, String date) async {
    if (currentUserId == null) return;
    await _db.collection('appointments').add({
      'doctor': doctor,
      'doctorName': doctor,
      'doctorId': '',
      'specialization': '',
      'date': date,
      'timeSlot': '',
      'userId': currentUserId,
      'status': 'booked',
      'createdAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
      'timestamp': Timestamp.now(),
    });
  }

  // Get appointments stream (for current user)
  Stream<QuerySnapshot> getAppointments() {
    return _db
        .collection('appointments')
        .where('userId', isEqualTo: currentUserId)
        .snapshots();
  }

  // Cancel appointment (now soft-delete: updates status instead of hard delete)
  Future<void> cancelAppointment(String docId) async {
    await _db.collection('appointments').doc(docId).update({
      'status': 'cancelled',
      'updatedAt': Timestamp.now(),
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

  // Save assessment results for trends
  Future<void> saveAssessmentResult(String type, Map<String, dynamic> result) async {
    if (currentUserId == null) return;
    await _db.collection('assessments').add({
      'type': type,
      'result': result,
      'userId': currentUserId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Get assessment history stream
  Stream<QuerySnapshot> getAssessmentHistory() {
    return _db
        .collection('assessments')
        .where('userId', isEqualTo: currentUserId)
        .snapshots();
  }
}