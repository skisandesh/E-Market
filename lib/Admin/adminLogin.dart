import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_market/Admin/uploadItems.dart';
import 'package:e_market/Authentication/welcome_screen.dart';
import 'package:e_market/Widgets/customTextField.dart';
import 'package:e_market/DialogBox/errorDialog.dart';
import 'package:flutter/material.dart';




class AdminSignInPage extends StatefulWidget {
  @override
  _AdminSignInPageState createState() => _AdminSignInPageState();
}

class _AdminSignInPageState extends State<AdminSignInPage>
{
  final _adminIdTextEditingController = TextEditingController();
  final _passwordTextEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [BackButton()],
                ),
                SizedBox(
                  height: _screenHeight * 0.1,
                ),
                _title(),
                Text('All Products'),
                SizedBox(
                  height: _screenHeight * 0.1,
                ),
                Text('Admin Login ',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                SizedBox(
                  height: _screenHeight * 0.07,
                ),
                Container(
                  child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          CustomTextField(
                              key: ValueKey('Admin'),
                              controller: _adminIdTextEditingController,
                              data: Icons.person,
                              hintText: 'iD',
                              isObsecure: false),
                          CustomTextField(
                              key: ValueKey('password'),
                              controller: _passwordTextEditingController,
                              data: Icons.password,
                              hintText: 'password',
                              isObsecure: true),
                          SizedBox(
                            height: 20,
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints.tightFor(
                                width: _screenWidth * 0.9,
                                height: _screenHeight * 0.07),
                            child: ElevatedButton(
                              onPressed: () {
                                _adminIdTextEditingController.text.isNotEmpty &&
                                    _passwordTextEditingController
                                        .text.isNotEmpty
                                    ? loginAdmin()
                                    : showDialog(
                                    context: context,
                                    builder: (c) {
                                      return ErrorAlertDialog(
                                          message:
                                          'Please provide the account');
                                    });
                              },
                              child: Text(
                                'Login',
                                style: TextStyle(color: Colors.white, fontSize: 20),
                              ),
                              style: ButtonStyle(
                                  backgroundColor:
                                  MaterialStateProperty.all(Color(0xffe46b10))),
                            ),
                          ),
                        ],
                      )),
                ),
              ],
            ),
          ),
        ));
  }
  loginAdmin(){
    FirebaseFirestore.instance.collection('admins').get().then((adminSnapshot) {
      adminSnapshot.docs.forEach((admin) {
       if(admin.data()['id'] != _adminIdTextEditingController.text.trim()){
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Not a Admin'),duration: const Duration(seconds: 1)));
       }else if(admin.data()['password'] != _passwordTextEditingController.text.trim()){
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('password did not match'),duration: const Duration(seconds: 1)));
       }else{
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Welcome Admin'+  admin.data()['name']),duration: const Duration(seconds: 2),));
         setState(() {
           _adminIdTextEditingController.text = '';
           _passwordTextEditingController.text = '';
         });
         Route route = MaterialPageRoute(builder: (c)=> UploadPage());
         Navigator.pushReplacement(context, route);
       }

      });
    });
  }
}


Widget _title() {
  return RichText(
    textAlign: TextAlign.center,
    text: TextSpan(
        text: 'E',
        style: TextStyle(
            color: Color(0xffe46b10),
            fontSize: 40,
            fontWeight: FontWeight.bold),
        children: [
          TextSpan(
            text: 'market',
            style: TextStyle(color: Colors.black, fontSize: 30),
          ),
        ]),
  );
}