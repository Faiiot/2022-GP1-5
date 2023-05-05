import 'package:findly_app/constants/constants.dart';
import 'package:findly_app/constants/curved_app_bar.dart';
import 'package:findly_app/screens/auth_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 0,
            ),
            child: IntroSlider(
              isShowSkipBtn: true,
              isScrollable: false,
              indicatorConfig: const IndicatorConfig(
                sizeIndicator: 16,
                colorIndicator: Colors.grey,
                colorActiveIndicator: primaryColor,
              ),
              skipButtonStyle: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(
                  primaryColor,
                ),
              ),
              nextButtonStyle: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(
                  primaryColor,
                ),
              ),
              doneButtonStyle: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(
                  Colors.white,
                ),
                backgroundColor: MaterialStateProperty.all<Color>(
                  primaryColor,
                ),
              ),
              listContentConfig: [
                buildContentConfig(
                  image: "lost_or_found.png",
                  text: "Have you ever\nlost or found an item on KSU\ncampus?",
                ),
                buildContentConfig(
                  image: "communicate.png",
                  text: "With Findly you can communicate easier through private chat",
                ),
                buildContentConfig(
                  image: "notification_slide_screen.png",
                  text:
                      "You will be notified whenever someone announces\n in the same category of your item",
                ),
                buildContentConfig(
                    image: "chatbotColored.png",
                    text: "Findly's chatbot will help you select the category to announce your item in"
                ),
              ],
              onSkipPress: () => navigate(context),
              onDonePress: () => navigate(context),
            ),
          ),
          SizedBox(
            height: kToolbarHeight + (WidgetsBinding.instance.window.physicalSize.height * 0.025),
            child: const CurvedAppBar(),
          ),
        ],
      ),
    );
  }

  ContentConfig buildContentConfig({
    required String image,
    required String text,
  }) {
    return ContentConfig(
      centerWidget: Image.asset(
        "assets/$image",
      ),
      widgetDescription: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: primaryColor,
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void navigate(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const AuthHomeScreen(),
      ),
      (route) => false,
    );
  }
}
