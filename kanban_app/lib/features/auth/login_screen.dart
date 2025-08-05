// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:kanban_app/providers/auth_provider.dart';
import 'package:kanban_app/features/auth/signup_screen.dart';
import 'package:kanban_app/features/dashboard/dashboard.dart';
import 'package:kanban_app/styles/colors.dart';
import 'package:kanban_app/widgets/my_button.dart';
import 'package:kanban_app/widgets/my_text_form.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false; //to show if the api is loading the login results

  @override
  void dispose() {
    // Dispose controllers when the widget is removed
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: MyColors.cream,
      body: Stack(children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('KANBAN',
                      style: TextStyle(
                          fontSize: 40,
                          color: MyColors.tertiary,
                          fontWeight: FontWeight.w900)),

                  SizedBox(height: 25),

                  //email input
                  MyTextField(
                    controller: _emailController,
                    label: 'Email',
                    hideContent: false,
                    keyBoardType: TextInputType.emailAddress,
                    textColor: MyColors.tertiary,
                  ),

                  SizedBox(height: 25),

                  //password input
                  MyTextField(
                      controller: _passwordController,
                      label: 'Password',
                      hideContent: true,
                      textColor: MyColors.tertiary),

                  SizedBox(height: 30),

                  //login button
                  MyButton(
                    label: 'Login',
                    onButtonPressed: () => _handleLogin(authProvider),
                    color: MyColors.tertiary,
                    width: double.infinity,
                  ),

                  SizedBox(height: 20),

                  //sign up text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account? ",
                          style: TextStyle(color: MyColors.charcoal)),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                            return SignupScreen();
                          }));
                        },
                        child: Text(
                          "Sign Up.",
                          style: TextStyle(color: MyColors.tertiary),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        //loading indicator
        if (_isLoading)
          Container(
            color: Colors.black54, // semi-transparent background
            child: Center(
              child: CircularProgressIndicator(
                color: MyColors.tertiary,
              ),
            ),
          ),
      ]),
    );
  }

  //handle login request
  Future<void> _handleLogin(AuthProvider authProvider) async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    setState(() => _isLoading = true);
    final success = await authProvider.login(email, password);
    setState(() => _isLoading = false);

    if (success) {
      //login successful, navigate to dashboard
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => ProjectDashboard()),
      );
    } else {
      //login failed, display error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed. Please check credentials')),
      );
    }
  }
}
