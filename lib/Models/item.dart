import 'package:cloud_firestore/cloud_firestore.dart';

class ItemModel {
  late String title;
  late String tag;
  late Timestamp publishedDate;
  late String thumbnailUrl;
  late String description;
  late String status;
  late double price;

  ItemModel({required this.title,
    required this.tag,
    required this.publishedDate,
    required this.thumbnailUrl,
    required this.description,
    required this.status,
    required this.price
  });

   // ItemModel.fromData(Map<String,dynamic> json):
   //  title = json['title'],
   //  tag = json['tag'],
   //  publishedDate = json['publishedDate'],
   //  thumbnailUrl = json['thumbnailUrl'],
   //  description = json['description'],
   //  status = json['status'],
   //  price = json['price'];

  factory ItemModel.fromJson(Map<String,dynamic> json){
    return new ItemModel(
      title : json['title'] as String,
      tag : json['tag'] as String,
      publishedDate : json['publishedDate'] as Timestamp,
      thumbnailUrl : json['thumbnailUrl'] as String,
      description : json['description'] as String,
      status : json['status'] as String,
      price : json['price'] as double,
    );}

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['tag'] = this.tag;
    data['price'] = this.price;
    if (this.publishedDate != null) {
      data['publishedDate'] = this.publishedDate;
    }
    data['thumbnailUrl'] = this.thumbnailUrl;
    data['description'] = this.description;
    data['status'] = this.status;
    return data;
  }
}

class PublishedDate {
  late String date;

  PublishedDate({required this.date});

  PublishedDate.fromJson(Map<String, dynamic> json) {
    date = json['$date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$date'] = this.date;
    return data;
  }
}
