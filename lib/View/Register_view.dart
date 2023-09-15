import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_2/constants/routes.dart';
import 'dart:developer'as devtools show log;

import '../firebase_options.dart';
import '../utilities/show_error._dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {

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
    appBar: AppBar(title: const Text('Register'),),
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
           try{
            final usercredentials =
               await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
               devtools.log(usercredentials.toString());
           }
   
           on FirebaseAuthException catch(e)
           {
            if(e.code=='weak-password')
            await showErrorDialog(context,'Weak password');
   
            else if(e.code=='email-already-in-use')
            await showErrorDialog(context,'email already in use');
   
            else 
            await showErrorDialog(context,'Error: ${e.code}',);
           }
           catch (e)
           {
            await showErrorDialog(context,e.toString(),);
           }
   
            },
            child: const Text('Register'),),
            TextButton(onPressed:() {
               Navigator.of(context).pushNamedAndRemoveUntil(loginroute, 
            (route) => false,);
            }, 
            child: const Text('Already registered? login here!'))
          ],
        ),
   );
  }
}

