import 'package:flutter/material.dart';
import 'package:prj_mobile/models/users.dart';
import 'package:prj_mobile/screens/radio.dart';
import 'package:prj_mobile/screens/auth/authenticate.dart';
import 'package:provider/provider.dart';

//check if user is authenticated or not and display the appropriate page
class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users?>(context);
    if (user == null) {
      return Authenticate();
    } else {
      return RadioApp();
    }
  }
}
