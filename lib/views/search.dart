import 'package:flutter/material.dart';
import 'package:gpt/Services/db_service.dart';
import 'package:gpt/models/foundItemsModel.dart';
import 'package:gpt/views/map.dart';
import 'package:gpt/Consts/Categories.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  late double longitude = 0;
  late double latitude = 0;
  late List<FoundItemsModel>? items;
  String Categori = 'Chose a Category';
  Text buttontext = const Text('Select a Location');
  ButtonStyle mybtn = const ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Colors.black));

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          Padding(
                  padding: const EdgeInsets.fromLTRB(8,20,8,0),
                  child: DropdownButtonFormField(
                    value: Categori,
                    onChanged: (value) {
                      setState(() {
                        Categori = value.toString();
                      });
                    },
                    items: subcategories.map((item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    icon: const Icon(Icons.arrow_drop_down_circle,color: Colors.black,),
                    dropdownColor:const Color.fromARGB(255, 246, 242, 242),
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      prefixIcon: Icon(Icons.category),
                      border: OutlineInputBorder()
                    ),
                  ),
                ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapView(
                      onLocationSelected: (double lat, double lon) {
                        setState(() {
                          latitude = lat;
                          longitude = lon;
                          buttontext = const Text("Location Selected");
                          mybtn = const ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Colors.green));
                        });
                      },
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.location_pin),
              label: buttontext,
              style: mybtn,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: MaterialButton(
              onPressed: () async {
                items = await dbService().listSearchedItem(
                  Categori,
                  latitude,
                  longitude,
                );
                Navigator.of(context).pushNamed('/Nearby', arguments: items);
              },
              height: 50,
              color: const Color.fromARGB(255, 30, 30, 30),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Center(
                child: Text(
                  "Search",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}