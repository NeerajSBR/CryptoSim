import 'package:CrypSim/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:url_launcher/link.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({Key key}) : super(key: key);

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          centerTitle: true,
          title: Text('About us'),
        ),
        backgroundColor: kDarkGrey,
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Welcome to Crypto Simulation, Desclaimer: Cryptocurrency is the name given to a system that uses cryptography to allow the secure transfer and exchange of digital tokens in a distributed and decentralized manner. Hence use this app at your own risk',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Conteact us At :',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10,
              ),
              Link(
                uri: Uri.parse('https://github.com/NeerajSBR'),
                builder: (context, followLink) {
                  return TextButton(
                    onPressed: followLink,
                    child: Text('GitHub'),
                  );
                },
              ),
              Link(
                uri: Uri.parse(
                    'https://www.linkedin.com/in/neeraj-skanda-b-r-b08696213/'),
                builder: (context, followLink) {
                  return TextButton(
                    onPressed: followLink,
                    child: Text('LinkedIn'),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
