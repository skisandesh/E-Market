import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget
{
  final TextEditingController controller;
  final IconData data;
  final String hintText;
  bool isObsecure = true;
  CustomTextField(
      {required Key key, required this.controller, required this.data, required this.hintText,required this.isObsecure}
      ) : super(key: key);



  @override
  Widget build(BuildContext context)
  {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xfff3f3f4),
        borderRadius: BorderRadius.all(Radius.circular(10.0))
      ),
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.all(5.0),
      child: TextFormField(
        controller: controller,
        obscureText: isObsecure,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(data,color: Theme.of(context).primaryColor,),
          focusColor: Theme.of(context).primaryColor,
          hintText: hintText,
        ),

      ),
    );
  }
}
