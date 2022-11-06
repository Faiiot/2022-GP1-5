import 'package:findly_app/screens/forgot_password_screen.dart';
import 'package:findly_app/screens/registration_screen.dart';
import 'package:findly_app/screens/widgets/my_button.dart';
import 'package:findly_app/services/global_methods.dart';
import 'package:findly_app/user_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class LoginScreen extends StatefulWidget {
  static const String screenRoute = 'login_screen';


  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
with TickerProviderStateMixin {


  late TextEditingController _emailTextController= TextEditingController(text:'');
  late TextEditingController _passwordlTextController= TextEditingController(text:'');
  FocusNode _passwordFocusNode = FocusNode();
  bool _obsecureText = true;
  final _loginFormKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {//dispose from device memory so its performance isn't affected

    _emailTextController.dispose();
    _passwordlTextController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }



  void submitFormOnLogin() async{
    final isValid = _loginFormKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if(isValid){
      setState(() {
        _isLoading=true;
      });
      try{

        await _auth.signInWithEmailAndPassword(
            email: _emailTextController.text.toLowerCase().trim(),
            password: _passwordlTextController.text.trim());
            Navigator.canPop(context)?Navigator.pop(context):null;
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>UserState(), ));
        Fluttertoast.showToast(
            msg: "You have been logged in successfully!",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.blueGrey,
            textColor: Colors.white,
            fontSize: 16.0,
          timeInSecForIosWeb: 2
        );


      }
      catch(error){
        setState(() {
          _isLoading=false;
        });

        GlobalMethods.showErrorDialog(error: error.toString(), context: context);
      }

    }else {
      print("form not valid!");
    }
    setState(() {
      _isLoading=false;
    });
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return

      Scaffold(
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
              Container(
                height: 200,
                child: Image.asset("assets/FindlyC.png"),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 20),
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
                key:_loginFormKey,
                child: Column(
                children: [
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    onEditingComplete: ()=>
                        FocusScope.of(context).requestFocus(_passwordFocusNode),
                    validator: (value){
                      //we need to edit this
                      if(value!.isEmpty){
                        return "Please enter your Email!";
                      }else if(GlobalMethods.validateEmail(email: _emailTextController)==false){
                        return "Please check the Email format!";
                      }

                      return null;
                    },
                    controller: _emailTextController,
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.start,
                    onChanged: (value){},
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
                          )
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          )
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blueAccent,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          )
                      ),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.red)
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.done,
                    focusNode: _passwordFocusNode,
                    onEditingComplete: submitFormOnLogin,
                    validator: (value){
                      if(value!.isEmpty){
                        return "Please enter a passsword!";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.visiblePassword,
                    controller: _passwordlTextController,
                    obscureText: _obsecureText,
                    textAlign: TextAlign.start,
                    onChanged: (value){
                      //password = value;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: GestureDetector(onTap:(){
                        setState(() {
                          _obsecureText =! _obsecureText;
                        });
                      } ,
                        child:Icon(_obsecureText? Icons.visibility: Icons.visibility_off),
                      ),
                      hintText: "Enter your Password",
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          )
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          )
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blueAccent,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          )
                      ),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.red)
                      ),
                    ),
                  ),
                ],
              ),),

              SizedBox(
                height: 15,
              ),
              _isLoading?
              Center(
                child: Container
                  (width:30,
                  height:30,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.blue,
                    color: Colors.white,
                  ),
                ),
              )
              :MyButton(
                  color: Colors.blue[700]!,
                  title: "Log in",
                  onPressed: (){
                    submitFormOnLogin();
                  }),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?"
                  ),
                  TextButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context)=>RegistrationScreen()
                          ,)
                        );
                      },
                      child: Text("Sign up now!")
                  ),
                ],
              ),
              //SizedBox(
               // height: 10,
             // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      "Forgot your password?"
                  ),
                  TextButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context)=>ForgotPasswordScreen()
                          ,)
                        );
                      },
                      child: Text("Reset it now!")
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
