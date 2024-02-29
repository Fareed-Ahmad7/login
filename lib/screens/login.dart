import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/firebase/firebase_auth.dart';
import 'package:login/utils/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 62, 0, 0),
                child: Image(
                  image: AssetImage(
                    "./assets/icons/icon.png",
                  ),
                  height: 100,
                ),
              ),
            ),
            const SizedBox(height: 62),
            const Padding(
              padding: EdgeInsets.fromLTRB(28, 0, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome back!",
                    style: TextStyle(
                      fontSize: 32,
                      fontFamily: "Nunito",
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Login to your account to continue",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Nunito",
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 52),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(32, 0, 32, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFormField(
                      controller: _emailController,
                      validator: (email) =>
                          EmailValidator.validate(email!.trim())
                              ? null
                              : "Please enter a valid email",
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Email',
                        hintStyle: TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscureText,
                      validator: (password) {
                        if (password == null ||
                            password.isEmpty ||
                            password.length < 6) {
                          return 'Please enter a valid password (6+ characters)';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.visiblePassword,
                      autofillHints: const [AutofillHints.password],
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: const TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w400,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 56,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: btnColor,
                      shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(24))),
                  onPressed: () {
                    signinWithEmail(context);
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Nunito',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40)
          ],
        ),
      ),
    );
  }

  Future<void> signinWithEmail(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await FirebaseAuthHelper().emailLogin(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      } on FirebaseAuthException catch (e) {
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text("Error"),
              content: Text(e.code),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: const Text("okay"),
                ),
              ],
            ),
          );
        }
      }
    }
  }
}
