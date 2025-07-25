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
      backgroundColor: MyColors.mintCream,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('JOIN US',
                    style: TextStyle(
                        fontSize: 40,
                        color: MyColors.deepGreen,
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

                SizedBox(height: 10),

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

                SizedBox(height: 20),
                //login button
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: TextButton(
                      onPressed: () => {},
                      child: Text(
                        "Join",
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
