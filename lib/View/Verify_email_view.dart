import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/constants/routes.dart';

class Verifyemailview extends StatefulWidget {
  const Verifyemailview({Key? key}) : super(key: key);

  @override
  State<Verifyemailview> createState() => _VerifyemailviewState();
}

class _VerifyemailviewState extends State<Verifyemailview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Email')),
      body: Column(
        children: [
          const Text('Please verify your email:'),
          TextButton(
            onPressed: () async{
              final user = FirebaseAuth.instance.currentUser;
              await user?.sendEmailVerification();
            },
            child: const Text('Send email verification'),
          ),
          
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, loginroute);
            },
            child: const Text('Go to Login Page'),
          ),
        ],
      ),
    );
  }
}
