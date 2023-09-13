import 'package:chat_app_with_bloc/core/componenets/mybutton.dart';
import 'package:chat_app_with_bloc/core/componenets/mytextfield.dart';
import 'package:chat_app_with_bloc/services/auth/auth_services.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  Function()? onTap;
  RegisterView({super.key, required this.onTap});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();

  TextEditingController confirmPassword = TextEditingController();

  void signUp() async {
    if (password.text != confirmPassword.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password don\'t match'),
        ),
      );
      return;
    } else {
      final authService = AuthServices();
      try {
        await authService.signUpUser(email.text, password.text);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 50),
                //logo
                Icon(
                  Icons.person,
                  color: Colors.black,
                  size: 125,
                ),
                SizedBox(height: 50),
                Text(
                  'Let\'s create an account for you...',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 25),
                MyTextField(
                  controller: email,
                  hintText: 'Email',
                  obsecureText: false,
                ),
                SizedBox(height: 10),
                MyTextField(
                  controller: password,
                  hintText: 'Password',
                  obsecureText: true,
                ),
                SizedBox(height: 10),
                MyTextField(
                  controller: confirmPassword,
                  hintText: 'Confirm Password',
                  obsecureText: true,
                ),
                SizedBox(height: 25),
                MyButton(
                  onTap: signUp,
                  text: 'SIGN UP',
                ),
                SizedBox(height: 25),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already a member?',
                      ),
                      Text(
                        ' Login',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
