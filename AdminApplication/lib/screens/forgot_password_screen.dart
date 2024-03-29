import 'package:findly_admin/screens/widgets/wide_button.dart';
import 'package:findly_admin/services/global_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../constants/constants.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const String screenRoute = 'forgot_password_screen';

  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> with TickerProviderStateMixin {
  final TextEditingController _forgotPasswordController = TextEditingController(text: '');
  final _ForgotPasswordFormKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    //dispose from device memory so its performance isn't affected
    _forgotPasswordController.dispose();
    super.dispose();
  }

  //Method to send an email to reset the password
  void _forgotPasswordFCT() {
    final isValid = _ForgotPasswordFormKey.currentState!.validate();
    if (isValid){
      setState(() {
        _isLoading = true;
      });
      try{
        final FirebaseAuth auth = FirebaseAuth.instance;
        auth.sendPasswordResetEmail(email: _forgotPasswordController.text.toLowerCase().trim());
        Navigator.of(context).pop();

        //show a message when the email is sent
        GlobalMethods.showToast(
          "An Email has been sent to you!",
        );
      }
      catch(error){
        GlobalMethods.showErrorDialog(error: error.toString(), context: context);
      }
    }else{
      return;
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size.width,
            height: size.height,
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: size.height / 2,
            child: const DecoratedBox(
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24.0),
                  bottomRight: Radius.circular(24.0),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 24.0, right: 24.0),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.0),
                    boxShadow: kElevationToShadow[3],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Reset your password",
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Form(
                        key: _ForgotPasswordFormKey,
                        child: TextFormField(
                          validator: (value){
                            if(value.toString().isEmpty){
                              return "Please enter your email";
                            }
                            if(GlobalMethods.validateEmail(email: _forgotPasswordController)== false)
                            {
                              return "Please enter a valid Email!";
                            }
                          },
                          controller: _forgotPasswordController,
                          keyboardType: TextInputType.emailAddress,
                          textAlign: TextAlign.start,
                          onChanged: (value) {},
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.email),
                            hintText: "Enter your Email",
                            labelText: "Email",
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
                                  color: primaryColor,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                )),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      WideButton(
                        //Reset password by email button
                        choice: 1,
                        title: "Reset Now!",
                        onPressed: () {
                          _forgotPasswordFCT();
                        },
                        width: double.infinity,),
                      WideButton(
                        //Reset password by email button
                        choice: 2,
                        title: "Cancel",
                        onPressed: () {
                          Navigator.canPop(context) ? Navigator.pop(context) : null;
                        },
                        width: double.infinity,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
