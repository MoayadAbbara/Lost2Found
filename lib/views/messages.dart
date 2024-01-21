import 'package:flutter/material.dart';
import 'package:gpt/Services/db_service.dart';
import 'package:gpt/models/UserChatModel.dart';
import 'package:chat_bubbles/algo/algo.dart';

class MessagesView extends StatefulWidget {
  const MessagesView({super.key});

  @override
  State<MessagesView> createState() => _MessagesViewState();
}

class _MessagesViewState extends State<MessagesView> {
    @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ChatUserModel>>(
        future: dbService().getUserChats(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No chat users available'),
            );
          }else if (snapshot.hasError) {
            return const Center(
              child: Text('Error loading chat users'),
            );
          } else {
            // Sort the list by timestamp in descending order
            snapshot.data!.sort((a, b) => b.timestamp.compareTo(a.timestamp));

            return ListView.builder(
              itemCount: snapshot.data!.length,
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 16),
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                ChatUserModel user = snapshot.data![index];
                return  GestureDetector(
                  onTap: (){
                    Navigator.of(context).pushNamed('/Chat',arguments: user.userId);
                  },
                  child: Container(
                    padding: const EdgeInsets.only(left: 16,right: 16,top: 10,bottom: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              const CircleAvatar(
                    backgroundImage: NetworkImage('https://static.vecteezy.com/system/resources/previews/022/123/337/original/user-icon-profile-icon-account-icon-login-sign-line-vector.jpg'),
                    maxRadius: 25,
                  ),
                              const SizedBox(width: 16,),
                              Expanded(
                                child: Container(
                                  color: Colors.transparent,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(user.username, style: const TextStyle(fontSize: 16),),
                                      const SizedBox(height: 6,),
                                      Text(user.lastMessage,style: TextStyle(fontSize: 13,color: Colors.grey.shade600, fontWeight: FontWeight.normal),),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(Algo.dateChipText(DateTime(
                                user.timestamp.year,
                                user.timestamp.month,
                                user.timestamp.day,
                              )),style: const TextStyle(fontSize: 12,fontWeight: FontWeight.normal),),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      );
  }
}