import 'dart:math';

import 'package:andes_flutter/base/base_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HeatingLineDemoPage extends BasePage {
  @override
  State createState() {
    return _HeatingLineDemoPageState();
  }
}

class _HeatingLineDemoPageState extends BasePageState<HeatingLineDemoPage> {
  @override
  Widget buildBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        HeatingLineWidget(
          keyPointList: createDemoKeyPoints(),
          currentIndex: 6,
          config: HeatingLineConfig(
              true,
              Colors.amber,
              Colors.amberAccent,
              LinearGradient(colors: [
                Colors.amberAccent[100].withAlpha(80),
                Colors.amberAccent[100].withAlpha(80),
                Colors.amber[500].withAlpha(80)
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        )
      ],
    );
  }

  @override
  String getTitle() {
    return 'Heating Line Demo';
  }

  List<KeyPoint> createDemoKeyPoints() {
    var values = [1, 3, 8, 15, 10, 12, 21, 14, 10, 3];
    var list = List<KeyPoint>();
    var index = 0;
    values.forEach((v) => list.add(KeyPoint(index++, v)));
    return list;
  }
}

class HeatingLineWidget extends StatefulWidget {
  final List<KeyPoint> keyPointList;
  final int currentIndex;
  final HeatingLineConfig config;
  final double width;
  final double height;

  HeatingLineWidget({this.keyPointList,
    this.currentIndex,
    this.config,
    this.height,
    this.width});

  @override
  State<StatefulWidget> createState() {
    return _HeatingLineWidgetState();
  }
}

class _HeatingLineWidgetState extends State<HeatingLineWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      alignment: Alignment.center,
      color: Colors.lightBlue.withAlpha(50),
      child: CustomPaint(
        painter: _HeatingLinePainter(
            widget.keyPointList, widget.currentIndex, widget.config),
        size: Size(widget.width, widget.height),
      ),
    );
  }
}

class _HeatingLinePainter extends CustomPainter {
  final List<KeyPoint> _keyPointList;
  final int _currentIndex;
  final HeatingLineConfig _config;
  final IPainter _linePainter;
  final IPainter _areaPainter;

  _HeatingLinePainter(this._keyPointList, this._currentIndex, this._config)
      : _linePainter = LinePainter(_config?._lineColor),
        _areaPainter = AreaPainter(_config?._areaColor, _config?._areaGradient);

  @override
  bool shouldRepaint(_HeatingLinePainter oldDelegate) {
    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var pointList = processKeyPointList(_keyPointList, size);
    _linePainter.draw(canvas, pointList);
    _areaPainter.draw(canvas, pointList);
  }

  List<Point> processKeyPointList(List<KeyPoint> keyPointList, Size size) {
    var maxValue = 0;
    keyPointList.forEach(
            (point) =>
        maxValue = maxValue > point.value ? maxValue : point.value);
    List pointList = List<Point>();
    var unitX = size.width / (keyPointList.length - 1);
    var unitY = maxValue == 0 ? 1 : size.height / maxValue;
    keyPointList.forEach((point) =>
        pointList.add(Point<double>(point.index * unitX, point.value * unitY)));
    return pointList;
  }
}

class KeyPoint {
  final int _index;
  final int _value;

  KeyPoint(this._index, this._value);

  get index => _index;

  get value => _value;
}

class HeatingLineConfig {
  bool _withAnimate;
  Color _lineColor;
  Color _areaColor;
  Gradient _areaGradient;

  HeatingLineConfig(this._withAnimate, this._lineColor, this._areaColor,
      this._areaGradient);
}

abstract class IPainter {
  draw(Canvas canvas, List<Point> points, [int endPoint]);
}

class LinePainter implements IPainter {
  Paint _paint;

  LinePainter(Color stokeColor)
      : _paint = Paint()
    ..style = PaintingStyle.stroke
    ..color = stokeColor;

  @override
  draw(Canvas canvas, List<Point> points, [int endPoint = 0]) {
    assert(points != null && points.length > endPoint);
    final path = Path()
      ..moveTo(points.first.x.toDouble(), points.first.y.toDouble());
    points.forEach((p) => path.lineTo(p.x.toDouble(), p.y.toDouble()));
    canvas.drawPath(path, _paint);
  }
}

class AreaPainter implements IPainter {
  Paint _paint;
  Gradient _gradient;

  AreaPainter(Color areaColor, this._gradient)
      : _paint = Paint()
    ..style = PaintingStyle.fill
    ..isAntiAlias = true
    ..color = areaColor;

  @override
  draw(Canvas canvas, List<Point> points, [int endPoint = 0]) {
    assert(points != null && points.length > endPoint);
    _paint.shader = _gradient.createShader(Rect.fromLTRB(
        points[0].x, points[0].y, points[endPoint].x, points[endPoint].y));
    final path = Path()
      ..moveTo(points.first.x.toDouble(), points.first.y.toDouble());
    points.forEach((p) {
      path.lineTo(p.x.toDouble(), p.y.toDouble());
    });
//    path.lineTo(points.last.x, )
    canvas.drawPath(path, _paint);
  }
}
