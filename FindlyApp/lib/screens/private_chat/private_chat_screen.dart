import 'dart:io';

import 'package:findly_app/screens/private_chat/chatMethods.dart';
import 'package:findly_app/screens/private_chat/image_view.dart';
import 'package:findly_app/services/push_notifications_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class PrivateChatScreen extends StatefulWidget {
  final String chatroomID;
  final String peerId;

  const PrivateChatScreen(
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
    if (msgController.text.isNotEmpty) {
      Map<String, dynamic> msg = {
        "message": msgController.text.trim(),
        "sender": _auth.currentUser!.uid.toString(),
        "time": DateTime.now().millisecondsSinceEpoch,
        // this will be more helpful for ordering the messages
        "date": DateTime.now(), // to be used for UI details
        "type": "text",
      };
      chatMethods.addChatMessages(widget.chatroomID, msg).then((value) {
        chatMethods.updateLastMessageOfChatroom(msgController.text.trim(), widget.chatroomID);
      });
      chatMethods.updateLastMessageOfChatroom(msgController.text.trim(), widget.chatroomID);
      PushNotificationController.getUserAndSendPush(msgController.text, widget.peerId);
      msgController.clear();
    }
  }

  Widget chatMessagesList() {
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
                            snapshot.data.docs[index]["type"]);
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
          // CroppedFile? croppedFile = await ImageCropper().cropImage(
          //   sourcePath: xFile.path,
          //   aspectRatioPresets: [
          //     CropAspectRatioPreset.square,
          //     CropAspectRatioPreset.ratio3x2,
          //     CropAspectRatioPreset.original,
          //     CropAspectRatioPreset.ratio4x3,
          //     CropAspectRatioPreset.ratio16x9
          //   ],
          //   uiSettings: [
          //     AndroidUiSettings(
          //         toolbarTitle: 'Cropper',
          //         toolbarColor: Colors.deepOrange,
          //         toolbarWidgetColor: Colors.white,
          //         initAspectRatio: CropAspectRatioPreset.original,
          //         lockAspectRatio: false),
          //     IOSUiSettings(
          //       title: 'Cropper',
          //     ),
          //     WebUiSettings(
          //       context: context,
          //     ),
          //   ],
          // );
          imageFile = File(xFile.path);
          uploadImage();
        }
      });
    } else {
      await picker.pickImage(source: ImageSource.camera).then((xFile) async {
        if (xFile != null) {
          // CroppedFile? croppedFile = await ImageCropper().cropImage(
          //   sourcePath: xFile.path,
          //   aspectRatioPresets: [
          //     CropAspectRatioPreset.square,
          //     CropAspectRatioPreset.ratio3x2,
          //     CropAspectRatioPreset.original,
          //     CropAspectRatioPreset.ratio4x3,
          //     CropAspectRatioPreset.ratio16x9
          //   ],
          //   uiSettings: [
          //     AndroidUiSettings(
          //         toolbarTitle: 'Cropper',
          //         toolbarColor: Colors.deepOrange,
          //         toolbarWidgetColor: Colors.white,
          //         initAspectRatio: CropAspectRatioPreset.original,
          //         lockAspectRatio: false),
          //     IOSUiSettings(
          //       title: 'Cropper',
          //     ),
          //     WebUiSettings(
          //       context: context,
          //     ),
          //   ],
          // );
          imageFile = File(xFile.path);
          uploadImage();
        }
      });
    }
  }

  Future uploadImage() async {
    String fileName = const Uuid().v1();
    int status = 1;
    Map<String, dynamic> msg = {
      "message": "",
      "sender": _auth.currentUser!.uid.toString(),
      "time": DateTime.now()
          .millisecondsSinceEpoch, // this will be more helpful for ordering the messages
      "date": DateTime.now(), // to be used for UI details
      "type": "img",
    };
    chatMethods.addChatImageMessages(widget.chatroomID, fileName, msg);

    var ref = FirebaseStorage.instance.ref().child("images").child("$fileName.jpg");
    var uploadTask = await ref.putFile(imageFile!).catchError((error) async {
      chatMethods.addChatImageMessages(widget.chatroomID, fileName, msg).delete();
      status = 0;
    });

    if (status == 1) {
      String imageUrl = await uploadTask.ref.getDownloadURL();
      chatMethods.updateChatImageMessageField(widget.chatroomID, fileName, imageUrl);
      debugPrint(imageUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "chat screen",
        ),
      ),
      body: Container(
        color: Colors.lightBlue[50],
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
                      style: TextStyle(color: Colors.blue[700]),
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                              icon: const Icon(Icons.photo),
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
                                                      )),
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
                          hintStyle: TextStyle(color: Colors.blue[700]),
                          border: InputBorder.none),
                    )),
                    GestureDetector(
                      onTap: () {
                        sendMessage();
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [
                              Color(0x36FFFFFF),
                              Color(0x0FFFFFFF),
                            ]),
                            borderRadius: BorderRadius.circular(40)),
                        padding: const EdgeInsets.all(12),
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
  final String type;

  const MessageTile(this.message, this.isSentByMe, this.type, {super.key});

  @override
  Widget build(BuildContext context) {
    return type == "text"
        ? Container(
            padding: EdgeInsets.only(left: isSentByMe ? 0 : 18, right: isSentByMe ? 18 : 0),
            margin: const EdgeInsets.symmetric(vertical: 8),
            width: MediaQuery.of(context).size.width,
            alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                ),
              ),
            ),
          )
        : Container(
            height: MediaQuery.of(context).size.height / 2.5,
            padding: EdgeInsets.only(left: isSentByMe ? 0 : 18, right: isSentByMe ? 18 : 0),
            margin: const EdgeInsets.symmetric(vertical: 8),
            width: MediaQuery.of(context).size.width,
            alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
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
                  child: GestureDetector(
                    child: Image.network(message),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ImageViewScreen(
                                    imageUrl: message,
                                  )));
                    },
                  ),
                )),
          );
  }
}
