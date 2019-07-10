import 'package:andes_flutter/base/base_list_page.dart';
import 'package:andes_flutter/util/route.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Andes Flutter', home: HomePage());
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: HomePage());
  }
}

class HomePage extends BaseListPage {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends BaseListPageState<HomePage, String> {
  @override
  String getTitle() {
    return 'HomePage';
  }

  @override
  List<String> generateDataList() {
    return ['NestedScrollView demo', 'Charts demo'];
  }

  @override
  Widget buildItemWidget(String data, int position) {
    return ListTile(title: Text(data));
  }

  @override
  onItemClicked(String data, int position) {
    switch (position) {
      case 0:
        RouteUtil.pushPage(context, ROUTE_NAME_NESTED);
        break;
      case 1:
        RouteUtil.pushPage(context, ROUTE_NAME_LINE_CHART_MONET);
        break;
    }
  }
}
