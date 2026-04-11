import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveMessage(String userId, String message, bool isUser) async {
    await _db.collection('chat_history').add({
      'userId': userId,
      'message': message,
      'isUser': isUser,
      'timestamp': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> getMessages(String userId) {
    return _db
        .collection('chat_history')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp')
        .snapshots();
  }
}