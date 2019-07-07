import 'package:andes_flutter/base/base_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

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
    return ['a', 'b'];
  }

  @override
  Widget buildItemWidget(String data) {
    return ListTile(title: Text(data));
  }

  @override
  onItemClicked(String data) {
    super.onItemClicked(data);
  }
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  ScrollController _scrollViewController;
  TabController _tabController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _scrollViewController = ScrollController(initialScrollOffset: 0.0);
    _tabController = TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollViewController.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 1.0,
          title: Text("Andes"),
          backgroundColor: Colors.lightGreen,
        ),
        body: null);
  }

  _buildNestedDemo() {
    return NestedScrollView(
        controller: _scrollViewController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              pinned: true,
              floating: true,
              expandedHeight: 280,
              backgroundColor: Colors.lightGreen,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Container(
                  //头部整个背景颜色
                  height: double.infinity,
                  color: Color(0xffcccccc),
                  child: Column(
                    children: <Widget>[
                      _buildBanner(),
                      _buildButtons(),
                      _buildTabBarBg()
                    ],
                  ),
                ),
              ),
              bottom: TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.lightGreen,
                  tabs: [
                    Tab(text: "aaa"),
                    Tab(text: "bbb"),
                    Tab(text: "ccc"),
                  ]),
            )
          ];
        },
        body: TabBarView(controller: _tabController, children: [
          _buildListView("aaa:"),
          _buildListView("bbb:"),
          _buildListView("ccc:"),
        ]));
  }

  Widget _buildBanner() {
    return Container(
      margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 12.0),
      height: 144,
      child: Swiper(
          //第三方的banner库：flutter_swiper
          itemBuilder: (BuildContext context, int index) {
            return Image.network(
              "https://github.com/best-flutter/flutter_swiper/raw/master/banner.jpg",
            );
          },
          itemCount: 3,
          scale: 0.9,
          pagination: new SwiperPagination()),
    );
  }

  //banner下面的按钮
  Widget _buildButtons() {
    return Expanded(
      child: Row(
        children: <Widget>[
          _buildButtonItem(Icons.chat, "xxxx"),
          Image.asset("assets/images/phone_flow_chart_arrow.png", height: 8),
          _buildButtonItem(Icons.pages, "xxxx"),
          Image.asset("assets/images/phone_flow_chart_arrow.png", height: 8),
          _buildButtonItem(Icons.phone_android, "xxxx"),
          Image.asset("assets/images/phone_flow_chart_arrow.png", height: 8),
          _buildButtonItem(Icons.print, "xxxx"),
        ],
      ),
    );
  }

  Widget _buildButtonItem(IconData icon, String text) {
    return Expanded(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(icon, size: 28.0),
        Container(
          margin: EdgeInsets.only(top: 8.0),
          child: Text(text,
              style: TextStyle(color: Color(0xff999999), fontSize: 12)),
        )
      ],
    ));
  }

  Widget _buildTabBarBg() {
    return Container(
      //TabBar圆角背景颜色
      height: 50,
      child: ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          child: Container(color: Colors.lightGreen)),
    );
  }

  Widget _buildListView(String s) {
    return ListView.separated(
        itemCount: 20,
        separatorBuilder: (BuildContext context, int index) => Divider(
              color: Colors.grey,
              height: 1,
            ),
        itemBuilder: (BuildContext context, int index) {
          return Container(
              color: Colors.white,
              child: ListTile(title: Text("$s第$index 个条目")));
        });
  }
}
