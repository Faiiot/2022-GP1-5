import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findly_app/constants/curved_app_bar.dart';
import 'package:findly_app/screens/private_chat/chatMethods.dart';
import 'package:findly_app/screens/private_chat/private_chat_screen.dart';
import 'package:findly_app/services/global_methods.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';

class UserChatHistoryScreen extends StatefulWidget {
  final String userID;


  const UserChatHistoryScreen({
    super.key,
    required this.userID,
  });

  @override
  State<UserChatHistoryScreen> createState() => _UserChatHistoryScreenState();
}

class _UserChatHistoryScreenState extends State<UserChatHistoryScreen> {
  ChatMethods chatMethods = ChatMethods();
  String myName = "";

  //to load all chat rooms in real time
  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatMethods.getChatRooms(widget.userID),
      builder: (context, snapshot) {
        return snapshot.data!.docs.isNotEmpty
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  List chatRooms = snapshot.data.docs;
                  chatRooms = GlobalMethods.quicksort(chatRooms);
                  return ChatRoomsTile(
                    chatRooms[index]["usersNames"]
                        .toString()
                        .replaceAll("_", "")
                        .replaceAll(myName, ""),
                    chatRooms[index]["chatroomID"],
                    (chatRooms[index]['users'] as List)
                        .where(
                          (element) => element != widget.userID,
                        )
                        .first,
                    chatRooms[index]["lastMessage"],
                    DateTime.fromMillisecondsSinceEpoch(
                            chatRooms[index]["lastMessageTime"])
                        .toString()
                        .substring(0, 16),
                  );
                },
              )
            : const Center(
                child: Text(
                  "No chats yet!",
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 18),
                ),
              );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    myName = await chatMethods.getUsername(widget.userID);
    debugPrint(myName);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: CurvedAppBar(
        title: const Text("Chats"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: chatRoomsList(),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String peerName;
  final String chatroomID;
  final String peerId;
  final String lastMessage;
  final String lastMessageTime;

  const ChatRoomsTile(
    this.peerName,
    this.chatroomID,
    this.peerId,
    this.lastMessage,
    this.lastMessageTime, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PrivateChatScreen(
              peerName,
              chatroomID,
              peerId: peerId,
            ),
          ),
        );
      },
      child: Card(
        elevation: 1,
        child: Container(
          color: primaryColor.withOpacity(0.25),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 20,
          ),
          child: Row(
            children: [
              Container(
                height: 40,
                width: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Text(
                  peerName.substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      peerName,
                      style: const TextStyle(
                        fontSize: 17,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(
                      height: 2.0,
                    ),
                    Text(
                      lastMessage,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(
                      height: 2.0,
                    ),
                    Text(
                      lastMessageTime,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.blueGrey,
                      ),
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
