import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findly_app/constants/constants.dart';
import 'package:findly_app/screens/login_screen.dart';
import 'package:findly_app/screens/widgets/my_button.dart';
import 'package:findly_app/services/global_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegistrationScreen extends StatefulWidget {
  static const String screenRoute = 'registration_screen';

  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final TextEditingController _emailTextController = TextEditingController(text: '');
  late final TextEditingController _passwordTextController = TextEditingController(text: '');
  late final TextEditingController _firstNameController = TextEditingController(text: '');
  late final TextEditingController _lastNameController = TextEditingController(text: '');
  late final TextEditingController _phoneNoController = TextEditingController(text: '');
  late final TextEditingController _memberIDController = TextEditingController(text: '');
  final FocusNode _memberIDFocusNode = FocusNode();
  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _phoneNoFocusNode = FocusNode();
  bool _obscureText = true;
  final _signUpFormKey = GlobalKey<FormState>();
  bool _isLoading = false;
  RegExp regexPassword = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*+=%~]).{8,}$');

  @override
  void dispose() {
    //dispose from device memory so its performance isn't affected
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNoController.dispose();
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _phoneNoFocusNode.dispose();
    _memberIDController.dispose();
    _memberIDFocusNode.dispose();
    super.dispose();
  }

  void submitFormOnSignUp() async {
    final isValid = _signUpFormKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      try {
        //Check weather the id exists in university's db
        bool validId = await checkMemberId(id: _memberIDController.text);
        if (!validId) {
          GlobalMethods.showErrorDialog(
            context: context,
            error: "This ID does not exist in KSU database.",
          );
        } else {
          //we must check the users collection has the ID already (user has account already)
          await _auth.createUserWithEmailAndPassword(
            email: _emailTextController.text.toLowerCase().trim(),
            password: _passwordTextController.text.trim(),
          );
          final User? user = _auth.currentUser;
          final uid = user!.uid;
          await FirebaseFirestore.instance.collection('users').doc(uid).set({
            'id': uid,
            'memberID': _memberIDController.text,
            'firstName': _firstNameController.text,
            'LastName': _lastNameController.text,
            'Email': _emailTextController.text.trim(),
            'phoneNo': _phoneNoController.text,
            'createdAt': Timestamp.now(),
            'userAnnouncement': <String>[], // should be deleted
            'chatWith': <String>[], //other users that the current user has chat history with
          });
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
          Fluttertoast.showToast(
            msg: "Account has been created successfully!",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.blueGrey,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        GlobalMethods.showErrorDialog(error: error.toString(), context: context);
        debugPrint("error occurred $error");
      }
    } else {
      debugPrint("form not valid!");
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<bool> checkMemberId({required String id}) async {
    FirebaseFirestore firestore = FirebaseFirestore.instanceFor(
      app: Firebase.app("ksuMembersDatabase"),
    );
    final doc = await firestore.collection('ksuMembers').doc(id).get();
    firestore.terminate();
    return doc.exists;
  }

  void showErrorDialog(error) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              children: const [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.error),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Error occurred"),
                ),
              ],
            ),
            content: Text(
              error,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 20,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: const Text(
                  "OK",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              )
            ],
          );
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
                  child: Form(
                    key: _signUpFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Text(
                            "Sign up",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          focusNode: _memberIDFocusNode,
                          onEditingComplete: () =>
                              FocusScope.of(context).requestFocus(_emailFocusNode),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "ID is required!";
                            }
                            return null;
                          },
                          controller: _memberIDController,
                          textAlign: TextAlign.start,
                          onChanged: (value) {},
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.perm_identity_rounded),
                            hintText: "Enter your ID",
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
                            errorBorder:
                                OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          focusNode: _emailFocusNode,
                          onEditingComplete: () =>
                              FocusScope.of(context).requestFocus(_firstNameFocusNode),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter an Email!";
                            } else if (GlobalMethods.validateEmail(email: _emailTextController) ==
                                false) {
                              return "Please enter a valid Email!";
                            }
                            return null;
                          },
                          controller: _emailTextController,
                          keyboardType: TextInputType.emailAddress,
                          textAlign: TextAlign.start,
                          onChanged: (value) {},
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.mail),
                            labelText: "Email address *",
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
                            errorBorder:
                                OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          focusNode: _firstNameFocusNode,
                          onEditingComplete: () =>
                              FocusScope.of(context).requestFocus(_lastNameFocusNode),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Field can not be empty!";
                            }
                            return null;
                          },
                          controller: _firstNameController,
                          textAlign: TextAlign.start,
                          onChanged: (value) {},
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            labelText: "First name *",
                            hintText: "First name",
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
                            errorBorder:
                                OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          focusNode: _lastNameFocusNode,
                          onEditingComplete: () =>
                              FocusScope.of(context).requestFocus(_phoneNoFocusNode),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Field can not be empty!";
                            }
                            return null;
                          },
                          controller: _lastNameController,
                          textAlign: TextAlign.start,
                          onChanged: (value) {},
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            labelText: "Last name *",
                            hintText: "Last name",
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
                            errorBorder:
                                OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          focusNode: _phoneNoFocusNode,
                          onEditingComplete: () =>
                              FocusScope.of(context).requestFocus(_passwordFocusNode),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Field can not be empty!";
                            } else if (value.length < 10 || value.length > 14) {
                              return "Can't be less than 10 or more than 14 digits!";
                            }
                            return null;
                          },
                          controller: _phoneNoController,
                          keyboardType: TextInputType.phone,
                          textAlign: TextAlign.start,
                          onChanged: (value) {},
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.phone),
                            labelText: "Phone number *",
                            hintText: "Phone number",
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
                            errorBorder:
                                OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.done,
                          focusNode: _passwordFocusNode,
                          onEditingComplete: submitFormOnSignUp,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "You did not enter a password!";
                            } else if (value.length < 8) {
                              return "Your password is less than 8 characters!";
                            } else if (!regexPassword.hasMatch(value)) {
                              return "Password does not match the conditions";
                            }
                            return null;
                          },
                          keyboardType: TextInputType.visiblePassword,
                          controller: _passwordTextController,
                          obscureText: _obscureText,
                          textAlign: TextAlign.start,
                          onChanged: (value) {},
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              child: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
                            ),
                            labelText: "Password *",
                            hintText: "Enter your Password",
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
                            errorBorder:
                                const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        _isLoading
                            ? const Center(
                                child: SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.blue,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : MyButton(
                                color: primaryColor,
                                title: "Sign up!",
                                onPressed: () {
                                  submitFormOnSignUp();
                                },
                              ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ));
                        },
                        child: const Text("Log in!"))
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
