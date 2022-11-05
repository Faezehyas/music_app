import 'dart:convert';

import 'package:ahanghaa/models/enums/profile_screen_state_enum.dart';
import 'package:ahanghaa/providers/auth_provider.dart';
import 'package:ahanghaa/providers/main_provider.dart';
import 'package:ahanghaa/theme/my_theme.dart';
import 'package:ahanghaa/utils/is_email.dart';
import 'package:ahanghaa/utils/show_message.dart';
import 'package:ahanghaa/utils/user_infos.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  var nameController = new TextEditingController();
  var emailController = new TextEditingController();
  var userNameController = new TextEditingController();
  var passwordController = new TextEditingController();
  bool _obscurepass = true;
  IconData _passIcon = Icons.visibility;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Consumer<AuthProvider>(builder: (context, authProvider, _) {
      return Scaffold(
          resizeToAvoidBottomInset: true,
          body: Form(
          key: _formKey,
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Image.asset(
                    'assets/images/sing_up_bg_1.png',
                    width: screenWidth,
                    height: screenHeight * 0.49,
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: screenHeight * 0.2,
                      ),
                      Image.asset(
                        'assets/images/sign_up_bg_2.png',
                        height: screenHeight * 0.74,
                        width: screenWidth,
                        fit: BoxFit.fill,
                      )
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: screenHeight * 0.1 +
                            MediaQuery.of(context).padding.top,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/login_logo_2.png',
                            height: screenHeight * 0.05,
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
                          controller: nameController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Name',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: screenHeight * 0.02),
                        child: SizedBox(
                          width: screenWidth * 0.75,
                          child: TextFormField(
                            controller: userNameController,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(hintText: 'Username'),
                            validator: (value) {
                              if (value != null &&
                                  (value.length < 5 ||
                                  value.length > 32)) {
                                return 'Username must between be in 5 to 32 characters';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: screenHeight * 0.02),
                        child: SizedBox(
                          width: screenWidth * 0.75,
                          child: TextFormField(
                            controller: emailController,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(hintText: 'Email'),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  !isEmail(value)) {
                                return 'Please enter valid email';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: screenHeight * 0.02),
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
                              if (_formKey.currentState != null &&
                                  _formKey.currentState!.validate()) {
                                if (!isLoading) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  await authProvider.signUp(
                                      context,
                                      nameController.text,
                                      userNameController.text,
                                      emailController.text,
                                      passwordController.text);
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              }
                            },
                            child: !isLoading
                                ? Text('Sign Up')
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
                            'Do you have account?',
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(
                            width: screenHeight * 0.05,
                          ),
                          InkWell(
                    highlightColor: Colors.transparent.withOpacity(0),
                    splashColor: Colors.transparent.withOpacity(0),
                            onTap: () {
                              authProvider.changeProfileScreen(
                                  ProfileScreenStateEnum.Login);
                            },
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                  color: MyTheme.instance.colors.colorSecondary,
                                  fontSize: 16),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 24,),
                    ],
                  )
                ],
              ),
            ),
          ));
    });
  }
}
