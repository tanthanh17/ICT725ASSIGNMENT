import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_order_food/core/extension/log.dart';
import 'package:project_order_food/core/service/get_navigation.dart';
import 'package:project_order_food/locator.dart';

abstract class BaseAuth {
  Future<String?> signIn(String email, String password);

  Future<UserCredential?> signUp(String email, String password);

  User? getCurrentUser();

  Future<void> signOut();

  Future<bool> isEmailVerified();

  Future<String?> changeEmail(String email);

  Future<void> changePassword(String password);

  Future<void> sendPasswordResetMail(String email);
}

class AuthenticationService implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<String?> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return null;
    } catch (e) {
      return 'Username or password is incorrect';
    }
  }

  @override
  Future<UserCredential?> signUp(String email, String password) async {
    try {
      UserCredential newUser = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      return newUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        locator<GetNavigation>().openDialog(title: 'weak password');
      } else if (e.code == 'email-already-in-use') {
        locator<GetNavigation>().openDialog(title: 'The email already exists');
      } else {
        locator<GetNavigation>()
            .openDialog(title: 'Invalid registration information  $e');
      }
    } catch (e) {
      locator<GetNavigation>()
          .openDialog(title: 'The registration information is not valid $e');
    }
    return null;
  }

  @override
  User? getCurrentUser() {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      return user;
    }
    return null;
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<bool> isEmailVerified() async {
    User? user = getCurrentUser();
    if (user != null) {
      return user.emailVerified;
    }
    logError('Email not logged in');
    return false;
  }

  @override
  Future<String?> changeEmail(String email) async {
    User? user = getCurrentUser();
    if (user != null) {
      user.updateEmail(email).then((_) {
        return 'Successfully changed email';
      }).catchError((error) {
        return 'There is an issue with changing the email $error';
      });
    }
    return null;
  }

  @override
  Future<void> changePassword(String password) async {
    User? user = getCurrentUser();
    if (user != null) {
      user.updatePassword(password).then((_) {
        return 'Password changed successfully.';
      }).catchError((error) {
        return 'Error when changing password $error';
      });
    } else {
      logError('Error: Not logged in as a User');
    }
  }

  @override
  Future<void> sendPasswordResetMail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
    return;
  }
}
