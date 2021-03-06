import 'package:CrypSim/all%20ui%20navigator/aboutus.dart';
import 'package:CrypSim/screens/authentication/sign_in.dart';
import 'package:CrypSim/services/database/auth.dart';
import 'package:CrypSim/services/database/crypto_portfolio_database.dart';
import 'package:CrypSim/shared/constants.dart';
import 'package:CrypSim/shared/loading.dart';
import 'package:CrypSim/tabs/bottom_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  // User Form Inputs.
  String email = '';
  String password = '';
  String username = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? SafeArea(
            child: Loading(),
          )
        : SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: kMediumGrey,
              body: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Register For',
                        style: TextStyle(
                          color: Colors.blueGrey[100],
                          fontFamily: 'OpenSans',
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      kAppLogoName,
                      SizedBox(height: 50.0),
                      Container(
                        alignment: Alignment.centerLeft,
                        decoration: kBoxStyle,
                        height: 62.0,
                        child: TextFormField(
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontFamily: 'OpenSans',
                          ),
                          decoration: kTextInputDecoration.copyWith(
                            prefixIcon: Icon(
                              Icons.account_box,
                              color: Colors.blueGrey,
                            ),
                            hintText: 'Enter your Username',
                            hintStyle: kHintStyle,
                          ),
                          validator: (val) =>
                              val.isEmpty ? '\t\t\tEnter a Username' : null,
                          onChanged: (val) {
                            setState(() => username = val.trim());
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        decoration: kBoxStyle,
                        height: 62.0,
                        child: TextFormField(
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontFamily: 'OpenSans',
                          ),
                          keyboardType: TextInputType.emailAddress,
                          decoration: kTextInputDecoration.copyWith(
                            hintText: 'Enter your Email',
                            hintStyle: kHintStyle,
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.blueGrey,
                            ),
                          ),
                          validator: (val) =>
                              val.isEmpty ? '\t\t\tEnter an email' : null,
                          onChanged: (val) {
                            setState(() => email = val.trim());
                          },
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Container(
                        alignment: Alignment.centerLeft,
                        decoration: kBoxStyle,
                        height: 62.0,
                        child: TextFormField(
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontFamily: 'OpenSans',
                          ),
                          decoration: kTextInputDecoration.copyWith(
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.blueGrey,
                            ),
                            hintText: 'Enter your Password',
                            hintStyle: kHintStyle,
                          ),
                          validator: (val) => val.length < 6
                              ? '\t\t\tPassword should atleast be 6 characters long'
                              : null,
                          obscureText: true,
                          onChanged: (val) {
                            setState(() => password = val.trim());
                          },
                        ),
                      ),
                      SizedBox(height: 30.0),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 1, 198, 21),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextButton(
                          child: Text(
                            'Sign Up',
                            style: TextStyle(color: kDarkGrey),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() => loading = true);
                              dynamic result =
                                  await _auth.registerWithEmailAndPassword(
                                      email, password, username);
                              CryptoPortfolioDatabaseService(
                                      uid:
                                          FirebaseAuth.instance.currentUser.uid)
                                  .setInitialData();
                              if (result == null) {
                                setState(() => error = 'Please Ente valid');
                              } else {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => BottomNavBar(),
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 30.0),
                      Container(
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: () =>
                              Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SignIn(),
                          )),
                          child: Text(
                            'Already have an Account? Login',
                            style: kLabelStyle,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => AboutUs()),
                          ),
                          child: Text(
                            'About Us',
                            style: kLabelStyle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
