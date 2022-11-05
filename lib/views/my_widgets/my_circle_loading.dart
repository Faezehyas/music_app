import 'package:ahanghaa/theme/my_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget MyCircleLoading() => Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: SizedBox(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      MyTheme.instance.colors.colorSecondary),
                                  backgroundColor:
                                      MyTheme.instance.colors.colorPrimary,
                                ),
                              ),
                            ),
                          );