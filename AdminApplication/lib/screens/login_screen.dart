import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findly_admin/screens/widgets/my_button.dart';
import 'package:findly_admin/services/global_methods.dart';
import 'package:findly_admin/user_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  static const String screenRoute = 'login_screen';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  late final TextEditingController _memberIDController = TextEditingController(text: '');
  late final TextEditingController _passwordTextController = TextEditingController(text: '');
  final FocusNode _passwordFocusNode = FocusNode();
  bool _obscureText = true;
  final _loginFormKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    //dispose from device memory so its performance isn't affected
    _memberIDController.dispose();
    _passwordTextController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void submitFormOnLogin() async {
    final isValid = _loginFormKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      debugPrint('before Try -----------------------');
      try {
        QuerySnapshot snap = await FirebaseFirestore.instance
            .collection('admin')
            .where('adminID', isEqualTo: _memberIDController.text.trim())
            .get();
        debugPrint("SNAPSHOT---------------------------------------${snap.docs[0]['Email']}");
        await _auth.signInWithEmailAndPassword(
            email: snap.docs[0]['Email'], password: _passwordTextController.text.trim());
        if (!mounted) return;
        Navigator.canPop(context) ? Navigator.pop(context) : null;
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const UserState(),
        ));
        Fluttertoast.showToast(
            msg: "You have been logged in successfully!",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.blueGrey,
            textColor: Colors.white,
            fontSize: 16.0,
            timeInSecForIosWeb: 2);
      } catch (error) {
        setState(() {
          _isLoading = false;
        });

        GlobalMethods.showErrorDialog(error: error.toString(), context: context);
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 200,
                child: Image.asset("assets/FindlyC.png"),
              ),
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 8, bottom: 20),
                child: Text(
                  "Welcome Back!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Form(
                key: _loginFormKey,
                child: Column(
                  children: [
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () =>
                          FocusScope.of(context).requestFocus(_passwordFocusNode),
                      validator: (value) {
                        //we need to edit this
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
                        errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
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
                          return "Please enter a password!";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.visiblePassword,
                      controller: _passwordTextController,
                      obscureText: _obscureText,
                      textAlign: TextAlign.start,
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
                  ],
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
                      color: Colors.blue[700]!,
                      title: "Log in",
                      onPressed: () {
                        submitFormOnLogin();
                      }),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(
                      onPressed: () {
                        debugPrint('000000000000000000000000000000000');
                      },
                      child: const Text("Sign up now!")),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Forgot your password?"),
                  TextButton(
                      onPressed: () {
                        debugPrint('111111111111111111111111111111111111');
                      },
                      child: const Text("Reset it now!"))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
