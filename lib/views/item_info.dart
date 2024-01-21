import 'package:flutter/material.dart';
import 'package:gpt/Services/auth_services.dart';
import 'package:gpt/Services/db_service.dart';
import 'package:gpt/models/foundItemsModel.dart';

class ItemInfo extends StatefulWidget {
  const ItemInfo({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _ItemInfoState createState() => _ItemInfoState();
}
class _ItemInfoState extends State<ItemInfo> {
  final _dbs = dbService();
  @override
  Widget build(BuildContext context) {
    final String itemId = ModalRoute.of(context)!.settings.arguments as String;
    // ignore: non_constant_identifier_names
    FoundItemsModel? Item;
    bool isMine;
    ElevatedButton MessageButton = ElevatedButton.icon(
      onPressed: () async {
        Navigator.of(context).pushNamed('/Chat',arguments: Item!.userId);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 30, 30, 30),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        minimumSize: Size(double.infinity, 50,),
      ),
      label: const Text(
        "Send a Message to The Founder",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      icon: Icon(Icons.message),
    );
    ElevatedButton DeleteButton = ElevatedButton.icon(
      onPressed: () async {
        showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Center(child: Text('Delete')),
                  content: const Text('Are You Sure You Want To Delete ? '),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        _dbs.deleteItem(itemId);
                        Navigator.of(context).pushNamed('/home',arguments: Item!.userId);
                        ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar (
                                  content: Text('The Item Has Been Deleted Successfully',style: TextStyle(fontSize: 16),),
                                  backgroundColor: Colors.black,
                                )
                        );
                      },
                      child: const Text('Yes'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('No'),
                    ),
                  ],
                ),
              );
        
        
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 180, 61, 61),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        minimumSize: Size(50, 50,),
      ),
      label: const Text(
        "Delete This Item",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      icon: Icon(Icons.delete),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Info'),
      ),
      body:  SafeArea(
        child: FutureBuilder(
          future: _dbs.getItemWithId(itemId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(),) ;
            } else if (snapshot.hasData){
              Item = snapshot.data;
              isMine = Item!.userId == AuthService().currentuser!.uid;
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        Item!.title,
                        style:const TextStyle(fontSize: 30),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image.network(Item!.photoUrl),
                    ),
                    const SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                const TextSpan(
                                  text: 'Category : ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                                TextSpan(
                                  text: Item!.category,
                                  style:const TextStyle(color: Color.fromARGB(255, 100, 100, 100),fontSize: 17),
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                const TextSpan(
                                  text: 'Description : ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                                TextSpan(
                                  text: Item!.description,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                const TextSpan(
                                  text: 'Notes : ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                                TextSpan(
                                  text: Item!.notes,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Center(
                              child: isMine ?  DeleteButton : MessageButton
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Text('Connection Error or there is no data available');
            }
          },
        ),
      ),
    );
  }
}
