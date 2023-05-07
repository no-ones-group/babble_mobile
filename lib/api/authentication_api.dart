import 'package:babble_mobile/models/user.dart' as user_model;
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationAPI {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<ConfirmationResult> signInWeb(String phoneNumber) {
    return _firebaseAuth.signInWithPhoneNumber(phoneNumber);
  }

  Future<UserCredential?> verifyOTP(
      ConfirmationResult confirmationResult, String code) async {
    try {
      return await confirmationResult.confirm(code);
    } catch (e) {
      return null;
    }
  }

  user_model.User? getUser() {
    if (_firebaseAuth.currentUser == null) return null;
    user_model.User _ = user_model.User(
      id: _firebaseAuth.currentUser!.phoneNumber!,
      fullName: _firebaseAuth.currentUser!.uid,
      displayName: _firebaseAuth.currentUser!.displayName!,
      profilePicLink: _firebaseAuth.currentUser!.photoURL,
    );
    return _;
  }
}
