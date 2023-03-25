import 'package:prj_mobile/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:prj_mobile/shared/constants.dart';

class Register extends StatefulWidget {
  //used for switing between register nad signin
  final Function toggleview;

  Register({required this.toggleview});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  //setup firebase auth service
  final AuthService _auth = AuthService();
  //give the form a key to use for valiadation
  final _formkey = GlobalKey<FormState>();

  // text field state
  String email = '';
  String password = '';
  String err = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0.0,
        title: Text('Register'),
        actions: <Widget>[
          ElevatedButton.icon(
            onPressed: () {
              widget.toggleview();
            },
            icon: Icon(Icons.person),
            label: Text("Signin"),
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
                key: _formkey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    TextFormField(
                      decoration:
                          textInputDecoration.copyWith(hintText: 'Email'),
                      validator: (val) =>
                          val!.isEmpty ? "enter an email" : null,
                      onChanged: (val) {
                        setState(() => email = val);
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      decoration:
                          textInputDecoration.copyWith(hintText: 'Password'),
                      obscureText: true,
                      validator: (val) =>
                          val!.length < 6 ? "at least 6 chars" : null,
                      onChanged: (val) {
                        setState(() => password = val);
                      },
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink[400],
                          //onPrimary: Colors.black,
                        ),
                        child: Text(
                          'Register',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          if (_formkey.currentState!.validate()) {
                            //register a user with pass and email in firebase
                            setState(() {
                              loading = true;
                            });
                            dynamic result =
                                await _auth.registerempass(email, password);
                            //if error remove loading widget and print error
                            if (result == null) {
                              setState(() {
                                loading = false;
                                err = 'please supply a valid mail';
                              });
                            }
                          } else {}
                        }),
                    SizedBox(
                      height: 12.0,
                    ),
                    //reserved place to print the error message
                    Text(
                      err,
                      style: TextStyle(color: Colors.red, fontSize: 14.00),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
