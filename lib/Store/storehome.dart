import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_market/Store/cart.dart';
import 'package:e_market/Store/product_page.dart';
import 'package:e_market/Counters/cartitemcounter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:e_market/Config/config.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/myDrawer.dart';
import '../Widgets/searchBox.dart';
import '../Models/item.dart';

// double width;

class StoreHome extends StatefulWidget {
  @override
  _StoreHomeState createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome> {
  @override
  Widget build(BuildContext context) {
    // width = MediaQuery.of(context).size.width;
    final cartCount = Provider.of<CartItemCounter>(context,listen: false).count;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('E-market'),
          flexibleSpace: Positioned(
            // top: 5,
            left: 50,
            // bottom: 5,
            // right: 50,
            child: Text('Hey worlf'),
          ),
          actions: [
            Stack(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Route route = MaterialPageRoute(builder: (c) => CartPage());
                    Navigator.push(context, route);
                  },
                ),
                if(cartCount > 0)
                Positioned(
                    child: Stack(
                  children: [
                    Icon(
                      Icons.brightness_1,
                      size: 20.0,
                      color: Colors.white,
                    ),
                    Positioned(
                        top: 3.0,
                        bottom: 4.0,
                        left: 4.0,
                        child: Consumer<CartItemCounter>(
                          builder: (context, counter, _) {
                            return Text(
                              counter.count.toString(),
                              style: TextStyle(color: Colors.black,fontSize: 12.0,fontWeight: FontWeight.w500),
                            );
                          },
                        ))
                  ],
                ))
              ],
            )
          ],
        ),
        drawer: MyDrawer(),
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(pinned:true,delegate: SearchBoxDelegate())
          ],
        ),
      ),
    );
  }
}

Widget sourceInfo(model, BuildContext context, {Color, removeCartFunction}) {
  return InkWell();
}

Widget card({Color primaryColor = Colors.redAccent, String}) {
  return Container();
}

void checkItemInCart(String productID, BuildContext context) {}
