import 'package:findly_app/screens/widgets/wide_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:password_field_validator/password_field_validator.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../constants/constants.dart';
import '../services/global_methods.dart';

class ChangePasswordScreen extends StatefulWidget {
  static const String screenRoute = 'change_password_screen';

  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final changePasswordForm = FormGroup(
    {
      "current_password": FormControl<String>(
        validators: [
          Validators.required,
        ],
      ),
      "new_password": FormControl<String>(
        validators: [
          Validators.required,
          Validators.minLength(8),
          Validators.pattern(regexPassword),
        ],
      ),
      "confirm_new_password": FormControl<String>(),
    },
    validators: [
      Validators.mustMatch(
        "new_password",
        "confirm_new_password",
      ),
    ],
  );

  bool obscureCurrentPassword = true;
  bool obscureNewPassword = true;
  bool obscureConfirmPassword = true;
  late final TextEditingController _passwordTextController = TextEditingController(text: '');

  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      await GlobalMethods.reAuthenticateUser(currentPassword);
      await FirebaseAuth.instance.currentUser?.updatePassword(newPassword);
      await GlobalMethods.showToast(
        "Password has been changed successfully!",
      );
      if (mounted) Navigator.pop(context);
    } catch (error) {
      await GlobalMethods.showToast(
        GlobalMethods.getMessage(error.toString()),
      );
    }
  }
  @override
  void dispose() {
    _passwordTextController.dispose();
    super.dispose();
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
            child: Container(
              margin: const EdgeInsets.only(
                left: 24.0,
                right: 24.0,
              ),
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24.0),
                boxShadow: kElevationToShadow[3],
              ),
              child: ReactiveForm(
                formGroup: changePasswordForm,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Change your password",
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 24),
                    buildTextField(
                      label: "Current Password",
                      formControlName: "current_password",
                      obscureText: obscureCurrentPassword,
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            obscureCurrentPassword = !obscureCurrentPassword;
                          });
                        },
                        child: Icon(
                          obscureCurrentPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    buildTextField(
                      controller: _passwordTextController,
                      label: "New Password",
                      formControlName: "new_password",
                      obscureText: obscureNewPassword,
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            obscureNewPassword = !obscureNewPassword;
                          });
                        },
                        child: Icon(
                          obscureNewPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    buildTextField(
                      label: "Confirm Password",
                      formControlName: "confirm_new_password",
                      obscureText: obscureConfirmPassword,
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            obscureConfirmPassword = !obscureConfirmPassword;
                          });
                        },
                        child: Icon(
                          obscureConfirmPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: PasswordFieldValidator(
                          minLength: 8,
                          uppercaseCharCount: 1,
                          lowercaseCharCount: 1,
                          numericCharCount: 1,
                          specialCharCount: 1,
                          defaultColor: Colors.grey,
                          successColor: Colors.green,
                          failureColor: const Color(0xFFA44237),
                          controller: _passwordTextController),
                    ),
                    const SizedBox(height: 16),
                    ReactiveFormConsumer(
                      builder: (context, formGroup, child) {
                        return WideButton(
                          choice: 1,
                          title: "Update Now!",
                          width: double.infinity,
                          onPressed: formGroup.valid
                              ? () async {
                                  await changePassword(
                                    formGroup.control("current_password").value,
                                    formGroup.control("new_password").value,
                                  );
                                }
                              : null,
                        );
                      },
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.all(16),
                    //   child: PasswordFieldValidator(
                    //       minLength: 8,
                    //       uppercaseCharCount: 1,
                    //       lowercaseCharCount: 1,
                    //       numericCharCount: 1,
                    //       specialCharCount: 1,
                    //       defaultColor: Colors.grey,
                    //       successColor: Colors.green,
                    //       failureColor: const Color(0xFFA44237),
                    //       controller: _passwordTextController),
                    // ),
                    WideButton(
                      choice: 2,
                      title: "Cancel",
                      width: double.infinity,
                      onPressed: () {
                        Navigator.canPop(context)
                            ? Navigator.pop(context)
                            : null;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField({
    required String label,
    required String formControlName,
    Widget? suffixIcon,
    bool obscureText = true,
    TextEditingController? controller,
  }) {
    return ReactiveTextField(
      controller: controller,
      formControlName: formControlName,
      obscureText: obscureText,
      textAlign: TextAlign.start,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: suffixIcon,
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
