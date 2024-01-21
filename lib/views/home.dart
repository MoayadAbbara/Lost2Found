import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gpt/Services/auth_services.dart';
import 'package:gpt/views/add_Item.dart';
import 'package:gpt/views/messages.dart';
import 'package:gpt/views/my_Item.dart';
import 'package:gpt/views/search.dart';
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late User? cuser;
  late AuthService auths;

  @override
  void initState() {
    auths = AuthService();
    cuser = auths.currentuser;
    super.initState();
  }

@override
Widget build(BuildContext context) {
  return DefaultTabController(
    initialIndex: 0,
    length: 4,
    child: Scaffold(
      appBar: AppBar(
        title: const Text('Lost2Found',style: TextStyle(fontFamily: 'Tekutur',fontSize: 40)),
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: [
          IconButton(onPressed: (){
            showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Center(child: Text('Sign Out')),
                  content: const Text('Are You Sure You Want To Sign Out?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'OK'),
                      child: const Text('No'),
                    ),
                    TextButton(
                      onPressed: () {
                        auths.logout();
                        Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
                      },
                      child: const Text('Yes'),
                    ),
                  ],
                ),
              );
          },
          icon: const Icon(Icons.logout))
        ],
        bottom: const TabBar(
          tabs: 
          [
            Tab(
              icon: Icon(Icons.add),
              text: 'Add Item',
            ),
            Tab(
              icon: Icon(Icons.search),
              text: 'Search',
            ),
            Tab(
              icon: Icon(Icons.message),
              text: 'Message',
            ),
            Tab(
              icon: Icon(Icons.account_box),
              text: 'My Items',
            ),
          ]
        ),
      ),
      body: const TabBarView(children: [
        addItem(),
        SearchView(),
        MessagesView(),
        MyItems(),
      ]
      ),
    ),
  );
}
}