import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findly_app/services/global_methods.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({
    Key? key,
    required this.userName,
  }) : super(key: key);

  final String userName;

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  final controller = TextEditingController();
  String itemName = "";
  String categoryName = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.clear),
        ),
        title: const Text("Findly ChatBot"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                buildChatTile(
                  message:
                      "Hello ${widget.userName}! I'm Findly ChatBot and I'm here to help you!\n\n"
                      "What is the item you lost/found?\n"
                      "(E.g. Headphones, Bag, iPad, Phone etc)",
                ),
                if (itemName.isNotEmpty)
                  buildChatTile(
                    isChatBotMessage: false,
                    message: itemName,
                  ),
                if (categoryName.isNotEmpty)
                  buildChatTile(
                    message: "Then you should announce about it in the $categoryName category.",
                  ),
              ],
            ),
          ),
          if (itemName.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: TextField(
                textInputAction: TextInputAction.done,
                controller: controller,
                keyboardType: TextInputType.name,
                textAlign: TextAlign.start,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  hintText: "Enter the item name",
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(24),
                    ),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(24),
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blueAccent,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(24),
                    ),
                  ),
                  suffixIcon: GestureDetector(
                    onTap: controller.text.isNotEmpty
                        ? () async {
                            GlobalMethods.unFocus();
                            setState(() {
                              itemName = controller.text;
                            });
                            categoryName = await getItemCategory(
                                itemName: controller.text.toLowerCase().trimRight());
                            if (mounted) setState(() {});
                          }
                        : null,
                    child: Icon(
                      Icons.send,
                      color: controller.text.isNotEmpty ? Colors.blue : Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildChatTile({
    bool isChatBotMessage = true,
    required String message,
  }) {
    final now = DateTime.now();
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: isChatBotMessage ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        if (isChatBotMessage) ...[
          buildCircleAvatar(Icons.adb),
          const SizedBox(width: 4.0),
        ],
        Flexible(
          child: Container(
            margin: EdgeInsets.only(
              left: isChatBotMessage ? 0 : 28.0,
              right: isChatBotMessage ? 28.0 : 0,
              bottom: 28.0,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 10.0,
            ),
            decoration: BoxDecoration(
              color: isChatBotMessage ? Colors.blue : Colors.white,
              borderRadius: BorderRadius.circular(24.0),
              boxShadow: kElevationToShadow[1],
            ),
            child: RichText(
              text: TextSpan(
                text:
                    "${now.day}-${now.month}-${now.year}  ${now.hour}:${now.minute}:${now.second}",
                style: TextStyle(
                  fontSize: 12.0,
                  color: isChatBotMessage ? Colors.white : Colors.blue,
                  fontWeight: FontWeight.w400,
                ),
                children: <TextSpan>[
                  const TextSpan(text: "\n"),
                  TextSpan(
                    text: message,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: isChatBotMessage ? Colors.white : Colors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (!isChatBotMessage) ...[
          const SizedBox(width: 4.0),
          buildCircleAvatar(Icons.person),
        ],
      ],
    );
  }

  Container buildCircleAvatar(IconData iconData) {
    return Container(
      padding: const EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Icon(
        iconData,
        color: Colors.blue,
        size: 24,
      ),
    );
  }

  Future<String> getItemCategory({
    required String itemName,
  }) async {
    try {
      final QuerySnapshot data =
          await FirebaseFirestore.instance.collection("chatbotCategories").get();
      for (final category in data.docs) {
        final data = category.data() as Map;
        final items = data["items"] as List;
        if (items.any((item) => item.toString().toLowerCase() == itemName)) {
          return category.id;
        }
      }
    } catch (e) {
      return "Others";
    }
    return "Others";
  }
}
