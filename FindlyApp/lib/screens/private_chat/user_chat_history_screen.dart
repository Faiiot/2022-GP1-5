import 'package:findly_app/screens/private_chat/chatMethods.dart';
import 'package:findly_app/screens/private_chat/private_chat_screen.dart';
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

  Widget chatRoomsList() {
    return StreamBuilder(
        stream: chatMethods.getChatRooms(widget.userID),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return ChatRoomsTile(
                        snapshot.data.docs[index]["usersNames"]
                            .toString()
                            .replaceAll("_", "")
                            .replaceAll(myName, ""),
                        snapshot.data.docs[index]["chatroomID"],
                        (snapshot.data.docs[index]['users'] as List)
                            .where((element) => element != widget.userID)
                            .first);
                  })
              : const Center(
                  child: CircularProgressIndicator(),
                );
        });
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
      appBar: AppBar(
        title: const Text("Chat History"),
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

  const ChatRoomsTile(this.peerName, this.chatroomID, this.peerId, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PrivateChatScreen(
                      chatroomID,
                      peerId: peerId,
                    )));
      },
      child: Container(
        color: Colors.blueGrey[200],
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Text(
                peerName.substring(0, 1).toUpperCase(),
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              peerName,
              style: const TextStyle(color: Colors.black, fontSize: 17),
            ),
          ],
        ),
      ),
    );
  }
}
