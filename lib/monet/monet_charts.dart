import 'package:andes_flutter/base/base_page.dart';
import 'package:andes_flutter/monet/line_charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MonetPage extends BasePage {
  @override
  State createState() {
    return MonetPageState();
  }
}

class MonetPageState extends BasePageState<MonetPage> {
  Widget _chartContent;
  List<String> _chartNameList;

  @override
  void initState() {
    super.initState();
    _chartContent = Icon(Icons.show_chart);
    _chartNameList = [
      SimpleLineChart.name,
      PointsLineChart.name,
      StackedAreaLineChart.name,
      StackedAreaCustomColorLineChart.name,
      AreaAndLineChart.name,
      SimpleNullsLineChart.name,
      StackedAreaNullsLineChart.name,
      DashPatternLineChart.name,
      SegmentsLineChart.name,
      LineLineAnnotationChart.name,
      LineRangeAnnotationChart.name,
      LineRangeAnnotationMarginChart.name
    ];
  }

  @override
  Widget buildBody() {
    return Container(
      height: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 200,
            width: double.infinity,
            child: _chartContent,
            color: Colors.blue[100],
          ),
          Expanded(
            child: Container(
              color: Colors.blue[600],
              child: ListView.builder(
                  itemCount: _chartNameList.length,
                  itemBuilder: (context, position) => GestureDetector(
                        child: ListTile(
                            title: Text(_chartNameList[position],
                                style: TextStyle(color: Colors.black))),
                        onTap: () {
                          setState(() => _chartContent =
                              _getChart(_chartNameList[position]));
                        },
                      )),
            ),
          )
        ],
      ),
    );
  }

  @override
  String getTitle() {
    return 'Monet';
  }

  Widget _getChart(String name) {
    if (name == SimpleLineChart.name) {
      return SimpleLineChart.withSampleData();
    } else if (name == PointsLineChart.name) {
      return PointsLineChart.withSampleData();
    } else if (name == StackedAreaLineChart.name) {
      return StackedAreaLineChart.withSampleData();
    } else if (name == StackedAreaCustomColorLineChart.name) {
      return StackedAreaCustomColorLineChart.withSampleData();
    } else if (name == AreaAndLineChart.name) {
      return AreaAndLineChart.withSampleData();
    } else if (name == SimpleNullsLineChart.name) {
      return SimpleNullsLineChart.withSampleData();
    } else if (name == StackedAreaNullsLineChart.name) {
      return StackedAreaNullsLineChart.withSampleData();
    } else if (name == DashPatternLineChart.name) {
      return DashPatternLineChart.withSampleData();
    } else if (name == SegmentsLineChart.name) {
      return SegmentsLineChart.withSampleData();
    } else if (name == LineLineAnnotationChart.name) {
      return LineLineAnnotationChart.withSampleData();
    } else if (name == LineRangeAnnotationChart.name) {
      return LineRangeAnnotationChart.withSampleData();
    } else if (name == LineRangeAnnotationMarginChart.name) {
      return LineRangeAnnotationMarginChart.withSampleData();
    } else {
      return null;
    }
  }
}
