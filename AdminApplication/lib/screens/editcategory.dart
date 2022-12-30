
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findly_admin/screens/adminedit.dart';
import 'package:findly_admin/screens/widgets/my_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
// import 'adimhomepage.dart';

class editcategory extends StatefulWidget {



  @override
  State<editcategory> createState() => _editcategory();
}
late String type;
late String Name;
// late TextEditingController _categoryNameController = TextEditingController(text: '');
final _eidtformkey = GlobalKey<FormState>();
var dropsownValue="";
class _editcategory extends State<editcategory> {
  @override
  void dispose() {
    // _categoryNameController.dispose();
    // super.dispose();
  }
  @override
  void cancel(){

    Navigator.pushReplacement(
        context, MaterialPageRoute(
      builder: (context)=>adminedit()
      ,)
    );
  }
  void submitFormOnAdd() async {


    final isValid =  _eidtformkey.currentState!.validate();
    FocusScope.of(context).unfocus();
    bool _isLoading = false;
    if(isValid){
      final categoryID = Uuid().v4();

      setState(() {
        _isLoading=true;
      });
      try{
        // setState(() {
        //   Name = _categoryNameController.text.trim();
        // });
        await FirebaseFirestore.instance.collection('category').doc(categoryID).set({
        'categoryName':Name});

        Fluttertoast.showToast(
          msg: "Category has been added successfully!",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.blueGrey,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.canPop(context)?Navigator.pop(context):null;
        Navigator.pushReplacement(
            context, MaterialPageRoute(
          builder: (context)=>adminedit()
          ,)
        );


      } catch(error){
       // GlobalMethods.showErrorDialog(error: error.toString(), context: context);
        print("error occurred $error");
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

    return Scaffold(
        appBar: AppBar( centerTitle: true,title:  Text('Add category'),),
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
            ' Name *',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          TextFormField(
            // controller: _categoryNameController,

            maxLength: 50,

            onFieldSubmitted: (String value) {
              setState(() {
                Name = value;
              });
            },

            onChanged: (value) {
              Name = value;
              print(value);
            },
            decoration: InputDecoration(
              hintText: "Enter the name ",
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


MyButton(color: Colors.blue, title: 'Add', onPressed: submitFormOnAdd),
          MyButton(color: Colors.blue, title: 'Cancel', onPressed: cancel),


  ]))

      )
    ));}}