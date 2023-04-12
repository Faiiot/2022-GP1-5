import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findly_admin/constants/curved_app_bar.dart';
import 'package:findly_admin/screens/change_password_screen.dart';
import 'package:findly_admin/screens/widgets/wide_button.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../constants/constants.dart';
import '../constants/text_styles.dart';
import '../services/global_methods.dart';

class AdminProfilePage extends StatefulWidget {
  final String userID;

  //A constructor that requires the user ID to return to each user her home screen
  const AdminProfilePage({
    super.key,
    required this.userID,
  });

  @override
  State<AdminProfilePage> createState() => AdminProfileState();
}

class AdminProfileState extends State<AdminProfilePage> {
  String id = '';
  String email = '';
  String phoneNo = '';
  String firstName = '';
  String lastName = '';
  String fullName = '';

  final userInfo = FormGroup({
    "email": FormControl<String>(validators: [
      Validators.email,
      Validators.required,
    ]),
    "phone_number": FormControl<String>(
      validators: [
        Validators.required,
        Validators.minLength(10),
        Validators.maxLength(14),
      ],
    ),
  });

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  Future<void> getUserInfo() async {
    try {
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('admin')
          .doc(widget
              .userID) // widget.userID is used because the var is defined outside the state class but under statefulwidget class
          .get();

      setState(() {
        id = userDoc.get('adminID');
        firstName = userDoc.get('firstName');
        fullName = '$firstName $lastName';
        email = userDoc.get('Email');
      });
      debugPrint('$id$fullName$email');
    } catch (error) {
      debugPrint(error.toString());
    } finally {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: CurvedAppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text(
          "Profile",
          style: TextStyles.appBarTitleStyle,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(24.0),
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 16.0,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24.0),
            boxShadow: [
              BoxShadow(
                blurRadius: 7,
                spreadRadius: 5,
                offset: const Offset(0, 4),
                color: Colors.grey.withOpacity(0.3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: scaffoldColor,
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  "assets/user_outlined.png",
                  width: 48,
                  height: 48,
                ),
              ),
              const SizedBox(height: 16.0),
              const Divider(color: scaffoldColor, thickness: 2),
              const SizedBox(height: 24.0),
              const Text(
                "Name",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12.0),
              Text(
                fullName,
                style: const TextStyle(
                  color: primaryColor,
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 24.0,
              ),
              const Text(
                "ID",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12.0),
              Text(
                id,
                style: const TextStyle(
                  fontSize: 16,
                  color: primaryColor,
                ),
              ),
              const SizedBox(
                height: 24.0,
              ),
              const Text(
                "Email",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12.0),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      email,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  // const SizedBox(
                  //   width: 4,
                  // ),
                  // IconButton(
                  //   onPressed: () {
                  //     GlobalMethods.showCustomizedDialogue(
                  //       context: context,
                  //       title: "Update",
                  //       content: ReactiveForm(
                  //         formGroup: userInfo,
                  //         child: buildTextField(
                  //           label: "Email address *",
                  //           prefixIcon: Icons.mail,
                  //           formControlName: "email",
                  //           keyboardType: TextInputType.emailAddress,
                  //         ),
                  //       ),
                  //       mainAction: "Update",
                  //       secondaryAction: "Cancel",
                  //       onPressedMain: () async {
                  //         final bool isInvalidEmail = !userInfo.control("email").valid;
                  //         if (isInvalidEmail) return;
                  //         try {
                  //           await FirebaseFirestore.instance
                  //               .collection('users')
                  //               .doc(widget.userID)
                  //               .update(
                  //             {
                  //               'Email': userInfo.control("email").value,
                  //             },
                  //           );
                  //           await getUserInfo();
                  //           await GlobalMethods.showToast(
                  //             "Email updated successfully",
                  //           );
                  //           if (mounted) Navigator.pop(context);
                  //         } catch (error) {
                  //           GlobalMethods.showErrorDialog(
                  //             context: context,
                  //             error: error.toString(),
                  //           );
                  //         }
                  //       },
                  //       onPressedSecondary: () {
                  //         userInfo.reset();
                  //         Navigator.pop(context);
                  //       },
                  //     );
                  //   },
                  //   icon: const Icon(
                  //     Icons.edit,
                  //     color: primaryColor,
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(
                height: 48,
              ),
              WideButton(
                choice: 1,
                title: "Change Password",
                width: double.infinity,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChangePasswordScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required String label,
    required String formControlName,
    required IconData prefixIcon,
    Map<String, String Function(Object)>? validationMessages,
    TextInputType? keyboardType,
  }) {
    return ReactiveTextField(
      formControlName: formControlName,
      validationMessages: validationMessages,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: Icon(prefixIcon),
        labelText: label,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
            width: 2,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: primaryColor,
            width: 2,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
        ),
      ),
    );
  }
}
