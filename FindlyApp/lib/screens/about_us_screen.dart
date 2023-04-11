import 'package:findly_app/constants/constants.dart';
import 'package:findly_app/constants/curved_app_bar.dart';
import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  // final userCount;
  // final returnedOrFoundCount;

  const AboutUsScreen({Key? key,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final sizedBoxWidth = size.width*0.33;
    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: CurvedAppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: const [
             Text(
              'About us',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body:SingleChildScrollView(
        child:
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset("assets/findly.png",width: size.width*0.45,height: 200,color: primaryColor,),
                ),
              ],
            ),
          )
        ,
      ),
    );
  }
}
