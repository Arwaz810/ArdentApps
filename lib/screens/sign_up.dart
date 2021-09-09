import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var _formKey = GlobalKey<FormState>();
  bool _showPass = true; //to manage password visibility

  //controller to get the values from user for signup process
  TextEditingController _nameCtrl = TextEditingController();
  TextEditingController _phoneCtrl = TextEditingController();
  TextEditingController _emailCtrl = TextEditingController();
  TextEditingController _passCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
            alignment: Alignment.bottomCenter,
            fit: StackFit.expand,
            children: [
          Positioned(
            child: Text(
              'Sign Up',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
            ),
            top: 100.5,
            left: 22,
          ),
          Positioned.fill(
            top: 100.0,
            left: 20,
            right: 20,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.person),
                      hintText: 'Enter Name',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black54,
                          width: 4,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.name,
                    validator: (input) {
                      if (input!.isEmpty) return "Name can't be empty";
                      return null;
                    },
                    controller: _nameCtrl,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.phone_android),
                      hintText: 'Enter Phone Number',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black54,
                          width: 4,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (input) {
                      if (input!.isEmpty || input.length < 10)
                        return "Enter correct phone number";
                      return null;
                    },
                    controller: _phoneCtrl,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.mail),
                      hintText: 'Enter E-Mail',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black54,
                          width: 4,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (input) {
                      if (input!.isEmpty) return "Enter E-Mail";
                      return null;
                    },
                    controller: _emailCtrl,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.security),
                      suffix: GestureDetector(
                        child: Icon(
                            _showPass ? Icons.delete : Icons.remove_red_eye),
                        onTap: () {
                          setState(() {
                            _showPass = !_showPass;
                          });
                        },
                      ),
                      hintText: 'Enter Password',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black54,
                          width: 4,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: _showPass,
                    validator: (pwdInput) {
                      if (pwdInput!.isEmpty) return "Set a password";
                      return null;
                    },
                    controller: _passCtrl,
                  ),
                  Container(
                    child: TextButton(
                      onPressed: () => processSubmit(),
                      child: Text('Submit'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]));
  }

  void processSubmit() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _emailCtrl.text.toString(),
                password: _passCtrl.text.toString());

        if (userCredential.user != null) {
          await userCredential.user!.sendEmailVerification();
          String currentUserId = userCredential.user!.uid;
//store additional info of user
          storeMoreInfo(currentUserId);
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        }
      } catch (e) {
        print(e);
      }
    }
  }

  void showMsg(String msg) {
    Fluttertoast.showToast(msg:msg,
    toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0

        //this is optional
        // action: SnackBarAction(label: 'OK',
        // onPressed: (){}
        // ),
        );
  }

  void storeMoreInfo(String currentUserId) {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    _firestore
        .collection('Account')
        .doc(currentUserId)
        .set({
          'user_name': _nameCtrl.text,
          'user_phone': _phoneCtrl.text,
          'user_email': _emailCtrl.text,
          'user_pic': null,
        })
        .then((_) => showMsg("Resgistration is done"))
        .catchError((onError) => showMsg(onError.toString()));
  }
}
