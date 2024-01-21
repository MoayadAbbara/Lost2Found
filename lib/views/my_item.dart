import 'package:flutter/material.dart';
import 'package:gpt/Services/db_service.dart';
import 'package:gpt/models/foundItemsModel.dart';
import 'package:gpt/Components/item_card.dart';

class MyItems extends StatefulWidget {
  const MyItems({Key? key}) : super(key: key);

  @override
  State<MyItems> createState() => _MyItemsState();
}

class _MyItemsState extends State<MyItems> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: dbService().ListMyItem(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          List<FoundItemsModel> itemsList = snapshot.data as List<FoundItemsModel>;
          return Padding(
            padding: const EdgeInsets.only(right: 16,top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Here, You Can See The List Of Items You Found. If You Have Identified The Owner, Please Delete The Respective Item.',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Salsa',
                  ),),
                ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 15.0,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: itemsList.length,
                    itemBuilder: (context, index) {
                      FoundItemsModel item = itemsList[index];
                      return buildCard(
                        item.title,
                        item.photoUrl,
                        item.id,
                        context,
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Center(child: Text('Connection Error or there is no data available'));
        }
      },
    );
  }
}