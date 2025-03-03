import 'package:demo_project_user/screens/LoginPage.dart';
import 'package:demo_project_user/utils/Commonmethods.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signupUser() async {
    if(_phoneController.text.isNotEmpty && _emailController.text.isNotEmpty && _nameController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
      try {
        UserCredential userCredential = await _auth
            .createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        User? user = userCredential.user;
        if (user != null) {
          await _firestore.collection('User').doc(user.uid).set({
            'phone': _phoneController.text,
            'email': _emailController.text,
            'name': _nameController.text,
            'password': _passwordController.text,
            // Consider storing a hashed password
          }).whenComplete( (){

          }

          ).catchError((onError){
            commonMethods.showSnackBar2(context, "Sign up failed $onError");

          });

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('User signed up successfully!'),
          ));
          // commonMethods.showSnackBar2(context, "Sign up success");
          _phoneController.text = "";
          _emailController.text = "";
          _nameController.text = "";
          _passwordController.text = "";
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LoginPage()
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to sign up: $e'),
        ));
      }
    }else{
      commonMethods.showSnackBar2(context, "Fill all fields");

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signup User'),
        backgroundColor: Colors.lightGreen,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Signup',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signupUser,
              child: Text('Signup'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
