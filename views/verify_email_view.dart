// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_testingfirebase/routes.dart';
import 'package:flutter_application_testingfirebase/services/auth/auth_service.dart';

class VerifyEmailView extends StatelessWidget {
  const VerifyEmailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify Email"),
        // actions: [
        //   IconButton(
        //       onPressed: () {
        //         Navigator.of(context).pop();
        //       },
        //       icon: const Icon(Icons.arrow_back)),
        // ],
      ),
      body: Column(children: [
        const Text(
            "We've sent you an email verification, please open it to verify your account"),
        const Text(
            "if you hav'nt received a verification email, press the button below"),
        TextButton(
          onPressed: () async {
            await AuthService.firebase().sendEmailVerification();
            //  final user = FirebaseAuth.instance.currentUser;
            //  await user?.sendEmailVerification();
          },
          child: const Text('Send email verification'),
        ),
        TextButton(
          onPressed: () async {
            await AuthService.firebase().logOut();
            // await FirebaseAuth.instance.signOut();
            Navigator.of(context).pushNamedAndRemoveUntil(
              registerRoute,
              (route) => false,
            );
            //await user?.sendEmailVerification();
          },
          child: const Text('Restart'),
        )
      ]),
    );
  }
}
