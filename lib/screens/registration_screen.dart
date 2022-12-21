import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:findly_app/screens/login_screen.dart';
import 'package:findly_app/screens/widgets/my_button.dart';
import 'package:findly_app/services/global_methods.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:password_field_validator/password_field_validator.dart';



class RegistrationScreen extends StatefulWidget {
  static const String screenRoute = 'registration_screen';
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late TextEditingController _emailTextController= TextEditingController(text:'');
  late TextEditingController _passwordlTextController= TextEditingController(text:'');
  late TextEditingController _firstNameController= TextEditingController(text:'');
  late TextEditingController _lastNameController= TextEditingController(text:'');
  late TextEditingController _phonNoController= TextEditingController(text:'');
  late TextEditingController _memberIDController = TextEditingController(text: '');
  FocusNode _memberIDFocusNode = FocusNode();
  FocusNode _firstNameFocusNode = FocusNode();
  FocusNode _lastNameFocusNode = FocusNode();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();
  FocusNode _phoneNoFocusNode = FocusNode();
  bool _obsecureText = true;
  final _signUpFormKey = GlobalKey<FormState>();
  bool _isLoading = false;
  RegExp regexPassword =
  RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*+=%~]).{8,}$');

  RegExp ksuEmailRegEx = new RegExp(r'^([a-z\d\._]+)@ksu.edu.sa$',
      multiLine: false,
      caseSensitive: false);
  RegExp ksuStudentEmail = new RegExp(r'^4[\d]{8}@student.ksu.edu.sa$',
      multiLine: false,
      caseSensitive: false);
  RegExp studentID = RegExp(r'^4([0-9]){9}$');


  @override
  void dispose() {//dispose from device memory so its performance isn't affected

    _emailTextController.dispose();
    _passwordlTextController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phonNoController.dispose();
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _phoneNoFocusNode.dispose();
    _memberIDController.dispose();
    _memberIDFocusNode.dispose();

    super.dispose();
  }

  // void submitFormOnSignUp() async {
  //   final isValid = _signUpFormKey.currentState!.validate();
  //   FocusScope.of(context).unfocus();
  //   if(isValid){
  //     setState(() {
  //       _isLoading=true;
  //     });
  //     try{
  //       await _auth.createUserWithEmailAndPassword(
  //           email: _emailTextController.text.toLowerCase().trim(),
  //           password: _passwordlTextController.text.trim());
  //       final  User? user = _auth.currentUser;
  //       final _uid = user!.uid;
  //       await FirebaseFirestore.instance.collection('users').doc(_uid).set({
  //             'id': _uid,
  //             'memberID': _memberIDController.text,
  //             'firstName':_firstNameController.text ,
  //             'LastName': _lastNameController.text,
  //             'Email': _emailTextController.text.trim(),
  //             'phoneNo':_phonNoController.text,
  //             'createdAt': Timestamp.now(),
  //             'userAnnouncement':<String>[],
  //       });
  //
  //       // GlobalMethods.addUser();
  //       // Navigator.canPop(context)?Navigator.pop(context):null;
  //       Navigator.pushReplacement(
  //           context, MaterialPageRoute(
  //           builder: (context)=>LoginScreen()));
  //       Fluttertoast.showToast(
  //           msg: "Account has been created successfully!",
  //           toastLength: Toast.LENGTH_SHORT,
  //           backgroundColor: Colors.blueGrey,
  //           textColor: Colors.white,
  //           fontSize: 16.0,
  //
  //       );
  //     } catch(error){
  //       setState(() {
  //         _isLoading=false;
  //       });
  //       GlobalMethods.showErrorDialog(error: error.toString(), context: context);
  //       print("error occured $error");
  //     }
  //
  //   }else {
  //     print("form not valid!");
  //   }
  //   setState(() {
  //     _isLoading=false;
  //   });
  // }
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
            error: "This ID does not exist in our database.",
          );
        } else {
          await _auth.createUserWithEmailAndPassword(
            email: _emailTextController.text.toLowerCase().trim(),
            password: _passwordlTextController.text.trim(),
          );
          final User? user = _auth.currentUser;
          final uid = user!.uid;
          await FirebaseFirestore.instance.collection('users').doc(uid).set({
            'id': uid,
            'memberID': _memberIDController.text,
            'firstName': _firstNameController.text,
            'LastName': _lastNameController.text,
            'Email': _emailTextController.text.trim(),
            'phoneNo': _phonNoController.text,
            'createdAt': Timestamp.now(),
            'userAnnouncement': <String>[],
          });
          // Navigator.canPop(context)?Navigator.pop(context):null;
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>  LoginScreen(),
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

  void showErrorDialog(error){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Row(
              children: [
                Padding(padding: const EdgeInsets.all(8.0),
                child:Icon(Icons.error),
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                  child: Text("Error occured"),
                ),
              ],
            ),
            content: Text(
                error,
            style: TextStyle(
              color: Colors.red,
              fontSize: 20,
            ),
            ),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.canPop(context)?
                        Navigator.pop(context) : null;
                  },
                  child: Text(
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
              Container(
                height: 200,
                child: Image.asset("assets/FindlyC.png"),
              ),
              Form(
                key: _signUpFormKey,
                  child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 20),
                    child: Text(
                      "Find your item or help others do!",
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
                    onEditingComplete: ()=>
                        FocusScope.of(context).requestFocus(_emailFocusNode),
                    validator: (value){
                      if(value!.isEmpty ) {
                        return "ID is required!";
                      }
                      return null;
                    },
                    controller: _memberIDController,
                    // keyboardType: TextInputType.number,
                    textAlign: TextAlign.start,
                    onChanged: (value){},
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.perm_identity_rounded),
                      hintText: "Enter your ID",
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
                    textInputAction: TextInputAction.next,
                    focusNode: _emailFocusNode,
                    onEditingComplete: ()=>
                    FocusScope.of(context).requestFocus(_firstNameFocusNode),
                    validator: (value){
                      if(value!.isEmpty ){
                        return "Please enter an Email!";
                      }else if(GlobalMethods.validateEmail(email: _emailTextController) == false){
                        return "Please enter a valid Email!";
                      }
                      return null;
                    },
                    controller: _emailTextController,
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.start,
                    onChanged: (value){},
                    decoration: InputDecoration(
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
                    textInputAction: TextInputAction.next,
                    focusNode: _firstNameFocusNode,
                    onEditingComplete: ()=>
                        FocusScope.of(context).requestFocus(_lastNameFocusNode),
                    validator: (value){
                      if(value!.isEmpty){
                        return "Field can not be empty!";
                      }
                      return null;
                    },
                    controller: _firstNameController,
                    textAlign: TextAlign.start,
                    onChanged: (value){},
                    decoration: InputDecoration(
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
                    textInputAction: TextInputAction.next,
                    focusNode: _lastNameFocusNode,
                    onEditingComplete: ()=>
                        FocusScope.of(context).requestFocus(_phoneNoFocusNode),
                    validator: (value){
                      if(value!.isEmpty){
                        return "Field can not be empty!";
                      }
                      return null;
                    },
                    controller: _lastNameController,
                    textAlign: TextAlign.start,
                    onChanged: (value){},
                    decoration: InputDecoration(
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
                    textInputAction: TextInputAction.next,
                    focusNode: _phoneNoFocusNode,
                    onEditingComplete: ()=>
                        FocusScope.of(context).requestFocus(_passwordFocusNode),
                    validator: (value){
                      if(value!.isEmpty){
                        return "Field can not be empty!";

                      } else if(value.length<10 || value.length>14 ) {
                        return "Can't be less than 10 or more than 14 digits!";
                      }
                      return null;
                    },
                    controller: _phonNoController,
                    keyboardType: TextInputType.phone,
                    textAlign: TextAlign.start,
                    onChanged: (value){},
                    decoration: InputDecoration(
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
                    onEditingComplete: submitFormOnSignUp,
                    validator: (value){

                      if(value!.isEmpty){
                        return "You did not enter a password!";
                      }else if(value.length<8){
                        return "Your password is less than 8 characters!";
                      }else if(!regexPassword.hasMatch(value)){
                        return "Password does not match the conditions";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.visiblePassword,
                    controller: _passwordlTextController,
                    obscureText: _obsecureText,
                    textAlign: TextAlign.start,
                    onChanged: (value){
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
                      labelText: "Password *",
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
                  Padding(
                      padding: const EdgeInsets.all(15),
                      child: PasswordFieldValidator(
                        minLength: 8,
                        minLengthMessage: "The length at least",
                        uppercaseCharCount: 1,
                        lowercaseCharCount: 1,
                        numericCharCount: 1,
                        specialCharCount: 1,
                        specialCharacterMessage: "Special character (!@#\$&*+=%~)",
                        defaultColor: Colors.grey,
                        successColor: Colors.green,
                        failureColor: Colors.red,
                        controller: _passwordlTextController,
                      )),
                  SizedBox(
                    height: 15,
                  ),
                ],
              )
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
                  : MyButton(
                  color: Colors.blue[700]!,
                  title: "Sign up!",
                  onPressed: (){
                    submitFormOnSignUp();
                  }),
              SizedBox(height: 12,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      "Already have an account?"
                  ),
                  TextButton(
                      onPressed: (){
                        Navigator.pushReplacement(
                            context, MaterialPageRoute(
                          builder: (context)=>LoginScreen()
                          ,)
                        );
                      },
                      child: Text("Log in!")
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
