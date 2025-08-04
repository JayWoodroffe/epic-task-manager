import 'package:flutter/material.dart';
import 'package:kanban_app/features/auth/auth_provider.dart';
import 'package:kanban_app/features/dashboard/dashboard.dart';
import 'package:kanban_app/styles/colors.dart';
import 'package:kanban_app/widgets/my_button.dart';
import 'package:kanban_app/widgets/my_text_form.dart';
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
                  MyTextField(
                      controller: _fullNameController,
                      label: 'Full Name',
                      hideContent: false,
                      textColor: MyColors.tertiary),

                  SizedBox(height: 25),

                  //email input
                  MyTextField(
                      controller: _emailController,
                      label: 'Email',
                      hideContent: false,
                      textColor: MyColors.tertiary),

                  SizedBox(height: 25),

                  //password input
                  MyTextField(
                      controller: _passwordController,
                      label: 'Password',
                      hideContent: true,
                      textColor: MyColors.tertiary),

                  SizedBox(height: 25),

                  //confirm password input
                  MyTextField(
                      controller: _passwordConfirmController,
                      label: 'Confirm Password',
                      hideContent: true,
                      textColor: MyColors.tertiary),

                  SizedBox(height: 30),

                  //signup button
                  MyButton(
                    label: 'Sign Up',
                    onButtonPressed: () => checkPasswords(
                        _passwordController.text,
                        _passwordConfirmController.text,
                        _authProvider),
                    color: MyColors.tertiary,
                    width: double.infinity,
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
        MaterialPageRoute(builder: (context) => ProjectDashboard()),
      );
    } else {
      //login failed, display error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }
}
