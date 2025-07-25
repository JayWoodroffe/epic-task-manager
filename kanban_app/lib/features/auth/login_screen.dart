// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:kanban_app/features/auth/signup_screen.dart';
import 'package:kanban_app/features/dashboard/dashboard.dart';
import 'package:kanban_app/styles/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: MyColors.mintCream,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 150),
                Text('KANBAN',
                    style: TextStyle(
                        fontSize: 40,
                        color: MyColors.midGreen,
                        fontWeight: FontWeight.w900)),

                SizedBox(height: 40),

                //email input
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: MyColors.deepGreen,
                          blurRadius: 0,
                          offset: Offset(5, 7),
                        )
                      ]),
                  child: TextField(
                    style: Theme.of(context).textTheme.bodyMedium,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: MyColors.deepGreen,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: MyColors.mintCream,
                      labelText: 'Email',
                      labelStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: MyColors.deepGreen),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: MyColors.deepGreen, width: 3),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: MyColors.deepGreen, width: 3),
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
                          color: MyColors.deepGreen,
                        )
                      ]),
                  child: TextField(
                    style: Theme.of(context).textTheme.bodyMedium,
                    controller: _passwordController,
                    obscureText: true,
                    cursorColor: MyColors.deepGreen,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: MyColors.mintCream,
                      labelText: 'Password',
                      labelStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: MyColors.deepGreen),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: MyColors.deepGreen, width: 3),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: MyColors.deepGreen, width: 3),
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
                  child: TextButton(
                      onPressed: () => {
                            //TODO: auth logic
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) {
                              return Dashboard();
                            }))
                          },
                      child: Text(
                        "Login",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: MyColors.mintCream),
                      ),
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        backgroundColor: MyColors.deepGreen,
                      )),
                ),

                SizedBox(height: 40),
                //sign up text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account? ",
                        style: TextStyle(color: MyColors.deepGreen)),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return SignupScreen();
                        }));
                      },
                      child: Text(
                        "Sign Up.",
                        style: TextStyle(color: MyColors.midGreen),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
