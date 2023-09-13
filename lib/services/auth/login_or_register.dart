import 'package:chat_app_with_bloc/ui/login_view.dart';
import 'package:chat_app_with_bloc/ui/register_view.dart';
import 'package:flutter/cupertino.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool showLoginView = true;

  void togglePages() {
    setState(() {
      showLoginView = !showLoginView;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginView) {
      return LoginView(
        onTap: togglePages,
      );
    } else {
      return RegisterView(
        onTap: togglePages,
      );
    }
  }
}
