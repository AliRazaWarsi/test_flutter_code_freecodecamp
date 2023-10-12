//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_testingfirebase/routes.dart';
import 'package:flutter_application_testingfirebase/services/auth/auth_service.dart';
import 'package:flutter_application_testingfirebase/views/login_view.dart';
import 'package:flutter_application_testingfirebase/views/notes/new_note_view.dart';
import 'package:flutter_application_testingfirebase/views/notes/notes_view.dart';
import 'package:flutter_application_testingfirebase/views/register_view.dart';
import 'package:flutter_application_testingfirebase/views/verify_email_view.dart';
//import 'firebase_options.dart';
//import 'dart:developer' as devtools show log;

void main() {
  WidgetsFlutterBinding.ensureInitialized;
  runApp(
    MaterialApp(
        title: ' Flutter firebase integeration',
        theme: ThemeData(primarySwatch: Colors.blueGrey),
        // home: const RegisterView(),
        home: const HomePage(),
        routes: {
          loginRoute: (context) => const LoginView(),
          registerRoute: (context) => const RegisterView(),
          notesRoute: (context) => const NotesView(),
          verifyEmailRoute: (context) => const VerifyEmailView(),
          newNoteRoute: (context) => const NewNoteView(),
        }
        //home: RegisterView(),
        //home: const RegisterView(),
        //home: const MyHomePage(title: 'Flutter Demo Home Page'),
        ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( 
        title: const Text(' Home'),
      ),
      // future builder is used to perform the asychronous functions and based on that function, it will update the UI of the app.
      body: FutureBuilder(
        future: AuthService.firebase().initialize(),
        // Firebase.initializeApp(
        //  options: DefaultFirebaseOptions.currentPlatform,
        //),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              //  final user = FirebaseAuth.instance.currentUser;
              // replace above FirebaseAuth with AuthService.
              final user = AuthService.firebase().currentUser;

              if (user != null) {
                if (user.isEmailVerified) {
                  print('hello world');
                  return const NotesView();
                  //print('Email is verified.');
                } else {
                  print(user);
                  return const VerifyEmailView();
                  // return const NotesView();
                }
              } else {
                return const LoginView();
              }
            default:
              return const CircularProgressIndicator();
          }
          //return const Text('Done');
        },
      ),
    );
  }
}

enum MenuAction { logout }

/* class VerifyEmailView extends StatelessWidget {
  const VerifyEmailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify Email"),
      ),
      body: Column(children: [
        const Text('Please verify your email address:'),
        TextButton(
          onPressed: () async {
            final user = FirebaseAuth.instance.currentUser;
            await user?.sendEmailVerification();
          },
          child: const Text('Send email verification'),
        )
      ]),
    );
  }
}
*/

// class RegisterView extends StatefulWidget {
//   const RegisterView({super.key});

//   @override
//   State<RegisterView> createState() => _RegisterViewState();
// }

// class _RegisterViewState extends State<RegisterView> {
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }
