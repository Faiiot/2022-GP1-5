import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:findly_app/constants/curved_app_bar.dart';
import 'package:findly_app/screens/messages.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';

class DialogflowChatBotScreen extends StatefulWidget {
  const DialogflowChatBotScreen({super.key});

  @override
  State<DialogflowChatBotScreen> createState() => _DialogflowChatBotScreenState();
}

class _DialogflowChatBotScreenState extends State<DialogflowChatBotScreen> {
  late DialogFlowtter dialogFlowtter;
  final TextEditingController _controller = TextEditingController();

  //the messages will be stored in this list locally
  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    DialogFlowtter.fromFile().then((instance) => dialogFlowtter = instance);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: CurvedAppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text("Findly Chatbot"),
      ),
      body: Column(
        children: [
          if (messages.isEmpty)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Image.asset(
                        "assets/chatbotOutlined.png",
                      ),
                    ),
                    const Flexible(
                      child: Text(
                        "Welcome!\nLet's find your\nitem category",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: MessagesScreen(messages: messages),
            ),
          Container(
            color: const Color(0x95C7FFFF),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: _controller,
                  style: const TextStyle(
                    color: primaryColor,
                  ),
                  decoration: const InputDecoration(
                    hintText: "Talk about your item!",
                    hintStyle: TextStyle(
                      color: primaryColor,
                    ),
                    border: InputBorder.none,
                  ),
                )),
                GestureDetector(
                  onTap: () {
                    sendMessage(_controller.text.trim());
                    _controller.clear();
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
        ],
      ),
    );
  }

  // sendMessages(String text) async {
  //   if (text.isEmpty) {
  //     debugPrint("Message is empty");
  //   } else {
  //     setState(() {
  //       //sending the dialog letter text that the user has written and based on that
  //       //dialog text or dialog flutter is going to send the text
  //       addMessage(Message(text: DialogText(text: [text])), true);
  //     });
  //
  //     //Based on the text I will get a response
  //     DetectIntentResponse response =
  //         await dialogFlowtter.detectIntent(queryInput: QueryInput(text: TextInput(text: text)));
  //     if (response.message == null) return;
  //     //Handle the dialogflow message
  //     setState(() {
  //       addMessage(response.message!);
  //     });
  //   }
  // }

  sendMessage(String text) async {
    if (text.isEmpty) {
      debugPrint('Message is empty');
    } else {
      setState(() {
        addMessage(Message(text: DialogText(text: [text])), true);
      });

      DetectIntentResponse response =
          await dialogFlowtter.detectIntent(queryInput: QueryInput(text: TextInput(text: text)));
      if (response.message == null) return;
      setState(() {
        addMessage(response.message!);
      });
    }
  }

  //to handle Dialogflow messages and add to the list
  addMessage(Message message, [bool isUserMessage = false]) {
    messages.add({'message': message, 'isUserMessage': isUserMessage});
  }
}

