import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findly_app/screens/private_chat/chatMethods.dart';
import 'package:findly_app/screens/private_chat/user_chat_history_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PrivateChatScreen extends StatefulWidget {
  // const PrivateChatScreen({Key? key}) : super(key: key);
  final String chatroomID;
  // String senderID;
  // String receiverID;
  PrivateChatScreen(this.chatroomID,);


  @override
  State<PrivateChatScreen> createState() => _PrivateChatScreenState();
}

class _PrivateChatScreenState extends State<PrivateChatScreen> {
  // String user_id='';
  // String peer_id='';
  // String chat_id='';

  ChatMethods chatMethods = new ChatMethods();
  TextEditingController msgController = new TextEditingController();
  late Stream chatMessagesStream;
  final FirebaseAuth _auth = FirebaseAuth.instance;



  sendMessage(){
    if(msgController.text.isNotEmpty){
      Map<String,dynamic> msg = {
        "message":msgController.text.trim(),
        "sender": _auth.currentUser!.uid.toString(),
        "time":DateTime.now().millisecondsSinceEpoch,
      };
      chatMethods.addChatMessages(widget.chatroomID, msg);
      msgController.clear();
    }

  }
  
  Widget ChatMessagesList (){
    String uid = _auth.currentUser!.uid.toString();
    return StreamBuilder(
        stream:chatMessagesStream,
        builder: (context,snapshot) {
          return snapshot.hasData? ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context,index){
                return MessageTile(snapshot.data.docs[index]["message"],
                    snapshot.data.docs[index]["sender"]== uid);
              })
              :Center(child: CircularProgressIndicator());
        });
  }
  @override
  void initState() {
    chatMethods.getChatMessages(widget.chatroomID).then((value){
      setState(() {
        chatMessagesStream = value;
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("chat screen",),
      // leading: IconButton(
      //   icon: Icon(Icons.arrow_back_ios_new_rounded),
      // onPressed: (){
      //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>UserChatHistoryScreen(userID: _auth.currentUser!.uid.toString())));
      // },
      // ),
      ),
      body: Container(
        color: Colors.lightBlue[50],
        child: Stack(
          children: [
            ChatMessagesList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                        child:TextField(
                          controller: msgController,
                          style: TextStyle(color: Colors.blue[700]),
                          decoration: InputDecoration(
                            hintText: "Send a message",
                            hintStyle: TextStyle(color: Colors.blue[700]),
                            border: InputBorder.none
                          ),
                        )
                    ),
                    GestureDetector(
                      onTap: (){ sendMessage();},
                      child: Container(
                        height: 40,
                          width: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0x36FFFFFF),
                              const Color(0x0FFFFFFF),
                            ]
                          ),
                          borderRadius: BorderRadius.circular(40)
                        ),
                        padding: EdgeInsets.all(12),
                        child: Image.asset("assets/send_message.png"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


}
class MessageTile extends StatelessWidget {
  final String message;
  final bool isSentByMe;
  MessageTile(this.message, this.isSentByMe);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: isSentByMe? 0:18, right: isSentByMe? 18:0),
      margin: EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery.of(context).size.width,
      alignment: isSentByMe? Alignment.centerRight: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24,vertical:16),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors:
          isSentByMe?[
            const Color(0xff007EF4),
            const Color(0xff2A75BC)
          ]: [
            const Color(0xff424248),
            const Color(0xff393a3d)
          ]),
          borderRadius: isSentByMe?
              BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23),
              )
              :
          BorderRadius.only(
            topLeft: Radius.circular(23),
            topRight: Radius.circular(23),
            bottomRight: Radius.circular(23),
          )
        ),
        child: Text(message, style: TextStyle(
          color: Colors.white,
          fontSize: 17,

        ),),
      ),
    );
  }
}

