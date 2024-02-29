import 'package:flutter/material.dart';
import 'package:login/firebase/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("HomeScreen"),
                  ElevatedButton(
                    onPressed: () async {
                      await FirebaseAuthHelper().logOut();
                    },
                    child: const Text("Logout"),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
