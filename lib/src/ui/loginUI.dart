import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nilai_santri/src/ui/homeUI.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  final membersReference = FirebaseDatabase.instance.reference();

  GoogleSignIn _googleSignIn = GoogleSignIn();
  FirebaseAuth _auth;

  @override
  void initState() {
    super.initState();
  }

  void _cekSignIn() async {
    await Firebase.initializeApp();
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user != null) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => HomeUI()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Email atau Password salah!"),
        ));
      }
    });
  }

  void _onLogin() async {
    if (username.text != '' || password.text != '') {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: username.text, password: password.text);
      // _cekSignIn();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Email atau Password tidak boleh kosong!"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildInput(_size, username, 'Email',
                tipe: TextInputType.emailAddress),
            buildInput(_size, password, 'Password', pass: true),
            SizedBox(height: 20.0),
            InkWell(
              onTap: () {
                _onLogin();
              },
              child: Container(
                width: _size.width * 0.4,
                height: _size.height * 0.06,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(18)),
                child: Text(
                  "Masuk",
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildInput(
      Size _size, TextEditingController controller, String placeholder,
      {TextInputType tipe = TextInputType.text, bool pass = false}) {
    return Container(
      width: _size.width * 0.7,
      height: 60,
      margin: EdgeInsets.only(top: 10),
      child: TextField(
        obscureText: pass,
        controller: controller,
        keyboardType: tipe,
        decoration: new InputDecoration(
          border: new OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(12),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(12),
            ),
            borderSide: BorderSide(color: Colors.green.shade400),
          ),
          filled: true,
          hintStyle: new TextStyle(color: Colors.black38),
          hintText: placeholder,
          fillColor: Colors.white70,
        ),
      ),
    );
  }
}
