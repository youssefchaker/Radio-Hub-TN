import 'package:prj_mobile/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:prj_mobile/shared/constants.dart';

class SignIn extends StatefulWidget {
  //used for switing between register nad signin
  final Function toggleview;

  SignIn({required this.toggleview});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  // text field state
  String email = '';
  String password = '';
  bool loading = false;
  String err = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          elevation: 0.0,
          title: Text('Sign in'),
          actions: <Widget>[
            ElevatedButton.icon(
              onPressed: () => widget.toggleview(),
              icon: Icon(Icons.person),
              label: Text("Register"),
            ),
          ],
        ),
        body: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20.0),
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Email'),
                        validator: (val) =>
                            val!.isEmpty ? 'Enter an email' : null,
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Password'),
                        validator: (val) => val!.length < 6
                            ? 'Enter a password 6+ chars long'
                            : null,
                        obscureText: true,
                        onChanged: (val) {
                          setState(() => password = val);
                        },
                      ),
                      SizedBox(height: 20.0),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink[400],
                          ),
                          child: Text(
                            'Sign In',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() => loading = true);
                              dynamic result = await _auth
                                  .signInWithEmailAndPassword(email, password);
                              if (result == null) {
                                setState(() {
                                  loading = false;
                                  err =
                                      'Could not sign in with those credentials';
                                });
                              }
                            }
                          }),
                      SizedBox(height: 12.0),
                      Text(
                        err,
                        style: TextStyle(color: Colors.red, fontSize: 14.0),
                      ),
                    ],
                  ),
                )));
  }
}
