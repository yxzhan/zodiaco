import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String pass = "admin";

  String animationType = "idle";

  final passwordController = TextEditingController();
  final passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/loginbg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 100,
              width: 100,
            ),
            Text(
              'Zodiaco',
              style: TextStyle(
                  decoration: TextDecoration.none,
                  fontFamily: 'Kefa',
                  fontSize: 40,
                  fontWeight:FontWeight.bold,
                  color: const Color.fromARGB(255, 223, 140, 0)),
            ),

            //just for vertical spacing
            SizedBox(
              height: 30,
              width: 200,
            ),

            //space for gif
            Center(
                child: Container(
                    height: 200,
                    width: 200,
                    child: CircleAvatar(
                      child: ClipOval(
                        child: Image.asset("assets/12anim.gif"),
                      ),
                      backgroundColor: Colors.white,
                    ))),

            //just for vertical spacing
            SizedBox(
              height: 60,
              width: 10,
            ),
            Text(
              'Online Players:2',
              style: TextStyle(
                  decoration: TextDecoration.none,
                  fontFamily: 'Kefa',
                  fontSize: 15,
                  color: Colors.white),
            ),
            SizedBox(
              height: 10,
              width: 10,
            ),
            //container for textfields user name and password
            Container(
              height: 50,
              width: 300,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  color: Colors.white),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "User name",
                        hintStyle: TextStyle(fontFamily:'Kefa',fontSize: 16.0),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20)),
                  ),
                  // Divider(),
                  // TextFormField(
                  //   obscureText: true,
                  //   decoration: InputDecoration(
                  //       border: InputBorder.none,
                  //       hintText: "Password",
                  //       contentPadding: EdgeInsets.all(20)),
                  //   controller: passwordController,
                  //   focusNode: passwordFocusNode,
                  // ),
                ],
              ),
            ),

            //container for raised button
            Container(
              width: 150,
              height: 70,
              padding: EdgeInsets.only(top: 20),
              child: RaisedButton(
                  color: Color.fromARGB(255, 223, 140, 0),
                  child: Text(
                    "PLAY",
                    style: TextStyle(fontFamily:'Kefa',fontSize:16.0,fontWeight:FontWeight.bold,color: Colors.white),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30),
                  ),
                  onPressed: () {
                    if (passwordController.text.compareTo(pass) == 0) {
                      setState(() {
                        animationType = "success";
                      });
                    } else {
                      setState(() {
                        animationType = "fail";
                      });
                    }
                  }),
            ),
            SizedBox(
              height: 20,
              width: 10,
            ),
            Container(
              height: 50,
              width: 200,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                color: Color.fromARGB(0, 255, 255, 255),),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    textAlign:TextAlign.center,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "HOW TO PLAY",
                        hintStyle: TextStyle(fontFamily:'Kefa',fontSize: 16.0,fontWeight:FontWeight.bold,color: Color.fromARGB(255, 223, 140, 0)),
                        // contentPadding: EdgeInsets.symmetric(horizontal: (1))
                      ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
