import 'dart:ffi';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_market/Admin/adminLogin.dart';
import 'package:e_market/Admin/adminShiftOrders.dart';
import 'package:e_market/Widgets/loadingWidget.dart';
import 'package:e_market/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as ImD;

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> with AutomaticKeepAliveClientMixin<UploadPage> {
  bool get wantKeepAlive => true;
  late File? file = null;
  final _discriptionTextEditingController = TextEditingController();
  final _priceTextEditingController = TextEditingController();
  final _titleTextEditingController = TextEditingController();
  final _tagTextEditingController = TextEditingController();
  String _productId = DateTime.now().millisecondsSinceEpoch.toString();
  bool _isUploading = false;



  @override
  Widget build(BuildContext context) {
    return file == null? displayAdminHomeScreen() : displayAdminUploadFormScreen();
  }

  displayAdminHomeScreen() {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.border_color,
            color: Colors.white,
          ),
          onPressed: () {
            Route route = MaterialPageRoute(builder: (c) => AdminShiftOrders());
            Navigator.push(context, route);
          },
        ),
        actions: [
          TextButton(
            child: Text(
              'logout',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Route route = MaterialPageRoute(builder: (c) => SplashScreen());
              Navigator.push(context, route);
            },
          ),
        ],
      ),
      body: AdminHomeBody(),
    );
  }

  AdminHomeBody() {
    return Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shop_two,
              size: 200,
              color: Color(0xffe46b10),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: ElevatedButton(
                child: Text(
                  'Add new item',
                  style: TextStyle(color: Colors.white),
                ),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xffe46b10))),
                onPressed: () => takeImage(context),
              ),
            )
          ],
        ),
      ),
    );
  }

  takeImage(context) {
    return showDialog(
        context: context,
        builder: (c) {
          return SimpleDialog(
            title: Text(
              'Select Image',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Color(0xffe46b10)),
            ),
            children: [
              SimpleDialogOption(
                child: Text('Camera'),
                onPressed: _captureImage,
              ),
              SimpleDialogOption(
                child: Text('Gallery'),
                onPressed: _pickFromGallery,
              ),
              SimpleDialogOption(
                child: IconButton(
                  icon: Icon(
                    Icons.cancel,
                    size: 40,
                    color: Colors.orange,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          );
        }
        );
  }
  _captureImage()async{
    Navigator.pop(context);
    final _picker = ImagePicker();
    XFile? imageFile = await _picker.pickImage(source: ImageSource.camera,maxHeight: 680.0,maxWidth: 970.0);
    setState(() {
      file = File(imageFile!.path);
    });
  }

  _pickFromGallery()async{
    Navigator.pop(context);
    final _picker = ImagePicker();
    XFile? imageFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      file = File(imageFile!.path);
    });
  }


  displayAdminUploadFormScreen(){
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: clearFormInfo,
        ),
        title: Text('New Product'),
        actions: [
          IconButton(onPressed: _isUploading ? null: ()=>uploadItem(), icon: Icon(Icons.save,color: Colors.white,))
        ],
      ),
      body: ListView(
        children: [
          _isUploading? circularProgress():Text(''),
          Container(
            height: 230.0,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16/9,
                child: Container(
                  decoration: BoxDecoration(image: DecorationImage(image: FileImage(file!),fit: BoxFit.cover)),
                ),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 12)),
          ListTile(
            leading: Icon(Icons.perm_device_information,color: Color(0xffe46b10),),
            title: Container(
              width: 250,
              child: TextField(
                controller: _tagTextEditingController,
                decoration: InputDecoration(
                  hintText: 'Tag',
                  hintStyle: TextStyle(color: Colors.grey),
                  focusColor: Color(0xffe46b10),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffe46b10)),
                  )

                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.perm_device_information,color: Color(0xffe46b10),),
            title: Container(
              width: 250,
              child: TextField(
                controller: _titleTextEditingController,
                decoration: InputDecoration(
                    hintText: 'Title',
                    hintStyle: TextStyle(color: Colors.grey),
                    focusColor: Color(0xffe46b10),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffe46b10)),
                  )
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.perm_device_information,color: Color(0xffe46b10),),
            title: Container(
              width: 250,
              child: TextField(
                controller: _discriptionTextEditingController,
                decoration: InputDecoration(
                    hintText: 'Description',
                    hintStyle: TextStyle(color: Colors.grey),
                    focusColor: Color(0xffe46b10),
                    focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffe46b10)),
                ),
              ),
            ),
          ),
          ),
          ListTile(
            leading: Icon(Icons.perm_device_information,color: Color(0xffe46b10),),
            title: Container(
              width: 250,
              child: TextField(
                keyboardType: TextInputType.number,
                controller: _priceTextEditingController,
                decoration: InputDecoration(
                  hintText: 'Price',
                  hintStyle: TextStyle(color: Colors.grey),
                  focusColor: Color(0xffe46b10),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffe46b10)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  clearFormInfo(){
    setState(() {
      file = null;
      _discriptionTextEditingController.clear();
      _tagTextEditingController.clear();
      _priceTextEditingController.clear();
      _tagTextEditingController.clear();
    });
  }


  // To upload item to FireStore
  uploadItem()async{
    setState(() {
      _isUploading = true;
    });
    String imageDownloadUrl = await upLoadImage(file);
    saveItemInfo(imageDownloadUrl);
    print('hey');
  }


  // To upload image into Storage
  Future<String> upLoadImage(fileImage)async{
    final storageRef = FirebaseStorage.instance.ref().child('Items Images');
    final uploadTask = storageRef.child('product_$_productId.jpg').putFile(fileImage);
    String downloadUrl = await uploadTask.then((res) {
      final  url = res.ref.getDownloadURL();
      return url;
    });
    return downloadUrl;
  }

// Finally to store imageurl with item data to firestore
  saveItemInfo(String imageUrl){
    final itemRef = FirebaseFirestore.instance.collection('items');
    itemRef.doc(_productId).set({
      'tag' : _tagTextEditingController.text.trim(),
      'description': _discriptionTextEditingController.text.trim(),
      'title': _titleTextEditingController.text.trim(),
      'price': _priceTextEditingController.text.trim(),
      'publishedDate':DateTime.now(),
      'status': 'available',
      'thumbnailUrl': imageUrl,
    });
    setState(() {
      file = null;
      _isUploading = false;
      _productId = DateTime.now().millisecondsSinceEpoch.toString();
      _tagTextEditingController.clear();
      _discriptionTextEditingController.clear();
      _titleTextEditingController.clear();
      _priceTextEditingController.clear();
    });
  }

}
