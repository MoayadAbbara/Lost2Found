import 'package:flutter/material.dart';

Widget buildCard(
  String name,
  String imgPath,
  String id,
  context,
) {
  return Padding(
    padding: const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 12.0, right: 0.0),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 3.0,
            blurRadius: 5.0,
          )
        ],
        color: Colors.white,
      ),
      child: Column(
        children: [
          Container(
            height: 150.0,
            width: 140.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(imgPath),
                onError: (exception, stackTrace) {
                  print('Error loading image: $exception');
                  print(stackTrace);
                },
              ),
            ),
          ),
          Text(
            '${name[0].toUpperCase()}${name.substring(1)}',
            style: const TextStyle(
              color: Color(0xFF575E67),
              fontFamily: 'Varela',
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: const Color(0xFFEBEBEB),
              height: 1.0,
            ),
          ),
          const SizedBox(height: 7,),
          InkWell(
            onTap: (){
              Navigator.of(context).pushNamed('/info', arguments: id);
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.content_paste_search,
                  color: Colors.black,
                  size: 16.0,
                ),
                SizedBox(width: 5,),
                Text(
                  'View Details',
                  style: TextStyle(
                    fontFamily: 'Varela',
                    color: Colors.black,
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
