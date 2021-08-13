
import 'package:e_market/Address/addAddress.dart';
import 'package:e_market/Authentication/welcome_screen.dart';
import 'package:e_market/Config/config.dart';
import 'package:e_market/Orders/myOrders.dart';
import 'package:e_market/Store/Search.dart';
import 'package:e_market/Store/cart.dart';
import 'package:e_market/Store/storehome.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
            children: [
              Container(
                padding: EdgeInsets.only(top: 25.0,bottom: 10.0),
                child: Column(children: [
                  CircleAvatar(backgroundImage: NetworkImage(EcommerceApp.sharedPreferences.getString(EcommerceApp.userAvatarUrl).toString()),
                  radius: 80,),
                  SizedBox(height: 10,),
                  Text(
                    EcommerceApp.sharedPreferences.getString(EcommerceApp.userName).toString(),
                    style: TextStyle(fontSize: 35.0,color: Color(0xffe46b10)),
                  ),
                  SizedBox(height: 15.0,),
                  Divider(height: 10.0,thickness: 5.0,color: Color(0xffe46b10),),
                  ListTile(
                    leading: Icon(Icons.home,color: Color(0xffe46b10),),
                    title: Text("Home",style: TextStyle(fontSize: 20),),
                    onTap: (){
                      Route route = MaterialPageRoute(builder: (_)=> StoreHome());
                      Navigator.pushReplacement(context,route);
                    },
                  ),
                  Divider(height: 10.0,thickness: 1.5,color: Color(0xffe46b10),),
                  ListTile(
                    leading: Icon(Icons.home,color: Color(0xffe46b10),),
                    title: Text("My Order",style: TextStyle(fontSize: 20),),
                    onTap: (){
                      Route route = MaterialPageRoute(builder: (_)=> MyOrders());
                      Navigator.pushReplacement(context,route);
                    },
                  ),
                  Divider(height: 10.0,thickness: 1.5,color: Color(0xffe46b10),),
                  ListTile(
                    leading: Icon(Icons.home,color: Color(0xffe46b10),),
                    title: Text("My Cart",style: TextStyle(fontSize: 20),),
                    onTap: (){
                      Route route = MaterialPageRoute(builder: (_)=> CartPage());
                      Navigator.pushReplacement(context,route);
                    },
                  ),
                  Divider(height: 10.0,thickness: 1.5,color: Color(0xffe46b10),),
                  ListTile(
                    leading: Icon(Icons.home,color: Color(0xffe46b10),),
                    title: Text("Search",style: TextStyle(fontSize: 20),),
                    onTap: (){
                      Route route = MaterialPageRoute(builder: (_)=> SearchProduct());
                      Navigator.pushReplacement(context,route);
                    },
                  ),
                  Divider(height: 10.0,thickness: 1.5,color: Color(0xffe46b10),),
                  ListTile(
                    leading: Icon(Icons.home,color: Color(0xffe46b10),),
                    title: Text("Address",style: TextStyle(fontSize: 20),),
                    onTap: (){
                      Route route = MaterialPageRoute(builder: (_)=> AddAddress());
                      Navigator.pushReplacement(context,route);
                    },
                  ),
                  Divider(height: 10.0,thickness: 1.5,color: Color(0xffe46b10),),
                  ListTile(
                    leading: Icon(Icons.home,color: Color(0xffe46b10),),
                    title: Text("Logout",style: TextStyle(fontSize: 20),),
                    onTap: (){
                      EcommerceApp.auth.signOut().then((value) {
                        Route route = MaterialPageRoute(builder: (_)=> WelcomePage());
                        Navigator.pushReplacement(context,route);
                      });
                    },
                  ),
                  Divider(height: 10.0,thickness: 5.0,color: Color(0xffe46b10),),
                ],
                ),
              )
            ],
      ),
    );
  }
}
