// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:kanban_app/features/auth/auth_provider.dart';
import 'package:kanban_app/features/auth/signup_screen.dart';
import 'package:kanban_app/features/dashboard/dashboard.dart';
import 'package:kanban_app/styles/colors.dart';
import 'package:kanban_app/features/auth/auth_service.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final _authProvider = Provider.of<AuthProvider>(context, listen: false);
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

                  SizedBox(height: 20),

                  //email input
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: MyColors.tertiary,
                            blurRadius: 0,
                            offset: Offset(5, 7),
                          )
                        ]),
                    child: TextField(
                      style: Theme.of(context).textTheme.bodyMedium,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: MyColors.tertiary,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: MyColors.cream,
                        labelText: 'Email',
                        labelStyle: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: MyColors.tertiary),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: MyColors.charcoal, width: 3),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: MyColors.charcoal, width: 3),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  //password input
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 0,
                            offset: Offset(5, 7),
                            color: MyColors.tertiary,
                          )
                        ]),
                    child: TextField(
                      style: Theme.of(context).textTheme.bodyMedium,
                      controller: _passwordController,
                      obscureText: true,
                      cursorColor: MyColors.tertiary,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: MyColors.cream,
                        labelText: 'Password',
                        labelStyle: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: MyColors.tertiary),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: MyColors.charcoal, width: 3),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: MyColors.charcoal, width: 3),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 25),

                  //login button
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 0,
                              color: MyColors.charcoal,
                              offset: Offset(5, 7))
                        ],
                      ),
                      child: TextButton(
                          onPressed: () {
                            _handleLogin(_authProvider);
                          },
                          child: Text(
                            "Login",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: MyColors.cream),
                          ),
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: MyColors.charcoal, width: 3),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            backgroundColor: MyColors.tertiary,
                          )),
                    ),
                  ),

                  SizedBox(height: 40),

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
  Future<void> _handleLogin(AuthProvider _authProvider) async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    setState(() => _isLoading = true);
    final success = await _authProvider.login(email, password);
    setState(() => _isLoading = false);

    if (success) {
      //login successful, navigate to dashboard
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Dashboard()),
      );
    } else {
      //login failed, display error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed. Please check credentials')),
      );
    }
  }
}
