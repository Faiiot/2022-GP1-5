import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findly_app/screens/add_announcement.dart';
import 'package:findly_app/screens/widgets/announcements_widget.dart';
import 'package:findly_app/screens/widgets/drawer_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const String screenRoute = 'home_screen';
  final String userID;


  const HomeScreen({required this.userID,});


  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  String firstName="";

  //navigation bar items index
  int _currentIndex = 0;



  @override
  void initState() {
    super.initState();

    getUserName();


  }

  void getUserName() async{
    _isLoading = true;



    try {//Here we will fetch the users First name from the DB

      final DocumentSnapshot userDoc =
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userID)// widget.userID is used because the var is defined outside the state class but under statefulwidget class
          .get();

      if(userDoc == null){
               return;
      } else{

        setState(() {
        firstName = userDoc.get('firstName');


        });
        User? user = _auth.currentUser;
        String _uid = user!.uid;

      }
    }catch(error){
      print(error);
    }finally{
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(userName: firstName,),
      backgroundColor: Color(0xFFE4ECF4),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: Builder(
          builder: (ctx){
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: (){
                Scaffold.of(ctx).openDrawer();
              },
            );
          },
        ),
        title: Text("Findly", textAlign: TextAlign.center,),
        actions: [
          IconButton(
      icon: Icon(Icons.filter_alt_rounded),
            onPressed: (){
        print("Log Out!");
            },)
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        //get the content of the announcement collection from DB
        stream:FirebaseFirestore.instance.collection('announcement').snapshots() ,
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          }else if (snapshot.connectionState == ConnectionState.active){
            if(snapshot.data!.docs.isNotEmpty){
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context,int index){
                    return Announcement(
                      //snapshot.data!.docs is a list of the announcements
                      //by pointing to the index of a specific announcement and fetching info
                      announcementID:snapshot.data!.docs[index]['announcementID'] ,
                      itemName: snapshot.data!.docs[index]['itemName'],
                      announcementType: snapshot.data!.docs[index]['announcementType'],
                      itemCategory: snapshot.data!.docs[index]['itemCategory'],
                      postDate: snapshot.data!.docs[index]['annoucementDate'],
                      announcementImg: snapshot.data!.docs[index]['url'],
                      buildingName: snapshot.data!.docs[index]['buildingName'],
                      contactChannel: snapshot.data!.docs[index]['contact'],
                      publisherID: snapshot.data!.docs[index]['publishedBy'],
                      announcementDes: snapshot.data!.docs[index]['announcementDes'],
                    );
                  });
            }else{
              return Center(
                child: Text("No Announcements has been uploaded yet!", style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),),
              );
            }
          }
          return Center(
            child: Text("Something went wrong", ),
          );
        },
      ),




    bottomNavigationBar:
      BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex ,
        showSelectedLabels: true,
        onTap: (value){
          setState(() {
            _currentIndex = value;
            if (_currentIndex == 0){
              Navigator.pushReplacement(
                  context, MaterialPageRoute(
                builder: (context)=>HomeScreen(userID: widget.userID,)
                ,)
              );
            }
            else if(_currentIndex == 1){
              print('Profile Page');
            }
            else if(_currentIndex == 2){
              Navigator.pushReplacement(
                  context, MaterialPageRoute(
                builder: (context)=> AddAnnouncementScreen()
                ,)
              );
            }
            else if(_currentIndex == 3){
              print('Private chat Page');
            }
          });
        },
        // height: 60,
        items: [

          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',



          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',

          ),


          BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'Add',

          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.chat_rounded),
            label: 'Chats',

            )
        ],
      ),

    );
  }
}
