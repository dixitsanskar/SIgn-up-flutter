

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_2/constants/routes.dart';
import '../firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer'as devtools show log;

import '../utilities/show_error._dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  
  late final TextEditingController _email;
  late final TextEditingController _password;
  @override
  void initState() {
    _email=TextEditingController();
    _password=TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
   _email.dispose();
   _password.dispose();

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
   return Scaffold(
    appBar: AppBar(title: const Text('Login'),),
     body: Column(
          children: [
            TextField(
             controller: _email,
             autocorrect: false,
             enableSuggestions: false,
             keyboardType: TextInputType.emailAddress,
               decoration: const InputDecoration(
                hintText: 'Enter your email here',
              ),
            ),
            TextField(
              controller: _password,
              obscureText: true,
              autocorrect: false,
              enableSuggestions: false,
              decoration: const InputDecoration(
                hintText: 'Enter your password here',
              ),
            
            ),
      
            TextButton(onPressed: () async {
              await Firebase.initializeApp(
                
              options: DefaultFirebaseOptions.currentPlatform,
       );
      
        
              final email= _email.text;
              final password=_password.text;
           try {
             
            
            await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
             final user=FirebaseAuth.instance.currentUser;
             if(user?.emailVerified ?? false)
             {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                  notesroute, 
                 (route) => false,);
             }

             else{

              Navigator.of(context).pushNamedAndRemoveUntil(
              verifyemailroute, 
             (route) => false,);
             }
             
           } 
           
           
           on FirebaseAuthException catch(e) {
            if(e.code=='user-not-found')
            {
              await showErrorDialog(context,'user not found');
            }
             
             else if(e.code=='wrong-password')
             {
             await showErrorDialog(context,'wrong password');
           
             }

             else 
             {
              await showErrorDialog(context,'Error: ${e.code}',);
             }
           }
           catch (e){
            await showErrorDialog(context,e.toString());
           }

           
            
            },
            child: const Text('Login'),),
   
            TextButton(onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(registerroute, 
              (route) => false,
              );
            }, child: const Text('Not registered yet? Register here!'),)
          ],
        ),
   );
  }
 
 
 
}


