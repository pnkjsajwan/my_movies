import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_movies/uiscreens/authintication/login.dart';
import 'package:my_movies/uiscreens/movie_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController firstController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late bool isLoading = false,
      registerationLoading = false,
      rememberMe = false,
      value = false,
      passwordVisible = true;
  late String email, password, name;
  late SharedPreferences logindata;
  bool _obscureText = true;

  // Toggles the password
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> loginresult() async =>
      logindata = await SharedPreferences.getInstance();

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    loginresult();
    super.initState();
  }

  bool? validate() {
    final form = _formKey.currentState;
    form!.save();
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
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
            "REGISTER",
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w300),
          ),
          SizedBox(
            height: height / 10,
          ),
          buildLoginPageForm(),
        ],
      ),
    );
  }

  Widget buildLoginPageForm() {
    double height = MediaQuery.of(context).size.height;
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: height / 50,
            ),
            buildFirstText(),
            buildFirstTextField(),
            SizedBox(
              height: height / 50,
            ),
            buildEmailText(),
            buildEmailTextField(),
            SizedBox(
              height: height / 50,
            ),
            buildPasswordText(),
            buildPasswordTextField(),
            SizedBox(
              height: height / 50,
            ),
            buildsignuplink(),
            SizedBox(
              height: height / 50,
            ),
            buildLoginButton(),
            SizedBox(
              height: height / 50,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFirstText() {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: "Enter Name",
            style: TextStyle(fontSize: 14, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget buildFirstTextField() {
    return Container(
      child: TextFormField(
        controller: firstController,
        style: TextStyle(fontSize: 14, color: Colors.black),
        keyboardType: TextInputType.text,
        validator: (value) {
          if (value!.isEmpty) {
            return "Enter Full Name";
          } else {
            return null;
          }
        },
        onSaved: (value) {
          name = value!;
        },
        decoration: InputDecoration(
          errorStyle: TextStyle(color: Colors.black54),
          fillColor: Colors.pink,
        ),
      ),
    );
  }

  Widget buildEmailText() {
    return Padding(
      padding: const EdgeInsets.only(),
      child: RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
                text: "Email",
                style: TextStyle(color: Colors.black, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget buildEmailTextField() {
    return Container(
      child: TextFormField(
        controller: emailController,
        style: TextStyle(fontSize: 14, color: Colors.black),
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return "Enter your email";
          } else if (!RegExp(
                  r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
              .hasMatch(value)) {
            return "Please enter valid email";
          } else
            return null;
        },
        onSaved: (value) {
          email = value!;
        },
        decoration: InputDecoration(
          errorStyle: TextStyle(color: Colors.black54),
          suffixIcon: Icon(Icons.email_outlined, color: Colors.black, size: 20),
        ),
      ),
    );
  }

  Widget buildPasswordText() {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
              text: "Password",
              style: TextStyle(color: Colors.black, fontSize: 14)),
        ],
      ),
    );
  }

  Widget buildPasswordTextField() {
    return Container(
      child: TextFormField(
        controller: passwordController,
        style: TextStyle(fontSize: 14, color: Colors.black),
        keyboardType: TextInputType.text,
        validator: (value) {
          if (value!.isEmpty) {
            return "Enter Password";
          } else if (value.length < 6) {
            return "Please Enter Min 6 Digit Password";
          } else
            return null;
        },
        onSaved: (value) {
          password = value!;
        },
        decoration: InputDecoration(
          errorStyle: TextStyle(color: Colors.black54),
          fillColor: Colors.pink,
          suffixIcon: InkWell(
            onTap: _toggle,
            child: _obscureText
                ? Icon(Icons.remove_red_eye, color: Colors.black, size: 20)
                : Icon(Icons.remove_red_eye, color: Colors.black12, size: 20),
          ),
        ),
        obscureText: _obscureText,
      ),
    );
  }

  Widget buildsignuplink() {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      child: RaisedButton(
        elevation: 0,
        color: Colors.black38,
        onPressed: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            setState(() {
              registerationLoading = true;
            });
            if (passwordController.text.isNotEmpty) {
              FirebaseAuth.instance
                  .createUserWithEmailAndPassword(
                      email: emailController.text.toString().trim(),
                      password: passwordController.text.toString().trim())
                  .then((currentUser) => FirebaseFirestore.instance
                          .collection("Users")
                          .doc(currentUser.user!.uid)
                          .set({
                        "uid": currentUser.user!.uid,
                        "name": firstController.text,
                        "email": emailController.text,
                      }).then((result) {
                        setState(() {
                          registerationLoading = false;
                          prefs.setString(
                              "userID", currentUser.user!.uid.toString());
                          print('sucessful');
                          logindata.setString(
                              'username', currentUser.user!.email.toString());
                          logindata.setBool('login', false);
                          firstController.clear();
                          emailController.clear();
                          passwordController.clear();
                        });
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MoviesPage()),
                            (_) => false);
                      }).catchError((err) {
                        showSnackbar(err);
                        setState(() {
                          registerationLoading = false;
                        });
                      }))
                  .catchError((err) {
                showSnackbar(err);
                setState(() {
                  registerationLoading = false;
                });
              });
            } else {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Error"),
                      content: Text("The passwords is empty"),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("Close"),
                          onPressed: () {
                            setState(() {
                              registerationLoading = false;
                            });
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    );
                  });
            }
          }
        },
        child: Stack(
          children: <Widget>[
            registerationLoading == true
                ? Container(
                    height: 20, width: 20.0, child: CircularProgressIndicator())
                : Text('Register', style: TextStyle(color: Colors.white))
          ],
        ),
      ),
    );
  }

  Widget buildLoginButton() {
    return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Login(),
            ),
          );
        },
        child: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                  text: "Have a account" + " ? ",
                  style: TextStyle(color: Colors.black54, fontSize: 14)),
              TextSpan(
                text: "Login",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ],
          ),
        ));
  }

  void showSnackbar(message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: 3000),
    );
    _scaffoldKey.currentState!.showSnackBar(snackBar);
  }
}
