import 'dart:async';

import 'package:gpt/Services/auth_services.dart';
import 'package:gpt/Services/calculate_services.dart';
import 'package:gpt/exceptions/authexception.dart';
import 'package:gpt/models/UserChatModel.dart';
import 'package:gpt/models/foundItemsModel.dart';
import 'package:gpt/models/messageModel.dart';
import 'package:gpt/models/userModel.dart';
import 'package:firebase_database/firebase_database.dart';

// ignore: camel_case_types
class dbService {
  final _db = FirebaseDatabase.instance.ref();

  Future<void> addUser(UserModel user) async{
    try{
      //await _db.child('User').push().set(user.tojson());
      await _db.child('User').child(user.id!).set(user.tojson());
    }catch(e)
    {
      print('Something Went Wrong$e');
    }
  }

Future<void> addItems(FoundItemsModel item) async {
  try {
    if (item.title.isEmpty || item.category.isEmpty) {
      print('Please fill out all required fields');
    }
    await _db.child('Items').push().set(item.toJson());
  } catch (e) {
    print('Error: $e');
    print('Failed to add item');
  }
}



  Future<UserModel> getUserWithId(String id) async{
    final dataSnapshot = await _db.child("User/$id").once();
    final userdata = dataSnapshot.snapshot.value as Map;
    return UserModel(username: userdata['UserName'], email: userdata['Email']);
  }


  Future<FoundItemsModel> getItemWithId(String id) async{
    final dataSnapshot = await _db.child("Items/$id").once();
    // ignore: non_constant_identifier_names
    final Itemdata = dataSnapshot.snapshot.value as Map;
    FoundItemsModel item = FoundItemsModel.fromSnapshot(Itemdata);
    return item;
  }


Future<List<FoundItemsModel>> listAllItem() async{
  final dataSnapshot = await _db.child('Items').once();
  Map items = dataSnapshot.snapshot.value as Map;
  List<FoundItemsModel> myList = [];
  items.forEach((key, value) {
    Map mp = value as Map;
    FoundItemsModel item = FoundItemsModel.fromSnapshot(mp);
    item.id = key;
    myList.add(item);
  },);
  return myList;
}
Future<List<FoundItemsModel>> ListMyItem() async{
  final dataSnapshot = await _db.child('Items').orderByChild('userId').equalTo(AuthService().currentuser!.uid).once();
  Map myItems = dataSnapshot.snapshot.value as Map;
  List<FoundItemsModel> myList = [];
  myItems.forEach((key, value) {
    Map mp = value as Map;
    FoundItemsModel item = FoundItemsModel.fromSnapshot(mp);
    item.id = key;
    myList.add(item);
  },);
  return myList;
}

Future<List<FoundItemsModel>> listSearchedItem(String category , double latitude , double longitude) async{
  final dataSnapshot = await _db.child('Items').orderByChild('category').equalTo(category).once();
  List<FoundItemsModel> NearbyItems = [];
  if(dataSnapshot.snapshot.value != null)
  {
    Map allItems = dataSnapshot.snapshot.value as Map;
  // ignore: non_constant_identifier_names
  allItems.forEach((key , value){
      double itemLatitude = value['latitude'] as double;
      double itemLongitude = value['longitude'] as double;
      // Calculate distance between two points
      double distance = CalculateServices().calculateDistance(latitude, longitude, itemLatitude, itemLongitude);
      if(distance < 5)
      {
        FoundItemsModel item = FoundItemsModel.fromSnapshot(value as Map);
        item.id = key;
        NearbyItems.add(item);
      }
  });
  }
  return NearbyItems;
}

// ignore: non_constant_identifier_names
Future<void> SendMessage(String ReciverID, String Message) async {
  try {
    // ignore: non_constant_identifier_names
    String SenderID = AuthService().currentuser!.uid;
    DateTime timestamp = DateTime.now();

    MessageModel message = MessageModel(
      senderID: SenderID,
      reciverID: ReciverID,
      message: Message,
      timestamp: timestamp,
    );

    List ids = [SenderID, ReciverID];
    ids.sort();
    String roomID = ids.join('_');
    
    await _db.child('Chats').child(roomID).push().set(message.toJson());
  } catch (e) {
    print("Error sending message: $e");
    // Handle the error as needed (e.g., show an error message to the user)
  }
}

// ignore: non_constant_identifier_names
Stream<List<MessageModel>> getChatMessagesStream(String ReciverID) {
  // ignore: non_constant_identifier_names
  String SenderID = AuthService().currentuser!.uid;
  List ids = [SenderID, ReciverID];
  ids.sort();
  String roomID = ids.join('_');

  // Create a stream controller to handle real-time updates
  StreamController<List<MessageModel>> controller = StreamController();

  // Set up a listener for the chat room
  _db.child('Chats').child(roomID).onValue.listen((event) {
    try {
      // Handle updates when the data changes
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        Map messageMap = snapshot.value as Map;

        List<MessageModel> messages = [];

        messageMap.forEach((key, value) {
          // Convert each message entry to a MessageModel
          MessageModel message = MessageModel.fromMap(value);
          if (message.message != '000000INIT000000') messages.add(message);
        });

        messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));

        // Add the updated list of messages to the stream
        controller.add(messages);
      } else {
        SendMessage(ReciverID, '000000INIT000000');
      }
    } catch (e) {
      print("Error handling chat room update: $e");
      // Handle the error as needed (e.g., show an error message to the user)
    }
  });

  return controller.stream;
}



// Function to get the last message for a given chat room
Future<MessageModel> getLastMessage(String chatRoomID) async {
  final datasnapshot = await _db.child('Chats').child(chatRoomID).orderByKey().limitToLast(1).once();

  if (datasnapshot.snapshot.value != null) {
    Map messageMap = datasnapshot.snapshot.value as Map;
    String messageId = messageMap.keys.first;
    Map messageData = messageMap[messageId] as Map;
    //print(MessageModel.fromMap(messageData).message);
    return MessageModel.fromMap(messageData);
  }
  else
  {
    //edit this
    throw DatabaseGenericException();
  }
}


Future<List<ChatUserModel>> getUserChats() async {
  String currentUserID = AuthService().currentuser!.uid;
  final datasnapshot = await _db.child('Chats').once();
  // ignore: non_constant_identifier_names
  List<ChatUserModel> Recivers = [];

  List<Future> futures = [];

  Map chats = datasnapshot.snapshot.value as Map;
  chats.forEach((key, value) {
    if (key.toString().contains(currentUserID)) {
      List<String> userIdList = key.toString().split('_');
      String reciverID = (userIdList.first == currentUserID)
          ? userIdList.last
          : userIdList.first;

      Future<UserModel> reciverFuture = getUserWithId(reciverID);
      Future<MessageModel> msgFuture = getLastMessage(key.toString());

      futures.add(reciverFuture.then((reciver) async {
        MessageModel msg = await msgFuture;
        Recivers.add(ChatUserModel(
            userId: reciverID,
            username: reciver.username,
            lastMessage: msg.message,
            timestamp: msg.timestamp,));
      }));
    }
  });

  await Future.wait(futures);
  return Recivers;
}

void deleteItem(String itemId) {
  try{
    DatabaseReference FoundItems = _db.child('Items');
    FoundItems.child(itemId).remove();
  } catch(e){
    throw DatabaseGenericException();
  }
}
}