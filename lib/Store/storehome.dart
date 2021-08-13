import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_market/Counters/ItemQuantity.dart';
import 'package:e_market/Store/cart.dart';
import 'package:e_market/Store/product_page.dart';
import 'package:e_market/Counters/cartitemcounter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
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
    final cartCount =
        Provider.of<CartItemCounter>(context, listen: false).count;
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text('E-market'),
            actions: [
              Stack(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Route route =
                          MaterialPageRoute(builder: (c) => CartPage());
                      Navigator.push(context, route);
                    },
                  ),
                  if (cartCount > 0)
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
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w500),
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
          body: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('items')
                      .limit(10)
                      .orderBy('publishedDate', descending: true)
                      .snapshots(),
                  builder: (ctx, dataSnapShot) {
                    return !dataSnapShot.hasData
                        ?  Center(
                              child: CircularProgressIndicator(),
                            )
                        : ListView.builder(
                            itemBuilder: (ctx,index){
                              Object? model =
                                  dataSnapShot.data!.docs[index].data();
                              return productItem(model, context);
                            },
                            itemCount: dataSnapShot.data!.docs.length,
                          );
                  })
          ),
    );
  }
}

Widget productItem(model, BuildContext context, {Color, removeCartFunction}) {
  return Column(
    children: [
      InkWell(
        splashColor: Colors.pink,
        child: Padding(
          padding: EdgeInsets.all(6),
          child: Container(
            height: 190,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Image.network(
                  model['thumbnailUrl'],
                  width: 140,
                  height: 140,
                ),
                SizedBox(
                  width: 4,
                ),
                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                              child: Text(
                            model['title'],
                            style: TextStyle(fontSize: 14),
                          )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                              child: Text(
                            model['tag'],
                            style: TextStyle(fontSize: 12, color: Colors.black54),
                          )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle, color: Colors.pink),
                          alignment: Alignment.topLeft,
                          width: 40,
                          height: 40,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '50%',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15),
                              ),
                              Text(
                                'Off',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13),
                              )
                            ],
                          ),
                        ),
                        SizedBox(width: 10,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(padding: EdgeInsets.only(top: 0),
                            child: Row(
                              children: [
                                Text("Original Price: रु",style: TextStyle(fontSize: 15,color: Colors.grey,decoration: TextDecoration.lineThrough),),
                                Text((model['price']+model['price']).toString(),style: TextStyle(fontSize: 15,color: Colors.grey,decoration: TextDecoration.lineThrough),),
                              ],
                            ),
                            ),
                            Padding(padding: EdgeInsets.only(top: 0),
                              child: Row(
                                children: [
                                  Text("New Price: रु",style: TextStyle(fontSize: 15,color: Colors.black),),
                                  Text((model['price']).toString(),style: TextStyle(fontSize: 15,color: Colors.black),),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Flexible(
                        child: Container(

                          // TODO Cart Item Removal Feature
                        )
                    ),
                  ],
                ),
                ),
              ],
            ),
          ),
        ),
      ),
      Divider(color: Colors.black54,)
    ],
  );
}

Widget card({Color primaryColor = Colors.redAccent, String}) {
  return Container();
}

void checkItemInCart(String productID, BuildContext context) {}
