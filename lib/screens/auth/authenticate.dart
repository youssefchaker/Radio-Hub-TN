import 'package:flutter/material.dart';
import 'package:prj_mobile/screens/auth/register.dart';
import 'package:prj_mobile/screens/auth/sign_in.dart';

//either show signin or register on app bar button click
class Authenticate extends StatefulWidget {

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showsignin = true;
  toggleview() {
    setState(() => showsignin = !showsignin);
  }

  @override
  Widget build(BuildContext context) {
    if (showsignin) {
      return SignIn(toggleview: toggleview);
    } else {
      return Register(toggleview: toggleview);
    }
  }
}
