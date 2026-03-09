import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> signUp(String name, String email, String password);
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final SharedPreferences sharedPreferences;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.sharedPreferences,
  });

  @override
  Future<UserModel> login(String email, String password) async {
    final response = await firebaseAuth.signInWithEmailAndPassword(
      email: email, 
      password: password,
    );
    if (response.user != null) {
      final userModel = UserModel.fromFirebaseUser(response.user!);
      await _cacheUser(userModel);
      return userModel;
    } else {
      throw Exception('Login Failed');
    }
  }

  @override
  Future<UserModel> signUp(String name, String email, String password) async {
    final response = await firebaseAuth.createUserWithEmailAndPassword(
      email: email, 
      password: password,
    );
    if (response.user != null) {
      await response.user!.updateDisplayName(name);
      final userModel = UserModel.fromFirebaseUser(response.user!, name: name);
      await _cacheUser(userModel);
      return userModel;
    } else {
      throw Exception('Sign Up Failed');
    }
  }

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
    await sharedPreferences.remove('CACHED_USER');
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = firebaseAuth.currentUser;
    if (user != null) {
      return UserModel.fromFirebaseUser(user);
    }
    return null;
  }

  Future<void> _cacheUser(UserModel userModel) async {
    // Optionally cache the user info if needed
  }
}
