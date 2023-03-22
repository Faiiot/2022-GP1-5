
import 'package:findly_admin/screens/widgets/my_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const String screenRoute = 'forgot_password_screen';

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> with TickerProviderStateMixin {
  late TextEditingController _forgotPasswordController = TextEditingController(text: '');
  bool _isLoading = false;

  @override
  void dispose() {
    //dispose from device memory so its performance isn't affected

    _forgotPasswordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // any code that we want to exec. when the user enter this screen can be implemented here

    super.initState();
  }

  //Method to send an email to reset the password
  void _forgotPasswordFCT() {
    print('_forgotPasswordController :${_forgotPasswordController.text}');
    final FirebaseAuth auth = FirebaseAuth.instance;
    auth.sendPasswordResetEmail(email: _forgotPasswordController.text.toLowerCase().trim());
    Navigator.of(context).pop();

    //show a message when the email is sent
    Fluttertoast.showToast(
      msg: "An Email has been sent to you!",
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Colors.blueGrey,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // leading: IconButton( // back button
        //     onPressed: (){
        //
        //       Navigator.pushReplacement(
        //           context, MaterialPageRoute(
        //         builder: (context)=>LoginScreen()
        //         ,)
        //       );
        //     },
        //     icon:Icon(Icons.arrow_back_ios,color: Colors.blue, )
        // ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 200,
                child: Image.asset("assets/FindlyC.png"),
              ),
              SizedBox(
                height: 20, //use size attribute for responsiveness
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 20),
                child: Text(
                  "Reset your password",
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                controller: _forgotPasswordController,
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.start,
                onChanged: (value) {},
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  hintText: "Enter your Email",
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      )),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      )),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blueAccent,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      )),
                ),
              ),
              MyButton(
                //Reset password by email button
                  color: Colors.blue[700]!,
                  title: "Reset Now!",
                  onPressed: () {
                    _forgotPasswordFCT();
                  }),
              MyButton(
                //Reset password by email button
                  color: Colors.blue[700]!,
                  title: "Cancel",
                  onPressed: () {
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
