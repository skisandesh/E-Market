// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class ItemModel {
//   String title;
//   String tag;
//   Timestamp publishedDate;
//   String thumbnailUrl;
//   String description;
//   String status;
//   int price;
//
//   ItemModel(
//       {required this.title,
//         required this.tag,
//         required this.publishedDate,
//         required this.thumbnailUrl,
//         required this.description,
//         required this.status,
//         required this.price
//         });
//
//   ItemModel.fromJson(Map<String, dynamic> json) {
//     title = json['title'];
//     tag = json['tag'];
//     publishedDate = json['publishedDate'];
//     thumbnailUrl = json['thumbnailUrl'];
//     description = json['description'];
//     status = json['status'];
//     price = json['price'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['title'] = this.title;
//     data['tag'] = this.tag;
//     data['price'] = this.price;
//     if (this.publishedDate != null) {
//       data['publishedDate'] = this.publishedDate;
//     }
//     data['thumbnailUrl'] = this.thumbnailUrl;
//     data['description'] = this.description;
//     data['status'] = this.status;
//     return data;
//   }
// }
//
// class PublishedDate {
//   String date;
//
//   PublishedDate({required this.date});
//
//   PublishedDate.fromJson(Map<String, dynamic> json) {
//     date = json['$date'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['$date'] = this.date;
//     return data;
//   }
// }
