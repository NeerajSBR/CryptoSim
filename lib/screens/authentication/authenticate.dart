import 'package:CrypSim/screens/authentication/register.dart';
import 'package:CrypSim/screens/authentication/sign_in.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;
  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignIn();
    } else {
      return Register(toggleView: toggleView);
    }
  }
}
