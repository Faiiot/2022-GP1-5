
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findly_app/screens/userEidt.dart';
import 'package:findly_app/screens/userProfilePage.dart';
import 'package:findly_app/screens/widgets/my_button.dart';

import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import '../services/global_methods.dart';


class editEmail extends StatefulWidget {
  final String userID;


  // a constuctor tat requires the user ID to return to each user her home screen
  const editEmail({required this.userID,});
  @override
  State<editEmail> createState() => _editEmail();
}


String FirstName ='';
String LastName='';
String ID='';
String email='';
String phoneNo='';
String FullName='';
late TextEditingController _phonNoController= TextEditingController(text:'');
late TextEditingController _emailTextController= TextEditingController(text:'');
final _eidtformkey = GlobalKey<FormState>();
var dropsownValue="";
bool _isLoading = false;

class _editEmail extends State<editEmail> {
  @override


  void cancel(){

    Navigator.pushReplacement(
        context, MaterialPageRoute(
      builder: (context)=>userEdit(userID: widget.userID)
      ,)
    );
  }



  void getUserInfo() async {
    _isLoading = true;
    try {

      final DocumentSnapshot userDoc =
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userID) // widget.userID is used because the var is defined outside the state class but under statefulwidget class
          .get();

      if (userDoc == null) {
        return;
      } else {
        setState(() {
          ID = userDoc.get('memberID');
          FirstName = userDoc.get('firstName');
          LastName = userDoc.get('LastName');
          FullName = FirstName+' '+LastName;
          phoneNo = userDoc.get('phoneNo');
          email = userDoc.get('Email');

        });
        print(ID+''+FullName+''+email);
      }
    }catch(error){
      print(error);
    }finally{
      setState(() {
        _isLoading = false;
      });
    }
  }


  void submitFormOnAdd() async {


    final isValid =  _eidtformkey.currentState!.validate();
    FocusScope.of(context).unfocus();
    bool _isLoading = false;
    if(isValid){



      setState(() {
        _isLoading=true;
      });
      try{
        print('l');

        await FirebaseFirestore.instance.collection('users').doc(widget.userID).update({'Email':_emailTextController.text});
        _emailTextController.text='';
        Navigator.pushReplacement(
            context, MaterialPageRoute(
          builder: (context)=>userEdit(userID: widget.userID)
          ,)
        );

      } catch(error){
        setState(() {
          _isLoading=false;
        });
        //if an error occurs a pop-up message
        //GlobalMethods.showErrorDialog(error: error.toString(), context: context);
        print("error occurred $error");
      }

    }else {
      print("form not valid!");
    }
    setState(() {
      _isLoading=false;
    });

    
  }



  Widget build(BuildContext context) {



    FocusNode _emailFocusNode = FocusNode();
    FocusNode _phoneNoFocusNode = FocusNode();

    RegExp ksuEmailRegEx = new RegExp(r'^([a-z\d\._]+)@ksu.edu.sa$',
        multiLine: false,
        caseSensitive: false);
    RegExp ksuStudentEmail = new RegExp(r'^4[\d]{8}@student.ksu.edu.sa$',
        multiLine: false,
        caseSensitive: false);
    RegExp studentID = RegExp(r'^4([\d]){9}$');

    void dispose() {//dispose from device memory so its performance isn't affected

      _emailTextController.dispose();
      _phonNoController.dispose();
      _emailFocusNode.dispose();
      _phoneNoFocusNode.dispose();


      super.dispose();
    }

    return Scaffold(
        appBar: AppBar( centerTitle: true,title:  Text('Update Email'),
            leading: IconButton(
    onPressed: (){

    Navigator.pushReplacement(//back button
    context, MaterialPageRoute(
    builder: (context)=>userEdit(userID: widget.userID))
    );
    },
    icon:Icon(Icons.account_circle_outlined,color: Colors.blue,))),
        body: Form( key: _eidtformkey,
            child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          //Announcement type

                          Text(
                            ' Email *',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            textInputAction: TextInputAction.next,

                            focusNode: _emailFocusNode,
                            onEditingComplete: ()=>
                                FocusScope.of(context).requestFocus(),
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
                          SizedBox(height: 20,),



                          MyButton(color: Colors.blue, title: 'Update', onPressed: submitFormOnAdd)
                          , MyButton(color: Colors.blue, title: 'Cancel', onPressed: cancel),
                        ]))

            )
        ));}}


