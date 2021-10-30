import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_movies/uiscreens/authintication/signup.dart';
import 'package:my_movies/uiscreens/movie_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKeyForLogin = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late bool isUserLoaginLoading = false, value = false, passwordVisible = true;
  late String email, password;
  bool _obscureText = true;
  bool flag = false;
  late SharedPreferences logindata;

  Future<void> loginresult() async =>
      logindata = await SharedPreferences.getInstance();
  late AnimationController animation;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    loginresult();
    super.initState();
  }

  // Toggles the password
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Welcome to MyMovies",
            style: TextStyle(
                color: Colors.black, fontSize: 22, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: height / 50,
          ),
          Text(
            "LOG IN",
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w300),
          ),
          SizedBox(
            height: height / 6,
          ),
          buildLoginPageForm(),
        ],
      ),
    );
  }

  Widget buildLoginPageForm() {
    double height = MediaQuery.of(context).size.height;
    return Form(
      key: _formKeyForLogin,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: height / 80,
            ),
            buildEmailText(),
            buildEmailTextField(),
            SizedBox(
              height: height / 30,
            ),
            buildPasswordText(),
            buildPasswordTextField(),
            SizedBox(
              height: height / 50,
            ),
            buildLoginButton(),
            SizedBox(
              height: height / 50,
            ),
            buildsignuplink(),
          ],
        ),
      ),
    );
  }

  Widget buildEmailText() {
    return RichText(
      text: TextSpan(
        text: "Email address",
        style: TextStyle(fontSize: 12, color: Colors.black),
      ),
    );
  }

  Widget buildEmailTextField() {
    return Container(
      child: TextFormField(
        controller: emailController,
        onSaved: (value) {
          email = value!;
        },
        validator: (value) {
          if (value!.isEmpty) {
            return "Enter Your Email";
          } else if (!RegExp(
                  r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
              .hasMatch(value)) {
            return "Please Enter Valid Email";
          } else
            return null;
        },
        style: TextStyle(fontSize: 14, color: Colors.black),
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: "user@gmail.com",
          hintStyle: TextStyle(color: Colors.black54),
          errorMaxLines: 1,
          errorStyle: TextStyle(color: Colors.black54),
          suffixIcon: Icon(Icons.person_outline, color: Colors.black, size: 20),
        ),
      ),
    );
  }

  Widget buildPasswordText() {
    return RichText(
      text: TextSpan(
        text: "Password",
        style: TextStyle(fontSize: 12, color: Colors.black),
      ),
    );
  }

  Widget buildPasswordTextField() {
    return Container(
      margin: EdgeInsets.only(top: 5.0),
      child: TextFormField(
        controller: passwordController,
        style: TextStyle(fontSize: 14, color: Colors.black),
        keyboardType: TextInputType.text,
        onSaved: (value) {
          password = value!;
        },
        validator: (value) {
          if (value!.isEmpty) {
            return "Enter Password";
          } else if (value.length < 6) {
            return "Please Enter Min 6 Digit Password";
          } else
            return null;
        },
        decoration: InputDecoration(
          errorStyle: TextStyle(color: Colors.black54),
          fillColor: Colors.black54,
          hintText: "Enter password here",
          suffixIcon: InkWell(
            onTap: _toggle,
            child: _obscureText
                ? Icon(Icons.remove_red_eye, color: Colors.black, size: 20)
                : Icon(Icons.remove_red_eye, color: Colors.black38, size: 20),
          ),
        ),
        obscureText: _obscureText,
      ),
    );
  }

  Widget buildLoginButton() {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      child: RaisedButton(
        elevation: 0,
        color: Colors.black38,
        onPressed: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          if (_formKeyForLogin.currentState!.validate()) {
            _formKeyForLogin.currentState!.save();
            setState(() {
              isUserLoaginLoading = true;
            });

            FirebaseAuth.instance
                .signInWithEmailAndPassword(
                    email: emailController.text.toString().trim(),
                    password: passwordController.text.toString().trim())
                .then((currentUser) => FirebaseFirestore.instance
                        .collection("Users")
                        .doc(currentUser.user!.uid)
                        .get()
                        .then((DocumentSnapshot result) {
                      prefs.setString(
                          "userID", currentUser.user!.uid.toString());
                      print('sucessful');
                      logindata.setString(
                          'username', currentUser.user!.email.toString());
                      logindata.setBool('login', false);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MoviesPage()));
                      setState(() {
                        isUserLoaginLoading = false;
                      });
                    }).catchError((err) {
                      showSnackbar(err);
                      setState(() {
                        isUserLoaginLoading = false;
                      });
                    }))
                .catchError((err) {
              setState(() {
                isUserLoaginLoading = false;
              });
              showSnackbar("${err}");
            });
          }
        },
        child: Stack(
          children: <Widget>[
            isUserLoaginLoading == true
                ? Container(
                    height: 20, width: 20.0, child: CircularProgressIndicator())
                : Text(
                    'Log in',
                    style: TextStyle(color: Colors.white),
                  )
          ],
        ),
      ),
    );
  }

  Widget buildsignuplink() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Signup()),
        );
      },
      child: RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: 'New user ? ',
              style: TextStyle(color: Colors.black54),
            ),
            TextSpan(
              text: "Sign Up ",
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  void showSnackbar(message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: 3000),
    );
    _scaffoldKey.currentState!.showSnackBar(snackBar);
  }
}
