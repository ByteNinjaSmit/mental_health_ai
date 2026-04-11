import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // SIGN UP
  Future<String?> signUp({
    required String email,
    required String password,
    required String name,
    required String age,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'name': name,
        'email': email,
        'age': age,
        'role': 'user',
        'createdAt': Timestamp.now(),
      });
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // LOGIN
  Future<String?> signIn({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // GOOGLE SIGN IN
  Future<String?> signInWithGoogle() async {
    try {
      await GoogleSignIn.instance.initialize();
      final GoogleSignInAccount googleUser = await GoogleSignIn.instance.authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
        if (!doc.exists) {
          await _firestore.collection('users').doc(user.uid).set({
            'uid': user.uid,
            'name': user.displayName ?? "No Name",
            'email': user.email ?? "",
            'age': "N/A",
            'role': 'user',
            'createdAt': Timestamp.now(),
          });
        }
      }
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // LOGOUT
  Future<void> signOut() async {
    await GoogleSignIn.instance.signOut();
    await _auth.signOut();
  }
}