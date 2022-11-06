import 'package:findly_app/screens/login_screen.dart';
import 'package:findly_app/screens/widgets/my_button.dart';
import 'package:flutter/material.dart';



class WelcomScreen extends StatefulWidget {
  static const String screenRoute = 'welcom_screen';//static helps me call property without thw whole class

  const WelcomScreen({Key? key}) : super(key: key);

  @override
  State<WelcomScreen> createState() => _WelcomScreenState();
}

class _WelcomScreenState extends State<WelcomScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment:MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                Container(
                  height: 200,
                  child: Image(
                    image: AssetImage("assets/FindlyC.png"),
                  ),
                ),

              ],
            ),
            MyButton(
              color: Colors.blue[500]!,
              title: "Log in",
              onPressed: (){
                // Navigator.pushNamed(context, LoginScreen.screenRoute);
                Navigator.pushReplacement(
                    context, MaterialPageRoute(
                  builder: (context)=>LoginScreen()
                  ,)
                );
              },//Navigator in vid 56
            ),
            MyButton(
                color: Colors.lightBlueAccent[200]!,
                title: "View announcements",
                onPressed: (){},
            ),
          ],
        ),
      ),
    );
  }
}


