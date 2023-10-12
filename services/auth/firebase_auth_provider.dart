import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_testingfirebase/services/auth/auth_exceptions.dart';
import 'package:flutter_application_testingfirebase/services/auth/auth_provider.dart';
import 'package:flutter_application_testingfirebase/services/auth/auth_user.dart';

import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException;

import '../../firebase_options.dart';

class FirebaseAuthProvider implements AuthProvider {
  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw WeakPasswordAuthException();

        //devtools.log('Weak Password');
      } else if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseAuthException();
        //devtools.log('Email is already in use. try a different one');
      } else if (e.code == 'invalid-email') {
        throw InvalidEamilAuthException();
        //devtools.log('Invalid email is entered!');
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser {
    //=> throw UnimplementedError();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      // print(e);
      if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        throw UserNotFoundAuthException();
      } else if (e.code == 'wrong-password') {
        throw WrongPasswordAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  // else if (e.code == 'weak-password') {
  //   devtools.log('Weak Password');
  // } else if (e.code == 'email-already-in-use') {
  //   devtools.log('Email is already in use. try a different one');
  // } else if (e.code == 'invalid-email') {
  //   devtools.log('Invalid email is entered!');
  // }

  // print('Something bad happened');
  // print(e.runtimeType);
  // print(e);

  @override
  Future<void> logOut() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw UserNotFoundAuthException();
    }
  }

  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
