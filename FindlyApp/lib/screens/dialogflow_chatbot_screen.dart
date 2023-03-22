import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:findly_app/screens/messages.dart';
import 'package:flutter/material.dart';

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
      appBar: AppBar(
        title: const Text("Findly Chatbot"),
      ),
      body: Column(
        children: [
          Expanded(child: MessagesScreen(messages: messages)),
          Container(
            color: const Color(0x95C7FFFF),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: _controller,
                  style: TextStyle(color: Colors.blue[700]),
                  decoration: InputDecoration(
                      hintText: "Talk about your item!",
                      hintStyle: TextStyle(color: Colors.blue[700]),
                      border: InputBorder.none),
                )),
                GestureDetector(
                  onTap: () {
                    sendMessage(_controller.text.trim());
                    _controller.clear();
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
        ],
      ),
    );
  }

  sendMessages(String text) async {
    if (text.isEmpty) {
      debugPrint("Message is empty");
    } else {
      setState(() {
        //sending the dialog letter text that the user has written and based on that
        //dialog text or dialog flutter is going to send the text
        addMessage(Message(text: DialogText(text: [text])), true);
      });

      //Based on the text I will get a response
      DetectIntentResponse response =
          await dialogFlowtter.detectIntent(queryInput: QueryInput(text: TextInput(text: text)));
      if (response.message == null) return;
      //Handle the dialogflow message
      setState(() {
        addMessage(response.message!);
      });
    }
  }

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
