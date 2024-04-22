import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:weezywizard/login.dart';
import 'package:weezywizard/register.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Interface(),
    );
  }
}

class Interface extends StatelessWidget {
  const Interface({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Container(
          height: size.height,
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                  width: size.width,
                  top: 0,
                  right: 0,
                  child: Image.asset(
                    "assets/images/top.png",
                    width: size.width * 0.3,
                  )),
              Positioned(
                  width: size.width,
                  bottom: 0,
                  left: 0,
                  child: Image.asset(
                    "assets/images/bootom.png",
                    width: size.width * 0.3,
                  )),
              Positioned(
                  top: 70,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("WELCOME TO WEEZY WIZARD",
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 25)),
                      SizedBox(
                        height: size.height * 0.1,
                      ),
                      SvgPicture.asset(
                        "assets/icons/login3.svg",
                        height: size.height * 0.5,
                      ),
                      SizedBox(
                        height: size.height * 0.08,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(29),
                        child: TextButton(
                            style: TextButton.styleFrom(
                                fixedSize: Size(120, 45),
                                backgroundColor:
                                    const Color.fromARGB(255, 36, 158, 164),
                                foregroundColor: Color(0xFFe3e3e3),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10)),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginP()),
                              );
                            },
                            child: Text(
                              "LOGIN",
                              style: TextStyle(
                                  fontSize: 20, color: const Color(0xFFe3e3e3)),
                            )),
                      ),
                      SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(29),
                        child: TextButton(
                            style: TextButton.styleFrom(
                                fixedSize: Size(120, 45),
                                backgroundColor:
                                    const Color.fromARGB(255, 36, 158, 164),
                                foregroundColor: Color(0xFFe3e3e3),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10)),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterPage()),
                              );
                            },
                            child: Text(
                              "SIGNUP",
                              style: TextStyle(
                                  fontSize: 20, color: const Color(0xFFe3e3e3)),
                            )),
                      )
                    ],
                  ))
            ],
          )),
    );
  }
}
