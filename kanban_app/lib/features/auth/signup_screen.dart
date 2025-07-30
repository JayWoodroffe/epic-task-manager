import 'package:flutter/material.dart';
import 'package:kanban_app/features/auth/auth_provider.dart';
import 'package:kanban_app/features/dashboard/dashboard.dart';
import 'package:kanban_app/styles/colors.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final _fullNameController = TextEditingController();

  bool _obscureTextInitial = true;
  bool _obscureTextConfirm = true;
  bool _isLoading = false;

  @override
  void dispose() {
    // Dispose controllers when the widget is removed
    super.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: MyColors.cream,
      body: Stack(children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  //heading
                  Text('JOIN US',
                      style: TextStyle(
                          fontSize: 40,
                          color: MyColors.tertiary,
                          fontWeight: FontWeight.w900)),

                  SizedBox(height: 25),

                  //name input
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
                      controller: _fullNameController,
                      cursorColor: MyColors.tertiary,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: MyColors.cream,
                        labelText: 'Name',
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

                  SizedBox(height: 25),

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
                      obscureText: _obscureTextInitial,
                      cursorColor: MyColors.tertiary,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscureTextInitial = !_obscureTextInitial;
                              });
                            },
                            icon: Icon(_obscureTextInitial
                                ? Icons.visibility
                                : Icons.visibility_off)),
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

                  //confirm password input
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
                      controller: _passwordConfirmController,
                      obscureText: _obscureTextConfirm,
                      cursorColor: MyColors.tertiary,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscureTextConfirm = !_obscureTextConfirm;
                              });
                            },
                            icon: Icon(_obscureTextConfirm
                                ? Icons.visibility
                                : Icons.visibility_off)),
                        filled: true,
                        fillColor: MyColors.cream,
                        labelText: 'Confirm Password',
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

                  SizedBox(height: 30),

                  //signup button
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
                            checkPasswords(_passwordController.text,
                                _passwordConfirmController.text, _authProvider);
                          },
                          child: Text(
                            "Sign Up",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: MyColors.cream),
                          ),
                          style: TextButton.styleFrom(
                            side:
                                BorderSide(color: MyColors.charcoal, width: 3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            backgroundColor: MyColors.tertiary,
                          )),
                    ),
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

  void checkPasswords(
      String password, String confirmPassword, AuthProvider _authProvider) {
    String errorMessage = _authProvider.checkPasswordValidity(password);
    if (!errorMessage.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorMessage)));
      return; //initial password validity is treated as the preferential/more vital error
    }

    //mismatching password and confirm password will be displayed once the initial password is valid
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Passwords do not match.")));
    } else {
      //password is valid, both passwords match => can now call the register function
      if (_fullNameController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Name is required.")));
      } else if (_emailController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Email is required.")));
      } else {
        _handleSignup(_authProvider);
      }
    }
  }

  //handle signup request
  Future<void> _handleSignup(AuthProvider _authProvider) async {
    final email = _emailController.text.trim();
    final name = _fullNameController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _passwordConfirmController.text;

    setState(() => _isLoading = true);
    String? error = await _authProvider.register(
      name,
      email,
      password,
      confirmPassword,
    );

    setState(() => _isLoading = false);

    if (error == null) {
      //login successful, navigate to dashboard
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Dashboard()),
      );
    } else {
      //login failed, display error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }
}
