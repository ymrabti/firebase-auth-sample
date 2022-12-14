import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:loginsignup/screens/home.dart';
import 'package:loginsignup/screens/signup.dart';
import 'package:loginsignup/screens/widgets.dart';
import 'package:loginsignup/utils/console.dart';
import 'package:loginsignup/utils/constants.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  late Rx<User?> firebaseUser;

  @override
  void onInit() {
    firebaseUser = Rx<User?>(firebaseAuth.currentUser);

    firebaseUser.bindStream(firebaseAuth.userChanges());
    ever(firebaseUser, _setInitialScreen);
    super.onInit();
  }

  _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => const SignUp());
    } else {
      Get.offAll(() => const HomeScreen());
    }
  }

  void register(String email, password) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    } catch (firebaseAuthException) {
      Console.log('firebaseAuthException $firebaseAuthException', color: ConsoleColors.red);
    }
  }

  /* void verifyEmail(String email, password) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    } catch (firebaseAuthException) {
      //
    }
  } */

  void login(String email, String password) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } catch (firebaseAuthException) {
      Console.log('firebaseAuthException $firebaseAuthException', color: ConsoleColors.red);
    }
  }
}
