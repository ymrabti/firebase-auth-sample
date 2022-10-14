import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loginsignup/styles/app_colors.dart';
import 'package:loginsignup/screens/signup.dart';
import 'package:loginsignup/utils/console.dart';
import 'package:loginsignup/utils/constants.dart';
import 'package:loginsignup/widgets/custom_button.dart';
import 'package:loginsignup/widgets/custom_formfield.dart';
import 'package:loginsignup/widgets/custom_richtext.dart';

import '../controllers/auth_controller.dart';

class Signin extends StatefulWidget {
  const Signin({Key? key}) : super(key: key);

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String get email => _emailController.text.trim();
  String get password => _passwordController.text.trim();
  bool showPassword = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200,
                width: MediaQuery.of(context).size.width * 0.8,
                margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.09),
                child: Image.asset("assets/images/login.png"),
              ),
              const SizedBox(
                height: 24,
              ),
              CustomFormField(
                headingText: "Email",
                hintText: "Email",
                obsecureText: false,
                suffixIcon: const SizedBox(),
                controller: _emailController,
                maxLines: 1,
                textInputAction: TextInputAction.done,
                textInputType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 16,
              ),
              CustomFormField(
                headingText: "Password",
                maxLines: 1,
                textInputAction: TextInputAction.done,
                textInputType: TextInputType.text,
                hintText: "At least 8 Character",
                obsecureText: showPassword,
                suffixIcon: IconButton(
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (child, animation) {
                      return SizeTransition(
                        sizeFactor: animation,
                        child: FadeTransition(
                          opacity: animation,
                          child: RotationTransition(
                            turns: animation,
                            child: child,
                          ),
                        ),
                      );
                    },
                    child: showPassword
                        ? const Icon(
                            Icons.visibility,
                            key: Key('visibility'),
                          )
                        : const Icon(
                            Icons.remove_red_eye_outlined,
                            key: Key('remove_red_eye_outlined'),
                          ),
                  ),
                  onPressed: () {
                    setState(() {
                      showPassword = !showPassword;
                    });
                  },
                ),
                controller: _passwordController,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    child: InkWell(
                      onTap: () {
                        try {
                          firebaseAuth.sendPasswordResetEmail(email: email);
                        } on Exception catch (firebaseAuthException) {
                          Console.log('firebaseAuthException $firebaseAuthException',
                              color: ConsoleColors.red);
                        }
                      },
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: AppColors.blue.withOpacity(0.7),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              AuthButton(
                onTap: () {
                  AuthController authController = AuthController();
                  authController.login(email, password);
                },
                text: 'Sign In',
              ),
              CustomRichText(
                discription: "Don't already Have an account? ",
                text: "Sign Up",
                onTap: () {
                  Get.off(() => const SignUp());
                },
              ),
              SizedBox(
                height: Get.height - 124,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
