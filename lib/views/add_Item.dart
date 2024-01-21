import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gpt/Services/auth_services.dart';
import 'package:gpt/Services/db_service.dart';
import 'package:gpt/Services/storage_service.dart';
import 'package:gpt/models/foundItemsModel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gpt/Consts/Categories.dart';
import 'map.dart';

// ignore: camel_case_types
class addItem extends StatefulWidget {
  const addItem({super.key});

  @override
  State<addItem> createState() => _addItemState();
}

// ignore: camel_case_types
class _addItemState extends State<addItem> {
  final _auths = AuthService();
  final _dbs = dbService();
  final _strg = Storage_Service();
  late final User? user;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _notesController = TextEditingController();
  // ignore: non_constant_identifier_names
  double longitude = 0;
  double latitude = 0;
  Text buttontext = const Text('Select a Location');
  ButtonStyle mybtn = const ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Colors.black));
  File? _image;
  String imgurl = "";
  // ignore: non_constant_identifier_names
  String Categori = 'Chose a Category';

  @override
  void initState() {
    user = _auths.currentuser;
    super.initState();
  }

    Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                        imgurl = await _strg.addimg(pickedFile!);
                        setState(() {
                            _image = File(pickedFile.path);
                        });
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    onPressed: ()async{
                      try
                      {
                        _pickImage();
                      } catch(e) {
                        print('Error Happened !! $e');
                      }
                    },
                    icon: const Icon(Icons.add_a_photo_outlined,), 
                    label: const Text('Pick an Image'),
                  ),
                ),
                Container(
                  child: _image == null ?  const Text('No image selected.') : Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.file(_image!),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8,20,8,0),
                  child: TextFormField(
                          autocorrect: false,
                          keyboardType: TextInputType.text,
                          controller: _titleController,
                          decoration: const InputDecoration(
                          labelText: 'Title',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.tag)
                          ),
                        ),
                ),
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
                  padding: const EdgeInsets.fromLTRB(8,20,8,0),
                  child: TextFormField(
                          autocorrect: false,
                          keyboardType: TextInputType.text,
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                          labelText: 'Descriptions',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.description)
                          ),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8,20,8,0),
                  child: TextFormField(
                          autocorrect: false,
                          keyboardType: TextInputType.text,
                          controller: _notesController,
                          decoration: const InputDecoration(
                          labelText: 'Notes',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.abc)
                          ),
                        ),
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MapView(
                            onLocationSelected: (double latitude, double longitude) {
                              this.latitude = latitude;
                              this.longitude = longitude;
                              if(latitude != 0 && longitude != 0)
                              {
                                setState(() {
                                  buttontext = const Text("Location Selected");
                                  mybtn = const ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Colors.green));
                                });
                              }
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
                            onPressed: () async{
                              if(_titleController.text.isEmpty || Categori == 'Chose a Category' || _descriptionController.text.isEmpty || _notesController.text.isEmpty)
                              {
                                ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar (
                                  content: Text('Please Fill Out All Required Fields',style: TextStyle(fontSize: 16),),
                                  backgroundColor: Colors.black,
                                )
                              );
                              }
                              else if(latitude == 0 || longitude == 0)
                              {
                                ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar (
                                  content: Text('Please Select a Location',style: TextStyle(fontSize: 16),),
                                  backgroundColor: Colors.black,
                                )
                              );
                              }
                              else if(imgurl.isEmpty)
                              {
                                ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar (
                                  content: Text('Please Upload a Photo',style: TextStyle(fontSize: 16),),
                                  backgroundColor: Colors.black,
                                )
                              );
                              }
                              else{
                              FoundItemsModel item = FoundItemsModel(title: _titleController.text, category: Categori, photoUrl: imgurl, description: _descriptionController.text, userId: user!.uid, notes: _notesController.text,latitude: latitude,longitude: longitude);
                                await _dbs.addItems(item);
                                // ignore: use_build_context_synchronously
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) => AlertDialog(
                                    title: const Center(child: Text('Done',style: TextStyle(fontWeight: FontWeight.bold),)),
                                    content: Container(
                                      height: 115,
                                      child: const Column(
                                        children: [
                                          Text('Item Added Successfully,Thank You!'),
                                          SizedBox(height: 15,),
                                          Icon(Icons.check_box,color: Colors.green,size: 80,)
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              
                                },
                                height: 50,
                                color: const Color.fromARGB(255, 30, 30, 30),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                            child: const Center(
                              child: Text("Add Item", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                            ),
                          ),
                ),
              ]
              ),
            ),
        )
      );
  }
}