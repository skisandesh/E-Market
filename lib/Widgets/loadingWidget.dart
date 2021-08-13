import 'package:flutter/material.dart';


circularProgress() {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 12),
    child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Color(0xffe46b10)),),
  );
}

linearProgress() {
  Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 12),
    child: LinearProgressIndicator(valueColor: AlwaysStoppedAnimation(Color(0xffe46b10)),),
  );
}
