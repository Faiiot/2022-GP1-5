
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'adimhomepage.dart';

class editProfile extends StatefulWidget {



  @override
  State<editProfile> createState() => _editProfile();
}
FirebaseAuth _auth = FirebaseAuth.instance;
late TextEditingController _emailTextController= TextEditingController(text:'');
late TextEditingController _passwordlTextController= TextEditingController(text:'');
late TextEditingController _firstNameController= TextEditingController(text:'');
late TextEditingController _lastNameController= TextEditingController(text:'');
late TextEditingController _phonNoController= TextEditingController(text:'');
FocusNode _firstNameFocusNode = FocusNode();
FocusNode _lastNameFocusNode = FocusNode();
FocusNode _emailFocusNode = FocusNode();
FocusNode _passwordFocusNode = FocusNode();
FocusNode _phoneNoFocusNode = FocusNode();


late String Name;

final _eidtformkey = GlobalKey<FormState>();
var dropsownValue="";
class _editProfile extends State<editProfile> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(leading: IconButton(
            onPressed: (){
              User? user = _auth.currentUser;
              String _uid = user!.uid;
              Navigator.pushReplacement(//back button
                  context, MaterialPageRoute(
                builder: (context)=>adminhomepage(userID: _uid,)
                ,)
              );
            },
            icon:Icon(Icons.arrow_back_ios)
        )),
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
                            'Name *',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(

                            maxLength: 50,

                            onFieldSubmitted: (String value) {
                              print(value);
                            },
                            onChanged: (value) {
                              Name = value;
                              print(value);
                            },
                            decoration: InputDecoration(
                              hintText: "Enter your name ",
                              hintStyle: TextStyle(color: Colors.grey),
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
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  borderSide: BorderSide(color: Colors.red)),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'You must fill this field';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20,),
//////////////////////////////////

                          Text(
                            'Email Address *',
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
                                FocusScope.of(context).requestFocus(_firstNameFocusNode),
                            validator: (value){
                              if(value!.isEmpty ){
                                return "Please enter an Email!";}
                              // }else if(GlobalMethods.validateEmail(email: _emailTextController) == false){
                              //   return "Please enter a valid Email!";
                              // }
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
                          Text(
                            'Phone number *',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          ///////////////////////////
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
                            height: 10.0,
                          ),

                        ]))

            )
        ));}}