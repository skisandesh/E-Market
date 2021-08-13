import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_market/Authentication/login.dart';
import 'package:e_market/Widgets/customTextField.dart';
import 'package:e_market/DialogBox/errorDialog.dart';
import 'package:e_market/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import '../Store/storehome.dart';
import 'package:e_market/Config/config.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _nameTextEditingController = TextEditingController();
  final _emailTextEditingController = TextEditingController();
  final _passwordTextEditingController = TextEditingController();
  final _cPasswordTextEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String userImageUrl = '';
  late File _imageFile;
  bool _hasImage = false;
  bool _isObscure = false;

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery
        .of(context)
        .size
        .width,
        _screenHeight = MediaQuery
            .of(context)
            .size
            .height;

    Future<void> _selectAndPickImage() async {
      final _picker = ImagePicker();
      final XFile? pickedImage = await _picker.pickImage(
          source: ImageSource.gallery);
      setState(() {
        _imageFile = File(pickedImage!.path);
        _hasImage = true;
      });
    }


    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(children: [BackButton()],),
                  _title(),
                  Text(
                    'All Products',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  SizedBox(
                    height: 50,
                  ),
                  InkWell(
                      onTap: _selectAndPickImage,
                      child: CircleAvatar(
                        radius: _screenWidth * 0.15,
                        backgroundColor: Colors.grey,
                        backgroundImage: _hasImage
                            ? FileImage(_imageFile)
                            : null,
                        child: _hasImage
                            ? null
                            : Icon(
                          Icons.add_photo_alternate,
                          size: _screenWidth * 0.15,
                          color: Color(0xffe46b10),
                        ),
                      )),
                  SizedBox(
                    height: 8.0,
                  ),
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          CustomTextField(
                              key: ValueKey('username'),
                              controller: _nameTextEditingController,
                              data: Icons.person,
                              hintText: 'Name',
                              isObsecure: false),
                          CustomTextField(
                              key: ValueKey('email'),
                              controller: _emailTextEditingController,
                              data: Icons.email,
                              hintText: 'email',
                              isObsecure: false),
                          CustomTextField(
                              key: ValueKey('password'),
                              controller: _passwordTextEditingController,
                              data: Icons.password,
                              hintText: 'password',
                              isObsecure: true),
                          CustomTextField(
                            key: ValueKey('cPassword'),
                            controller: _cPasswordTextEditingController,
                            data: Icons.password,
                            hintText: 'confirm password',
                            isObsecure: true,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _uploadAndSave();
                            },
                            child: Text(
                              'Register Now',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all(Color(0xffe46b10)),
                            ),
                          )
                        ],
                      )),

                  ButtonLabel(),
                ],
              ),
            ),
          )),
    );
  }


// To upload Image
  Future<void> _uploadAndSave() async {
    if (_imageFile == null) {
      displayDialog('Please Select image File');
    } else {
      _passwordTextEditingController.text ==
          _cPasswordTextEditingController.text ?
      _emailTextEditingController.text.isNotEmpty &&
          _nameTextEditingController.text.isNotEmpty &&
          _passwordTextEditingController.text.isNotEmpty &&
          _cPasswordTextEditingController.text.isNotEmpty
          ?
      uploadToStorage() : displayDialog('Please Fill up Form') : displayDialog(
          'Password do not Match');
    }
  }

  // To Display Error Function
  displayDialog(String msg) {
    showDialog(context: context, builder: (ctx) {
      return ErrorAlertDialog(message: msg);
    });
  }

  // To Upload To Storage
  uploadToStorage() async {
    showDialog(context: context,
        builder: (ctx) =>
            LoadingAlertDialog(message: 'Registering ,please wait',));
    String imageFileName = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();
    Reference storageReference = FirebaseStorage.instance.ref().child(
        imageFileName);
    UploadTask uploadTask = storageReference.putFile(_imageFile);
    uploadTask.then((res) {
      res.ref.getDownloadURL().then((value) {
        userImageUrl = value;
        _registerUser();
      });
    });
  }


  // To register user
  FirebaseAuth _auth = FirebaseAuth.instance;

  void _registerUser()  {
    UserCredential firebaseUser;
     _auth.createUserWithEmailAndPassword(
        email: _emailTextEditingController.text.trim(),
        password: _passwordTextEditingController.text.trim()).then((auth) {
      User? firebaseUser = auth.user;
        saveUserInfoToFireStore(firebaseUser).then((value) {
          Navigator.pop(context);
          Route route = MaterialPageRoute(builder: (_)=> StoreHome());
          Navigator.pushReplacement(context,route);
      });
    }).catchError((error) {
      print(error);
      Navigator.pop(context);
      showDialog(context: context, builder: (c) {
        return ErrorAlertDialog(message: error.message.toString());
      });
    });

  }

  // To Save register user to firestore
   Future saveUserInfoToFireStore(User? fUser)async{
    FirebaseFirestore.instance.collection('users').doc(fUser!.uid).set(
        {
          'uid': fUser.uid,
          'email': fUser.email,
          'name': _nameTextEditingController.text.trim(),
          'url': userImageUrl,
          EcommerceApp.userCartList: ['garbageValue']
        });
    await EcommerceApp.sharedPreferences.setString('uid', fUser.uid);
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.userEmail, '${fUser.email}');
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.userName, _nameTextEditingController.text.trim());
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.userAvatarUrl, userImageUrl);
    await EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList,['garbageValue']);

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




class ButtonLabel extends StatelessWidget {
  const ButtonLabel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Already have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Login',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
