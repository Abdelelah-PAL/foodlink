import 'package:flutter/foundation.dart';
import '../models/auth_data.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(String email,
      String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password);
      return userCredential.user;
    }
    catch (ex) {
      rethrow;
    }
  }

  Future<AuthData?> signInUser(String email, String password) async {
    // AIzaSyDaQ7hyAkv5t710PjXRCKeHxnd5sjpKri4
    try {
      // var res = await http.post(
      //   Uri.parse(
      //       'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyCJDAzrvC_RraVS4gzwgFl4rZ1WjankX90'),
      //   body: json.encode({
      //     'email': email,
      //     'password': password,
      //     'returnSecureToken': true,
      //   }),
      // );
      // if (res.statusCode == 200) {
      //   return AuthData.fromJson(json.decode(res.body));
      // }
    }

    catch (ex) {
      rethrow;
    }
    return null;
  }
}
