import 'package:prj_mobile/screens/auth/reset_password.dart';
import 'package:prj_mobile/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:prj_mobile/shared/constants.dart';

class SignIn extends StatefulWidget {
  final Function toggleview;

  SignIn({required this.toggleview});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  //form info
  String email = '';
  String password = '';
  bool loading = false;
  String err = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[800],
        appBar: AppBar(
          backgroundColor: Colors.blueGrey[800],
          elevation: 0.0,
          title: Text('Sign in'),
          actions: <Widget>[
            ElevatedButton.icon(
              onPressed: () => widget.toggleview(),
              icon: Icon(Icons.person),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.blueGrey[800]!),
              ),
              label: Text("Register"),
            ),
          ],
        ),
        //check if the page is loading or not if so display the loading screen
        body: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                //form and form validation section
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
                      ElevatedButton(
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ResetPassword(),
                            ),
                          );
                        },
                      ),
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
