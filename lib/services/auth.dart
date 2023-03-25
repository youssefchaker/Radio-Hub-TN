import 'package:firebase_auth/firebase_auth.dart';
import 'package:prj_mobile/models/users.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user obj based on User
  Users? _userFromFirebaseUser(User user) {
    return (user != null ? Users(uid: user.uid) : null);
  }

  //auth change user stream
  Stream<Users?> get user {
    return _auth
        .authStateChanges()
        .map((User? user) => _userFromFirebaseUser(user!));
  }

  //sign in anon

  Future signinAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user as User;
      return _userFromFirebaseUser(user);
    } catch (e) {
      e.toString();
      return null;
    }
  }

  //sign in email&pass

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  //register mail&pass

  Future registerempass(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user!);
    } catch (err) {
      print(err.toString());
      return null;
    }
  }

  //signout

  Future signout() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
