import 'dart:convert';

import 'package:ahanghaa/models/enums/profile_screen_state_enum.dart';
import 'package:ahanghaa/providers/auth_provider.dart';
import 'package:ahanghaa/providers/main_provider.dart';
import 'package:ahanghaa/theme/my_theme.dart';
import 'package:ahanghaa/utils/is_email.dart';
import 'package:ahanghaa/utils/show_message.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  var emailController = new TextEditingController();
  var passwordController = new TextEditingController();
  bool isLoading = false;
  bool _obscurepass = true;
  IconData _passIcon = Icons.visibility;
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Consumer<AuthProvider>(builder: (context, authProvider, _) {
      return Scaffold(
          body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Stack(
            children: [
              Image.asset(
                'assets/images/login_bg_1.png',
                width: screenWidth,
                height: screenHeight * 0.3,
              ),
              Column(
                children: [
                  SizedBox(
                    height: screenHeight * 0.2,
                  ),
                  Image.asset(
                    'assets/images/login_bg_2.png',
                    height: screenHeight * 0.74,
                    width: screenWidth,
                    fit: BoxFit.fill,
                  )
                ],
              ),
              Column(
                children: [
                  SizedBox(
                    height: screenHeight * 0.15 +
                        MediaQuery.of(context).padding.top,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/login_logo.png',
                        height: screenHeight * 0.12,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenHeight * 0.015,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Ahanghaa',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  SizedBox(
                    height: screenHeight * 0.05,
                  ),
                  SizedBox(
                    width: screenWidth * 0.75,
                    child: TextFormField(
                      controller: emailController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(hintText: 'Email'),
                      validator: (value) {
                        if (value == null || value.isEmpty || !isEmail(value)) {
                          return 'Please enter valid email';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: screenHeight * 0.02,
                    ),
                    child: SizedBox(
                      width: screenWidth * 0.75,
                      child: TextFormField(
                        controller: passwordController,
                        style: TextStyle(color: Colors.white),
                        obscureText: _obscurepass,
                        decoration: InputDecoration(
                            hintText: 'Password',
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _obscurepass = !_obscurepass;
                                    _passIcon = _obscurepass
                                        ? Icons.visibility_off
                                        : Icons.visibility;
                                  });
                                },
                                icon: Icon(_passIcon))),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length < 8) {
                            return 'password must be at least 8 characters';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.05,
                  ),
                  SizedBox(
                      width: screenWidth * 0.75,
                      height: screenHeight * 0.06,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (!isLoading) {
                              setState(() {
                                isLoading = true;
                              });
                              await authProvider.signIn(
                                  context,
                                  emailController.text,
                                  passwordController.text);
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        },
                        child: !isLoading
                            ? Text('Sign In')
                            : SizedBox(
                                height: 8,
                                width: 52,
                                child: LoadingIndicator(
                                  indicatorType: Indicator.ballBeat,
                                  colors: [
                                    MyTheme.instance.colors.colorPrimary
                                  ],
                                ),
                              ),
                      )),
                  SizedBox(
                    height: screenHeight * 0.03,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have any account?',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        width: screenHeight * 0.02,
                      ),
                      InkWell(
                        highlightColor: Colors.transparent.withOpacity(0),
                        splashColor: Colors.transparent.withOpacity(0),
                        onTap: () {
                          authProvider.changeProfileScreen(
                              ProfileScreenStateEnum.SignUp);
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                              color: MyTheme.instance.colors.colorSecondary,
                              fontSize: 16),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: screenHeight * 0.015,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Forgot your password?',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        width: screenHeight * 0.02,
                      ),
                      InkWell(
                        highlightColor: Colors.transparent.withOpacity(0),
                        splashColor: Colors.transparent.withOpacity(0),
                        onTap: () {
                          showForgetPasswordDialog(context);
                        },
                        child: Text(
                          'Reset Password',
                          style: TextStyle(
                              color: MyTheme.instance.colors.colorSecondary,
                              fontSize: 16),
                        ),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ));
    });
  }

  void showForgetPasswordDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    TextEditingController emailController = new TextEditingController();
    bool isOtpLoading = false;
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, dialogSetState) {
            return AlertDialog(
              title: Center(
                child: Text(
                  'Password Recovery',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
              backgroundColor: MyTheme.instance.colors.colorPrimary,
              content: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: SizedBox(
                    width: screenWidth * 0.75,
                    child: TextFormField(
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty || !isEmail(value)) {
                          return 'Please enter valid email';
                        }
                        return null;
                      },
                      style: TextStyle(color: Colors.white, fontSize: 12),
                      decoration: InputDecoration(hintText: 'email'),
                    ),
                  ),
                ),
              ),
              actions: [
                InkWell(
                    highlightColor: Colors.transparent.withOpacity(0),
                    splashColor: Colors.transparent.withOpacity(0),
                    onTap: () => Navigator.pop(context),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                            color: MyTheme.instance.colors.colorSecondary),
                      ),
                    )),
                !isOtpLoading
                    ? InkWell(
                        highlightColor: Colors.transparent.withOpacity(0),
                        splashColor: Colors.transparent.withOpacity(0),
                        onTap: () async {
                          if (!isOtpLoading) {
                            if (_formKey.currentState!.validate()) {
                              dialogSetState(() {
                                isOtpLoading = true;
                              });
                              if (await context
                                  .read<AuthProvider>()
                                  .forgetPassword(
                                      context, emailController.text)) {
                                Navigator.pop(context);
                                showResetPasswordDialog(
                                    context, emailController.text);
                              }
                            }
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Send OTP',
                            style: TextStyle(
                                color: MyTheme.instance.colors.colorSecondary),
                          ),
                        ))
                    : SizedBox(
                        height: 8,
                        width: 56,
                        child: LoadingIndicator(
                          indicatorType: Indicator.ballBeat,
                          colors: [MyTheme.instance.colors.colorSecondary],
                        ),
                      )
              ],
            );
          });
        });
  }

  void showResetPasswordDialog(BuildContext context, String email) {
    final _formKey = GlobalKey<FormState>();
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    TextEditingController emailController = new TextEditingController();
    TextEditingController otpController = new TextEditingController();
    TextEditingController passwordController = new TextEditingController();
    emailController.text = email;
    bool _obscurepass1 = true;
    IconData _passIcon1 = Icons.visibility;
    bool isOtpLoading = false;
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, dialogSetState) {
            return AlertDialog(
              title: Center(
                child: Text(
                  'Reset Password',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
              backgroundColor: MyTheme.instance.colors.colorPrimary,
              content: Form(
                key: _formKey,
                child: Container(
                  height: 300,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: SizedBox(
                          width: screenWidth * 0.75,
                          child: TextFormField(
                            controller: emailController,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  !isEmail(value)) {
                                return 'Please enter valid email';
                              }
                              return null;
                            },
                            style: TextStyle(color: Colors.white, fontSize: 12),
                            decoration: InputDecoration(hintText: 'email'),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: SizedBox(
                          width: screenWidth * 0.75,
                          child: TextFormField(
                            controller: otpController,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.length != 5) {
                                return 'Please enter valid OTP';
                              }
                              return null;
                            },
                            style: TextStyle(color: Colors.white, fontSize: 12),
                            decoration: InputDecoration(hintText: 'OTP'),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: SizedBox(
                          width: screenWidth * 0.75,
                          child: TextFormField(
                            controller: passwordController,
                            obscureText: _obscurepass1,
                            decoration: InputDecoration(
                                hintText: 'new Password',
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      dialogSetState(() {
                                        _obscurepass1 = !_obscurepass1;
                                        _passIcon1 = _obscurepass1
                                            ? Icons.visibility_off
                                            : Icons.visibility;
                                      });
                                    },
                                    icon: Icon(_passIcon1))),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.length < 8) {
                                return 'password must be at least 8 characters';
                              }
                              return null;
                            },
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                InkWell(
                    highlightColor: Colors.transparent.withOpacity(0),
                    splashColor: Colors.transparent.withOpacity(0),
                    onTap: () => Navigator.pop(context),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                            color: MyTheme.instance.colors.colorSecondary),
                      ),
                    )),
                !isOtpLoading
                    ? InkWell(
                        highlightColor: Colors.transparent.withOpacity(0),
                        splashColor: Colors.transparent.withOpacity(0),
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            dialogSetState((){
                              isOtpLoading = true;
                            });
                            if (await context
                                .read<AuthProvider>()
                                .resetPassword(
                                    context,
                                    emailController.text,
                                    otpController.text,
                                    passwordController.text)) {
                                      Navigator.pop(context);
                              ShowMessage(
                                  'Password reseted successfully', context);
                            }
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Reset Password',
                            style: TextStyle(
                                color: MyTheme.instance.colors.colorSecondary),
                          ),
                        ))
                    : SizedBox(
                        height: 8,
                        width: 56,
                        child: LoadingIndicator(
                          indicatorType: Indicator.ballBeat,
                          colors: [MyTheme.instance.colors.colorSecondary],
                        ),
                      )
              ],
            );
          });
        });
  }
}
