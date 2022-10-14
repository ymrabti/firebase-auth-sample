import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loginsignup/controllers/auth_controller.dart';
import 'package:loginsignup/screens/signin.dart';
import 'package:loginsignup/widgets/custom_button.dart';
import 'package:loginsignup/widgets/custom_formfield.dart';
import 'package:loginsignup/widgets/custom_richtext.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _userName = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String get userName => _userName.text.trim();
  String get email => _emailController.text.trim();
  String get password => _passwordController.text.trim();

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
                height: 16,
              ),
              CustomFormField(
                headingText: "Username",
                hintText: "username",
                obsecureText: false,
                suffixIcon: const SizedBox(),
                maxLines: 1,
                textInputAction: TextInputAction.done,
                textInputType: TextInputType.text,
                controller: _userName,
              ),
              const SizedBox(
                height: 16,
              ),
              CustomFormField(
                headingText: "Email",
                hintText: "Email",
                obsecureText: false,
                suffixIcon: const SizedBox(),
                maxLines: 1,
                textInputAction: TextInputAction.done,
                textInputType: TextInputType.emailAddress,
                controller: _emailController,
              ),
              const SizedBox(
                height: 16,
              ),
              CustomFormField(
                maxLines: 1,
                textInputAction: TextInputAction.done,
                textInputType: TextInputType.text,
                controller: _passwordController,
                headingText: "Password",
                hintText: "At least 8 Character",
                obsecureText: true,
                suffixIcon: IconButton(icon: const Icon(Icons.visibility), onPressed: () {}),
              ),
              const SizedBox(
                height: 16,
              ),
              AuthButton(
                onTap: () {
                  AuthController authController = AuthController();
                  authController.register(email, password);
                },
                text: 'Sign Up',
              ),
              CustomRichText(
                discription: 'Already Have an account? ',
                text: 'Log In here',
                onTap: () {
                  Get.off(() => const Signin(), transition: Transition.rightToLeft);
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
