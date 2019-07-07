import 'package:andes_flutter/base/base_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MonetPage extends BasePage {
  @override
  State createState() {
    return MonetPageState();
  }
}

class MonetPageState extends BasePageState<MonetPage> {
  @override
  Widget buildBody() {
    return Container(
      color: Colors.amberAccent,
    );
  }

  @override
  String getTitle() {
    return 'Monet';
  }
}
