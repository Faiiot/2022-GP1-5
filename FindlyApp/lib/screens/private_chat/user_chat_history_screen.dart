import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findly_app/screens/private_chat/chatMethods.dart';
import 'package:findly_app/screens/private_chat/private_chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserChatHistoryScreen extends StatefulWidget {
  // const UserChatHistoryScreen({Key? key}) : super(key: key);
  final String userID;
  const UserChatHistoryScreen({
    super.key,
    required this.userID,
  });

  @override
  State<UserChatHistoryScreen> createState() => _UserChatHistoryScreenState();
}

class _UserChatHistoryScreenState extends State<UserChatHistoryScreen> {
  ChatMethods chatMethods = new ChatMethods();
  late Stream chatRoomsStream;
  String myName ="";

  Widget ChatRoomsList(){
    return StreamBuilder(
        stream:chatRoomsStream,
        builder: (context, snapshot){
          return snapshot.hasData?
          ListView.builder(
            itemCount: snapshot.data.docs.length,
              itemBuilder: (context,index){
              return ChatRoomsTile(
                snapshot.data.docs[index]["usersNames"]
              .toString().replaceAll("_", "")
              .replaceAll(myName, ""),
                snapshot.data.docs[index]["chatroomID"]
              );
              }
          )
          :
          Center(child: CircularProgressIndicator(),);
        });
  }
  @override
  void initState() {
    chatMethods.getChatRooms(widget.userID).then((value){
      setState(() {
        chatRoomsStream = value;
      });
    });
    chatMethods.getUsername(widget.userID).then((value){
      setState(() {
        myName = value;
      });
      print(myName);
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat History"),
        leading: IconButton(icon: Icon(Icons.arrow_back_ios),onPressed:()=> Navigator.pop(context),),
      ),
      body: ChatRoomsList(),
    );
  }

}

class ChatRoomsTile extends StatelessWidget {
  final String peerName;
  final String chatroomID;
  const ChatRoomsTile(this.peerName,this.chatroomID);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context)=>PrivateChatScreen(chatroomID)));
      },
      child: Container(
        color: Colors.blueGrey[200],
        padding: EdgeInsets.symmetric(horizontal: 24,vertical: 20),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment:Alignment.center ,
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Text("${peerName.substring(0,1).toUpperCase()}",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),),
            ),
            SizedBox(width: 8,),
            Text(peerName, style: TextStyle(
              color: Colors.black,
              fontSize: 17
            ),),
          ],
        ),
      ),
    );
  }
}

