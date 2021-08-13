import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_market/Admin/adminLogin.dart';
import 'package:e_market/Authentication/register.dart';
import 'package:e_market/Widgets/customTextField.dart';
import 'package:e_market/DialogBox/errorDialog.dart';
import 'package:e_market/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Store/storehome.dart';
import 'package:e_market/Config/config.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailTextEditingController = TextEditingController();
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
              height: _screenHeight * 0.15,
            ),
            Container(
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
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
                      SizedBox(
                        height: 20,
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints.tightFor(
                            width: _screenWidth * 0.9,
                            height: _screenHeight * 0.07),
                        child: ElevatedButton(
                          onPressed: () {
                            _emailTextEditingController.text.isNotEmpty &&
                                    _passwordTextEditingController
                                        .text.isNotEmpty
                                ? loginUser()
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
                      CreateAccount(),
                    ],
                  )),
            ),
          ],
        ),
      ),
    ));
  }

  // To SignIn User
  FirebaseAuth _auth = FirebaseAuth.instance;
   void loginUser()async{
     showDialog(context: context, builder: (c)=>LoadingAlertDialog(message: 'Authenticating,Please wait....',));
      _auth.signInWithEmailAndPassword(
         email: _emailTextEditingController.text.trim(),
         password: _passwordTextEditingController.text.trim()).then((authUser) {
               readData(authUser).then((value) {
                 Navigator.pop(context);
                 Route route = MaterialPageRoute(builder: (_)=> StoreHome());
                 Navigator.pushReplacement(context,route);
               });
     }).catchError((error){
       Navigator.pop(context);
       showDialog(context: context, builder: (c)=>ErrorAlertDialog(message: error.message.toString()));
      });
   }

   // To Read User Data
   Future readData(UserCredential fUser)async{
     FirebaseFirestore.instance.collection('users').doc(fUser.user!.uid).get().then((dataSnapShot)async{
       await EcommerceApp.sharedPreferences.setString('uid', dataSnapShot.data()!['${EcommerceApp.userUID}']);
       await EcommerceApp.sharedPreferences.setString(EcommerceApp.userEmail, dataSnapShot.data()![EcommerceApp.userEmail]);
       await EcommerceApp.sharedPreferences.setString(EcommerceApp.userName,dataSnapShot.data()![EcommerceApp.userName]);
       await EcommerceApp.sharedPreferences.setString(EcommerceApp.userAvatarUrl, dataSnapShot.data()![EcommerceApp.userAvatarUrl]);
       List<String> cartList = dataSnapShot.data()![EcommerceApp.userCartList].cast<String>();
       await EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList,cartList);
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

class CreateAccount extends StatelessWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Register()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Don\'t have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Register',
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
