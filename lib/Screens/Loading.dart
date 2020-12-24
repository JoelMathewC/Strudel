import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).canvasColor,
        body: Center(
          child: SpinKitRotatingCircle(
            color: Theme.of(context).accentColor,
            size: 50.0,
          ),
        ));
  }
}
