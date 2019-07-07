import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

abstract class BasePage extends StatefulWidget {
}

abstract class BasePageState<P extends BasePage> extends State<P> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(),
    );
  }

  buildAppBar() {
    return AppBar(title: Text(getTitle(),
        style: TextStyle(fontSize: 18.0, color: Colors.black38)),
        leading: IconButton(icon: Icon(Icons.arrow_back),
            color: Colors.black38,
            onPressed: () => Navigator.pop(context)));
  }

  Widget buildBody();

  String getTitle();
}