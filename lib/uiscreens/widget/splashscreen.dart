import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_movies/uiscreens/authintication/login.dart';
import 'package:my_movies/uiscreens/movie_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  final deviceID;

  const SplashScreen({Key? key, this.deviceID}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late SharedPreferences logindata;
  late bool newuser;

  Future<void> loginresult() async =>
      logindata = await SharedPreferences.getInstance();

  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    check_if_already_login();
    super.initState();
  }

  check_if_already_login() async {
    logindata = await SharedPreferences.getInstance();
    newuser = (logindata.getBool('login') ?? true);
    print(newuser);
    if (newuser == false) {
      Future.delayed(Duration(milliseconds: 1400), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MoviesPage()));
      });
    } else if (newuser == true) {
      Future.delayed(Duration(milliseconds: 1400), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Login()));
      });
    } else {
      print('error');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.white),
          ),
          Container(
            height: size.height,
            width: size.width,
            color: Colors.transparent,
          ),
        ],
      ),
    );
  }
}
