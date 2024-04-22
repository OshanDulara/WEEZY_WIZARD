import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Future signUp() async {
    if (passwordConfirmed()) {
      try {
        UserCredential usercredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        print('user registered: $usercredential.user.uid}');
      } on FirebaseAuthException catch (e) {
        print('faled to register user: $e');
      }
    }
  }

  bool passwordConfirmed() {
    if (_passwordController.text.trim() ==
        _confirmPasswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
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
                top: 80,
                left: 0,
                right: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "SIGNUP",
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          color: Colors.white,
                          fontSize: 25),
                    ),
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    SvgPicture.asset(
                      "assets/icons/signup.svg",
                      height: size.height * 0.3,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(25)),
                      child: Material(
                          color: Colors.grey,
                          child: TextField(
                            controller: _emailController,
                            onChanged: (value) {},
                            decoration: InputDecoration(
                                hintText: "Email",
                                prefixIcon: Icon(Icons.person)),
                          )),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(25)),
                      child: Material(
                          color: Colors.grey,
                          child: TextField(
                            controller: _passwordController,
                            onChanged: (value) {},
                            obscureText: true,
                            decoration: InputDecoration(
                                hintText: "Password",
                                prefixIcon: Icon(Icons.lock),
                                suffixIcon: Icon(Icons.visibility)),
                          )),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(25)),
                      child: Material(
                          color: Colors.grey,
                          child: TextField(
                            controller: _confirmPasswordController,
                            onChanged: (value) {},
                            obscureText: true,
                            decoration: InputDecoration(
                                hintText: "Confirm Password",
                                prefixIcon: Icon(Icons.lock),
                                suffixIcon: Icon(Icons.visibility)),
                          )),
                    ),
                    SizedBox(height: size.height * 0.05),
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
                          onPressed: signUp,
                          child: Text(
                            "SIGNUP",
                            style: TextStyle(
                                fontSize: 20, color: const Color(0xFFe3e3e3)),
                          )),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Already have an account? |",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              decoration: TextDecoration.none),
                        ),
                        SizedBox(width: 5),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LoginP()),
                            );
                          },
                          child: Text(
                            "SIGNIN",
                            style: TextStyle(
                                color: Color.fromARGB(255, 36, 158, 164),
                                fontSize: 15,
                                decoration: TextDecoration.none),
                          ),
                        )
                      ],
                    )
                  ],
                ))
          ],
        ));
  }
}
