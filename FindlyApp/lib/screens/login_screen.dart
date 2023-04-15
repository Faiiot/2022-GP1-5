import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findly_app/screens/forgot_password_screen.dart';
import 'package:findly_app/screens/registration_screen.dart';
import 'package:findly_app/screens/widgets/my_button.dart';
import 'package:findly_app/screens/widgets/wide_button.dart';
import 'package:findly_app/services/global_methods.dart';
import 'package:findly_app/user_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';

class LoginScreen extends StatefulWidget {
  static const String screenRoute = 'login_screen';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  //create text controllers to validate user input
  late final TextEditingController _emailTextController =
      TextEditingController(text: '');
  late final TextEditingController _memberIDController =
      TextEditingController(text: '');
  late final TextEditingController _passwordTextController =
      TextEditingController(text: '');
  final FocusNode _passwordFocusNode = FocusNode();
  bool _obscureText = true;
  final _loginFormKey = GlobalKey<FormState>();
  bool _isLoading = false;
  RegExp username = RegExp(r'^[A-Za-z][A-Za-z0-9_]{7,29}$');
  RegExp studentID =  RegExp(r'^4\d{8}');
  //create a Firebase Authentication instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    //dispose from device memory so its performance isn't affected
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _passwordFocusNode.dispose();
    _memberIDController.dispose();
    super.dispose();
  }

// A method to submit user input and authenticate it to log in
  void submitFormOnLogin() async {
    final isValid = _loginFormKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      try {
        QuerySnapshot snap = await FirebaseFirestore.instance
            .collection('users')
            .where('memberID', isEqualTo: _memberIDController.text.trim())
            .get();
        //call the method to log in
        await _auth.signInWithEmailAndPassword(
          email: snap.docs[0]['Email'],
          password: _passwordTextController.text.trim(),
        );
        //pop the page to have a better device performance, then go to UserState service to check on user state (logged in , not logged in)
        if (!mounted) return;
        Navigator.canPop(context) ? Navigator.pop(context) : null;
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const UserState(),
        ));

        //Show a message indicating that user is logged in successfully
        GlobalMethods.showToast(
          "You have been logged in successfully!",
        );
      } // if any errors occur a pop-up message will appear
      catch (error) {
        setState(() {
          _isLoading = false;
        });

        GlobalMethods.showErrorDialog(
          error: error.toString(),
          context: context,
        );
      }
    } else {
      debugPrint("form not valid!");
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
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    left: 24.0,
                    top: 100.0,
                    right: 24.0,
                    bottom: 24.0,
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 24.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.0),
                    boxShadow: kElevationToShadow[3],
                  ),
                  child: Form(
                    key: _loginFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 20),
                          child: Text(
                            "Login",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_passwordFocusNode),
                          validator: (value) {
                            //working on it...
                            if (value!.isEmpty) {
                              return "ID is required!";
                            }
                            else if( !studentID.hasMatch(value) && !username.hasMatch(value) == true){
                              // print(studentID.hasMatch(value).toString()+' : '+username.hasMatch(value).toString());
                              return "Wrong ID format";
                            }

                            return null;
                          },
                          controller: _memberIDController,
                          keyboardType: TextInputType.emailAddress,
                          textAlign: TextAlign.start,
                          onChanged: (value) {},
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.perm_identity_rounded),
                            hintText: "Enter your ID",
                            labelText: "ID",
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
                            errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red)),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.done,
                          focusNode: _passwordFocusNode,
                          onEditingComplete: submitFormOnLogin,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter a passsword!";
                            }
                            return null;
                          },
                          keyboardType: TextInputType.visiblePassword,
                          controller: _passwordTextController,
                          obscureText: _obscureText,
                          textAlign: TextAlign.start,
                          onChanged: (value) {
                            //password = value;
                          },
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              child: Icon(_obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                            ),
                            hintText: "Enter your Password",
                            labelText: "Password",
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 20,
                            ),
                            border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            )),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                )),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blueAccent,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                )),
                            errorBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red)),
                          ),
                        ),

                        const SizedBox(
                          height: 15,
                        ),
                        //if the there are processes loading show an indicator
                        _isLoading
                            ? const Center(
                                child: SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: CircularProgressIndicator(
                                    backgroundColor: primaryColor,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : WideButton(
                                //submission button
                                choice: 1,
                                width: double.infinity,
                                title: "Log in!",
                                onPressed: () {
                                  submitFormOnLogin();
                                }),
                      ],
                    ),
                  ),
                ),
                Row(
                  //sign up button
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegistrationScreen(),
                          ),
                        );
                      },
                      child: const Text("Sign up now!"),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Forgot your password?"),
                    TextButton(
                      //reset password button
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPasswordScreen(),
                          ),
                        );
                      },
                      child: const Text("Reset it now!"),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
