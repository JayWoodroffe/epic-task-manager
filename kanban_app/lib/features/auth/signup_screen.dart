import 'package:flutter/material.dart';
import 'package:kanban_app/styles/colors.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController();

  void dispose() {
    // Dispose controllers when the widget is removed
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.cream,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text('JOIN US',
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
                            BorderSide(color: MyColors.tertiary, width: 3),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: MyColors.tertiary, width: 3),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10),

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
                            BorderSide(color: MyColors.tertiary, width: 3),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: MyColors.tertiary, width: 3),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),
                //login button
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: TextButton(
                      onPressed: () => {},
                      child: Text(
                        "Sign Up",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: MyColors.cream),
                      ),
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        backgroundColor: MyColors.tertiary,
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
