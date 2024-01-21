import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:gpt/Services/db_service.dart';
import 'package:gpt/models/messageModel.dart';


class ChatView extends StatefulWidget {
  const ChatView({Key? key}) : super(key: key);

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  String username = 'a';
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    
    // ignore: non_constant_identifier_names
    String ReciverID =
        ModalRoute.of(context)!.settings.arguments as String;
    late final mystream = dbService().getChatMessagesStream(ReciverID);
    return Scaffold(
      backgroundColor: const Color.fromRGBO(240, 238, 238, 1),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
        title: FutureBuilder(
          future: dbService().getUserWithId(ReciverID),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              username = snapshot.data!.username;
              return Text(snapshot.data!.username);
            } else {
              return const Text('Loading');
            }
          },
        ),
        
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<MessageModel>>(
              stream: mystream,
              builder: (context, snapshot) {
                 if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<MessageModel> messages = snapshot.data ?? [];
                        WidgetsBinding.instance.addPostFrameCallback((_) {
        // Scroll to the bottom after the frame has been rendered
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,duration: const Duration(milliseconds: 300),curve: Curves.easeOut);
      });
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      MessageModel message = messages[index];
                      if (index == 0 ||
                          message.timestamp.year != messages[index - 1].timestamp.year ||
                          message.timestamp.month != messages[index - 1].timestamp.month ||
                          message.timestamp.day != messages[index - 1].timestamp.day) {
                        return Column(
                          children: [
                            DateChip(
                              date: DateTime(
                                message.timestamp.year,
                                message.timestamp.month,
                                message.timestamp.day,
                              ),
                            ),
                            _buildMessageWidget(message),
                          ],
                        );
                      } else {
                        return _buildMessageWidget(message);
                      }
                    },
                  );
                }
              },
            ),
          ),
          TextField(
            controller: _messageController,
            decoration: InputDecoration(
              hintText: 'Type a Message',
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: const Color.fromRGBO(255, 255, 255, 1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              contentPadding: const EdgeInsets.all(10),
              suffixIcon: IconButton(
                onPressed: () async{
                  if(_messageController.text.isNotEmpty) {
                    await dbService().SendMessage(ReciverID, _messageController.text);
                  }
                  _messageController.clear();
                  },
                icon: const Icon(Icons.send , color: Colors.grey,),)
            ),
          )
        ],
      ),
    );
  }
  Widget _buildMessageWidget(MessageModel message) {
    // ignore: non_constant_identifier_names
    String? ReciverID = ModalRoute.of(context)?.settings.arguments as String?;
    if (message.senderID == ReciverID) {
      return Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 45,
          ),
          child: Card(
            elevation: 1,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: const Color.fromRGBO(37, 45, 49, 1),
            margin:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 30,
                    top: 5,
                    bottom: 20,
                  ),
                  child: Text(
                    message.message,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                Positioned(
                  bottom: 2,
                  right: 10,
                  child: Text(
                    message.timestamp.minute >= 10
                        ? '${message.timestamp.hour}:${message.timestamp.minute}'
                        : '${message.timestamp.hour}:0${message.timestamp.minute}',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 45,
          ),
          child: Card(
            elevation: 1,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: const Color.fromRGBO(5, 96, 98, 1),
            margin:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 30,
                    top: 5,
                    bottom: 20,
                  ),
                  child: Text(
                    message.message,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                Positioned(
                  bottom: 4,
                  right: 10,
                  child: Row(
                    children: [
                      Text(
                        message.timestamp.minute >= 10
                            ? '${message.timestamp.hour}:${message.timestamp.minute}'
                            : '${message.timestamp.hour}:0${message.timestamp.minute}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white60,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}