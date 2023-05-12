import 'dart:io';

import 'package:findly_app/constants/curved_app_bar.dart';
import 'package:findly_app/screens/private_chat/chatMethods.dart';
import 'package:findly_app/screens/private_chat/image_view.dart';
import 'package:findly_app/services/push_notifications_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../constants/constants.dart';
import '../../constants/global_colors.dart';

class PrivateChatScreen extends StatefulWidget {
  final String peerName;
  final String chatroomID;
  final String peerId;

  const PrivateChatScreen(
    this.peerName,
    this.chatroomID, {
    super.key,
    required this.peerId,
  });

  @override
  State<PrivateChatScreen> createState() => _PrivateChatScreenState();
}

class _PrivateChatScreenState extends State<PrivateChatScreen> {
  ChatMethods chatMethods = ChatMethods();
  TextEditingController msgController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  File? imageFile;

  sendMessage() {
    final message = msgController.text.trim();
    final time = DateTime.now().millisecondsSinceEpoch;
    if (msgController.text.isNotEmpty) {
      Map<String, dynamic> msg = {
        "message": message,
        "sender": _auth.currentUser!.uid.toString(),
        "time": time,
        // this will be more helpful for ordering the messages
        "date": DateTime.now(), // to be used for UI details
        "type": "text",
      };
      chatMethods.addChatMessages(widget.chatroomID, msg).then((value) {
        chatMethods.updateLastMessageOfChatroom(
          message,
          widget.chatroomID,
          time,
        );
      });
      PushNotificationController.getUserAndSendPush(msgController.text, widget.peerId,widget.chatroomID);
      msgController.clear();
    }
  }

  StreamBuilder<dynamic> chatMessagesList() {
    String uid = _auth.currentUser!.uid.toString();
    return StreamBuilder(
        stream: chatMethods.getChatMessages(widget.chatroomID),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 80.0),
                  child: ListView.builder(
                      reverse: true,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        return MessageTile(
                          snapshot.data.docs[index]["message"],
                          snapshot.data.docs[index]["sender"] == uid,
                          snapshot.data.docs[index]["type"],
                          DateTime.fromMillisecondsSinceEpoch(
                            snapshot.data.docs[index]["time"],
                          ),
                        );
                      }),
                )
              : const Center(child: CircularProgressIndicator());
        });
  }

  Future pickImage(String source) async {
    ImagePicker picker = ImagePicker();
    if (source == "gallery") {
      await picker.pickImage(source: ImageSource.gallery).then((xFile) async {
        if (xFile != null) {
          CroppedFile? croppedFile = await ImageCropper().cropImage(
            sourcePath: xFile.path,
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ],
            uiSettings: [
              AndroidUiSettings(
                  statusBarColor: primaryColor,
                  activeControlsWidgetColor: Colors.white,
                  toolbarTitle: 'Cropper',
                  toolbarColor: primaryColor,
                  toolbarWidgetColor: Colors.white,
                  initAspectRatio: CropAspectRatioPreset.original,
                  lockAspectRatio: false),

            ],
          );
          imageFile = File(croppedFile!.path);
          uploadImage();
        }
      });
    } else {
      await picker.pickImage(source: ImageSource.camera).then((xFile) async {
        if (xFile != null) {
          imageFile = File(xFile.path);
          uploadImage();
        }
      });
    }
  }

  Future uploadImage() async {
    String fileName = const Uuid().v1();
    int status = 1;
    final time = DateTime.now().millisecondsSinceEpoch;
    Map<String, dynamic> msg = {
      "message": "Image",
      "sender": _auth.currentUser!.uid.toString(),
      "time": time, // this will be more helpful for ordering the messages
      "date": DateTime.now(), // to be used for UI details
      "type": "img",
    };
    await chatMethods.addChatImageMessages(widget.chatroomID, fileName, msg);

    var ref = FirebaseStorage.instance.ref().child("images").child("$fileName.jpg");
    var uploadTask = await ref.putFile(imageFile!).catchError((error) async {
      status = 0;
    });

    if (status == 1) {
      String imageUrl = await uploadTask.ref.getDownloadURL();
      chatMethods.updateChatImageMessageField(widget.chatroomID, fileName, imageUrl);
      chatMethods.updateLastMessageOfChatroom("Image", widget.chatroomID, time);
      debugPrint(imageUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      extendBodyBehindAppBar: true,
      appBar: CurvedAppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
        ),
        title: Text(
          widget.peerName,
        ),
      ),
      body: Container(
        color: scaffoldColor,
        child: Stack(
          children: [
            chatMessagesList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: msgController,
                        style: const TextStyle(
                          color: primaryColor,
                        ),
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              icon: const Icon(
                                Icons.photo,
                                color: primaryColor,
                              ),
                              onPressed: () {
                                showModalBottomSheet<void>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      height: 200,
                                      color: Colors.grey[200],
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(9.0),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  const Text(
                                                    'Gallery',
                                                    style: TextStyle(
                                                      fontSize: 22,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 100,
                                                    width: 100,
                                                    child: IconButton(
                                                        onPressed: () {
                                                          String source = "gallery";
                                                          pickImage(source);
                                                          Navigator.pop(context);
                                                        },
                                                        icon: const SizedBox(
                                                          height: 100,
                                                          width: 100,
                                                          child: CircleAvatar(
                                                            child: Icon(
                                                              Icons
                                                                  .photo_size_select_actual_outlined,
                                                              color: Colors.white,
                                                              size: 50,
                                                            ),
                                                          ),
                                                        )),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  'Camera',
                                                  style: TextStyle(
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 100,
                                                  width: 100,
                                                  child: IconButton(
                                                    onPressed: () {
                                                      String source = "camera";
                                                      pickImage(source);
                                                      Navigator.pop(context);
                                                    },
                                                    icon: const SizedBox(
                                                      height: 100,
                                                      width: 100,
                                                      child: CircleAvatar(
                                                        child: Icon(
                                                          Icons.camera_alt_outlined,
                                                          color: Colors.white,
                                                          size: 50,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }),
                          hintText: "Send a message",
                          hintStyle: const TextStyle(color: primaryColor),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        sendMessage();
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        padding: const EdgeInsets.all(12),
                        child: Image.asset("assets/send.png"),
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
  final String type;
  final DateTime time;

  const MessageTile(
    this.message,
    this.isSentByMe,
    this.type,
    this.time, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return type == "text"
        ? Container(
            padding: EdgeInsets.only(left: isSentByMe ? 64 : 18, right: isSentByMe ? 18 : 64),
            margin: const EdgeInsets.symmetric(vertical: 8),
            width: MediaQuery.of(context).size.width,
            alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: isSentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isSentByMe
                            ? [
                                GlobalColors.mainColor,
                                Colors.blue,
                              ]
                            : [
                                const Color(0xff424248),
                                const Color(0xff393a3d),
                              ],
                      ),
                      borderRadius: isSentByMe
                          ? const BorderRadius.only(
                              topLeft: Radius.circular(23),
                              topRight: Radius.circular(23),
                              bottomLeft: Radius.circular(23),
                            )
                          : const BorderRadius.only(
                              topLeft: Radius.circular(23),
                              topRight: Radius.circular(23),
                              bottomRight: Radius.circular(23),
                            )),
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 4.0,
                ),
                Text(
                  "${time.hour}:${time.minute} ${time.day}/${time.month}/${time.year}",
                  style: const TextStyle(
                    fontSize: 10.0,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          )
        : Container(
            // height: MediaQuery.of(context).size.height / 2.5,
            padding: EdgeInsets.only(left: isSentByMe ? 0 : 18, right: isSentByMe ? 18 : 0),
            margin: const EdgeInsets.symmetric(vertical: 8),
            width: MediaQuery.of(context).size.width,
            alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: isSentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: isSentByMe
                                ? [const Color(0xff007EF4), const Color(0xff2A75BC)]
                                : [const Color(0xff424248), const Color(0xff393a3d)]),
                        borderRadius: isSentByMe
                            ? const BorderRadius.only(
                                topLeft: Radius.circular(23),
                                topRight: Radius.circular(23),
                                bottomLeft: Radius.circular(23),
                              )
                            : const BorderRadius.only(
                                topLeft: Radius.circular(23),
                                topRight: Radius.circular(23),
                                bottomRight: Radius.circular(23),
                              )),
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height / 2.5,
                    width: MediaQuery.of(context).size.width / 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: message.isNotEmpty?
                      GestureDetector(
                        child: Image.network(message),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ImageViewScreen(
                                        imageUrl: message,
                                      )));
                        },
                      )
                          :
                          const Center(
                            child: SizedBox(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(color: Colors.white,),
                            ),
                          ),
                    )),
                const SizedBox(
                  height: 4.0,
                ),
                Text(
                  "${time.hour}:${time.minute} ${time.day}/${time.month}/${time.year}",
                  style: const TextStyle(
                    fontSize: 10.0,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          );
  }
}
