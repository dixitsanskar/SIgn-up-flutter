

import 'package:flutter_application_2/View/Verify_email_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_2/View/Login_view.dart';
import 'package:flutter_application_2/View/Register_view.dart';
import 'package:flutter_application_2/constants/routes.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:developer'as devtools show log;
import 'constants/routes.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        
        primarySwatch: Colors.blue,
      ),
      home: const Homepage(),
      routes: {
        loginroute: (context) => const LoginView(),
        registerroute: (context) => const RegisterView(),
        notesroute :(context) =>const Homepage(),
        verifyemailroute:(context) =>const Verifyemailview(),

      },
    );
  }
}

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
              
            options: DefaultFirebaseOptions.currentPlatform,
     ),

      builder: (context, snapshot) {
       switch(snapshot.connectionState){
         case ConnectionState.done:
         final user=FirebaseAuth.instance.currentUser;
         if(user!=null)
         {
          if(user.emailVerified)
          {
            return Notesview();
          }
          else 
          {
            return const Verifyemailview();
          }
         }

         else 
         {
          return const LoginView();
         }
        
          default: 
          Scaffold:
          return CircularProgressIndicator();
          
       }
        
      },
      
    );
  }
 
}

enum MenuAction {logout}

  class Notesview extends StatefulWidget {
  const Notesview({super.key});

  @override
  State<Notesview> createState() => _NotesviewState();
}

class _NotesviewState extends State<Notesview> {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
    appBar: AppBar(
      title: const Text('Main UI'),
      actions: [
        PopupMenuButton<MenuAction>(
          onSelected:(value) async{
            switch(value){
               case MenuAction.logout:
                final shouldlogout=await showLogoutDialog(context);
               if(shouldlogout)
               {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushNamedAndRemoveUntil(loginroute, (_) => false,);
               }
            }
          
             
            },
          itemBuilder: (context){
            return const [
              PopupMenuItem<MenuAction>(
                value: MenuAction.logout,
                child: Text('Logout'),
              )
            ];
          },)
      ],
      ),
      body:Text('This is just a test app. Thanks for installing')
      
   );
  }
}

Future<bool> showLogoutDialog(BuildContext context){
  return showDialog<bool>(context: context,
   builder: (context) {
     return AlertDialog(
      title: const Text('Sign out'),
      content: const Text('Are you sure you want to logout?'),
      actions: [
        TextButton(onPressed:() {
          Navigator.of(context).pop(false);
        }, child: const Text('Cancel')),
        TextButton(onPressed:() {
          Navigator.of(context).pop(true);
        }, child: const Text('Logout'))
      ],
     );
   }
   ).then((value) => value ?? false);
}