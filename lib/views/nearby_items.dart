import 'package:flutter/material.dart';
import 'package:gpt/models/foundItemsModel.dart';
import 'package:gpt/Components/item_card.dart';

class NearbyItems extends StatefulWidget {
  const NearbyItems({super.key});

  @override
  State<NearbyItems> createState() => _NearbyItemsState();
}

class _NearbyItemsState extends State<NearbyItems> {  
  @override
  Widget build(BuildContext context) {
    List<FoundItemsModel> itemsList = ModalRoute.of(context)!.settings.arguments as List<FoundItemsModel>;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Found Items'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: const Color(0xFFFCFAF8),
      body: itemsList.isNotEmpty ? ListView(
        children: <Widget>[
          const SizedBox(height: 15.0),
          Container(
            padding: const EdgeInsets.only(right: 15.0),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: GridView.count(
              crossAxisCount: 2,
              primary: false,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 15.0,
              childAspectRatio: 0.8,
              children: itemsList.map((item) {
                return buildCard(
                  item.title,
                  item.photoUrl,
                  item.id,
                  context,
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 15.0),
        ],
      ) : Container(
        width: double.infinity,
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error,size: 95,),
            SizedBox(height: 20,),
            Text('No Item Found',
            style: TextStyle(fontSize: 30),
            ),
          ],
        ),
      )
    );
  }
}


