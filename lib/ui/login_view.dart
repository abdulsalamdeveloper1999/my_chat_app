import 'package:chat_app_with_bloc/core/componenets/mybutton.dart';
import 'package:chat_app_with_bloc/core/componenets/mytextfield.dart';
import 'package:chat_app_with_bloc/services/auth/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  Function()? onTap;
  LoginView({super.key, required this.onTap});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();

  //Sign In user method here
  void sign() async {
    final authService = Provider.of<AuthServices>(context, listen: false);
    try {
      await authService.signInUser(email.text, password.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
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
                SizedBox(height: 150),
                //logo
                Icon(
                  Icons.lock,
                  color: Colors.black,
                  size: 125,
                ),
                SizedBox(height: 50),
                Text(
                  'Welcome back you\'ve been missed',
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
                SizedBox(height: 25),
                MyButton(
                  onTap: sign,
                  text: 'SIGN IN',
                ),
                SizedBox(height: 25),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Not a member?',
                      ),
                      Text(
                        ' Register',
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
