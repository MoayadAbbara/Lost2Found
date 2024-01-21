import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gpt/Services/auth_services.dart';
import 'package:gpt/views/add_Item.dart';
import 'package:gpt/views/chat.dart';
import 'package:gpt/views/emailverify.dart';
import 'package:gpt/views/home.dart';
import 'package:gpt/views/item_info.dart';
import 'package:gpt/views/login.dart';
import 'package:gpt/views/messages.dart';
import 'package:gpt/views/nearby_items.dart';
import 'package:gpt/views/register.dart';
import 'package:gpt/views/search.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  return runApp(
    MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: HomePage(),
      routes: {
        '/register': (context) => const RegisterView(),
        '/login': (context) => LoginView(),
        '/home' :(context) => HomePage(),
        '/addItem' :(context) => const addItem(),
        '/info' :(context) => const ItemInfo(),
        '/search' :(context) => const SearchView(),
        '/Nearby' :(context) => const NearbyItems(),
        '/Chat' :(context) => const ChatView(),
        '/Messages' :(context) => const MessagesView()
      }
    )
  );
}

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final AuthService auths = AuthService();
    @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: auths.initialize(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              User? user = auths.currentuser;
              if(user != null)
              {
                if(user.emailVerified) {
                  return const HomeView();
                } else {
                  return const EmailVerifyView();
                }
              }
              else
              {
                return LoginView();
              }
            default:
              return const CircularProgressIndicator();
          }
        },
      );
  }
}