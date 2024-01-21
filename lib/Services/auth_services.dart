import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gpt/exceptions/authexception.dart';
import 'package:gpt/firebase_options.dart';

class AuthService{
  Future<User?> initialize() async {
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
    return FirebaseAuth.instance.currentUser;
  } catch (e) {
    print("Error during Firebase initialization: $e");
    return null; // You may return an appropriate value for your use case.
  }
}

  User? get currentuser => FirebaseAuth.instance.currentUser;

  Future<User?> createUser(String email , String password) async {
    try
    {
    // ignore: non_constant_identifier_names
    final UserCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    final user = UserCredential.user;
    if(user != null)
    {
      return user;
    }
    else
    {
      throw UserNotLoggedInAuthException();
    }
    }on FirebaseAuthException catch(e)
    {
      if (e.code == 'weak-password') {
        throw WeakPasswordAuthException();
      } else if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseAuthException();
      } else if (e.code == 'invalid-email') {
        throw InvalidEmailAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  Future<User?> login(String email , String password) async{
        try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      final user = FirebaseAuth.instance.currentUser;
      if(user != null)
      {
        return user;
      }
      else
      {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch(e) {
        print('Errorr${e.code}');
        if (e.code == 'user-not-found') {
          throw UserNotFoundAuthException();          
      } else if (e.code == 'wrong-password') {
        throw WrongPasswordAuthException();
      } else {
        throw GenericAuthException();
      }
    }
    catch(_)
    {
      throw GenericAuthException(); 
    }
  }

  Future <void> logout() async {
    if(FirebaseAuth.instance.currentUser != null)
    {
      FirebaseAuth.instance.signOut();
    }
    else
    {
      throw UserNotLoggedInAuthException();
    }
  }

  Future<void> sendEmailVerify() async{
    final user = FirebaseAuth.instance.currentUser;
    if(user != null)
    {
      user.sendEmailVerification();
    }
    else
    {
      throw UserNotLoggedInAuthException();
    }
  }

}