import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_market/Authentication/welcome_screen.dart';
import 'package:e_market/Counters/ItemQuantity.dart';
import 'package:e_market/Counters/cartitemcounter.dart';
import 'package:e_market/Counters/changeAddresss.dart';
import 'package:e_market/Store/storehome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:e_market/Config/config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Config/config.dart';
import 'Counters/totalMoney.dart';

Future<void> main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  EcommerceApp.auth = FirebaseAuth.instance;
  EcommerceApp.sharedPreferences= await SharedPreferences.getInstance();
   EcommerceApp.firestore = FirebaseFirestore.instance;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (c)=>CartItemCounter()),
      ChangeNotifierProvider(create: (c)=>AddressChanger()),
      ChangeNotifierProvider(create: (c)=>ItemQuantity()),
      ChangeNotifierProvider(create: (c)=>TotalAmount()),

    ],
       child: MaterialApp(
        title: 'e-Shop',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color(0xffe46b10),
        ),
        home: FutureBuilder(
            future: Firebase.initializeApp(),
            builder: (ctx,snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('something went wrong'),);
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return SplashScreen();
              }
                return StreamBuilder(stream:FirebaseAuth.instance.authStateChanges(),builder: (ctx,userSnapShot){
                  if(userSnapShot.hasData){
                    return StoreHome();
                  }
                  return WelcomePage();
                },
                );
            }
        )
    )
    );
  }
}






















class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen>
{
  @override
  void initState() {
    super.initState();
    // displaySplash();
  }



  // displaySplash(){
  //   Timer(Duration(seconds: 2),(){
  //       if( EcommerceApp.auth.authStateChanges() != null){
  //           Route route = MaterialPageRoute(builder: (_)=> StoreHome());
  //           Navigator.pushReplacement(context,route);
  //       }
  //       Route route = MaterialPageRoute(builder: (_)=> WelcomePage());
  //       Navigator.pushReplacement(context, route);
  //   }
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(colors: [Colors.red,Colors.lightGreenAccent],
            begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
              stops: [0.0,1.0],
              tileMode: TileMode.clamp
            )
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Welcome',style: TextStyle(fontSize: 30),),
                  SizedBox(height: 40,),
                  Image.asset('images/welcome.png'),
                SizedBox(height: 15,),
                SizedBox(height: 20.0,),
                Text('World Best Online Store',style: TextStyle(color: Colors.white,fontSize: 20),)
            ],),
          ),
        ),
      ),
    );
  }
}


