import 'dart:math';

import 'package:andes_flutter/base/base_page.dart';
import 'package:andes_flutter/monet/monotonex.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HeatingLineDemoPage extends BasePage {
  @override
  State createState() {
    return _HeatingLineDemoPageState();
  }
}

class _HeatingLineDemoPageState extends BasePageState<HeatingLineDemoPage> {
  var _currentIndex = 6;
  var _currentDx = 0.0;

  @override
  Widget buildBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onPanDown: (detail) {
            if (_currentDx != detail.globalPosition.dx) {
              setState(() => _currentDx = detail.globalPosition.dx);
//              print('currentDx=$_currentDx');
            }
          },
          onPanUpdate: (detail) {
            if (_currentDx != detail.globalPosition.dx) {
              setState(() => _currentDx = detail.globalPosition.dx);
//              print('currentDx=$_currentDx');
            }
          },
          child: HeatingLineWidget(
            keyPointList: createDemoKeyPoints(),
            currentIndex: (_currentDx / 36).floor(),
            height: 180.0,
            width: double.infinity,
            config: HeatingLineConfig(
                withAnimate: true,
                topToBottom: true,
                smooth: true,
                lineColor: Colors.amber,
                areaColor: null,
                areaGradient: LinearGradient(colors: [
                  Colors.amberAccent[100].withAlpha(80),
                  Colors.amber[500].withAlpha(80),
                  Colors.amber[500].withAlpha(80)
                ], begin: Alignment.center, end: Alignment.bottomCenter)),
          ),
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

  HeatingLineWidget(
      {this.keyPointList,
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
  bool _firstPaint = true;

  _HeatingLinePainter(
    this._keyPointList,
    this._currentIndex,
    this._config,
  )   : _linePainter = LinePainter(_config?.lineColor),
        _areaPainter = AreaPainter(
            _config?.areaColor, _config?.areaGradient, _config?.topToBottom);

  @override
  bool shouldRepaint(_HeatingLinePainter oldDelegate) {
//    _firstPaint = oldDelegate._firstPaint;
    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var startTime = DateTime.now().millisecondsSinceEpoch;
    var pointList = processKeyPointList(_keyPointList, size);
    if (_firstPaint) {
      _linePainter.draw(canvas, pointList, _config?.smooth);
    }
    var lineTime = DateTime.now().millisecondsSinceEpoch;
//    print('LinePainter cost = ${lineTime - startTime}');
    _areaPainter.draw(canvas, pointList, _config?.smooth, _currentIndex);
    var areaTime = DateTime.now().millisecondsSinceEpoch;
//    print('AreaPainter cost = ${areaTime - lineTime}');
    _firstPaint = false;
  }

  List<Point> processKeyPointList(List<KeyPoint> keyPointList, Size size) {
    var maxValue = 0;
    keyPointList.forEach(
        (point) => maxValue = maxValue > point.value ? maxValue : point.value);
    List pointList = List<Point>()
      ..add(Point(0, _config.topToBottom ? size.height : 0));
    var unitX = size.width / (keyPointList.length - 1);
    var unitY = maxValue == 0 ? 1 : size.height / maxValue;
    keyPointList.forEach((point) => pointList.add(Point<double>(
        point.index * unitX,
        _config.topToBottom
            ? size.height - point.value * unitY
            : point.value * unitY)));
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
  bool withAnimate;
  bool topToBottom;
  bool smooth;
  Color lineColor;
  Color areaColor;
  Gradient areaGradient;

  HeatingLineConfig(
      {this.withAnimate = false,
      this.topToBottom = false,
      this.smooth = false,
      this.lineColor,
      this.areaColor,
      this.areaGradient});
}

abstract class IPainter {
  draw(Canvas canvas, List<Point> points, bool smooth, [int endPoint]);
}

/// 顶部实线的Painter
class LinePainter implements IPainter {
  Paint _paint;

  LinePainter(Color stokeColor)
      : _paint = Paint()
          ..style = PaintingStyle.stroke
          ..color = stokeColor;

  @override
  draw(Canvas canvas, List<Point> points, bool smooth, [int endPoint = 0]) {
    assert(points != null && points.length > endPoint);
    final path = Path()
      ..moveTo(points.first.x.toDouble(), points.first.y.toDouble());
    if (smooth) {
      MonotoneX.addCurve(path, points);
    } else {
      points.forEach((p) => path.lineTo(p.x.toDouble(), p.y.toDouble()));
    }
    canvas.drawPath(path, _paint);
  }
}

/// 填充区域Painter
class AreaPainter implements IPainter {
  Paint _paint;
  Gradient _gradient;
  bool _topToBottom;

  AreaPainter(Color areaColor, this._gradient, this._topToBottom) {
    _paint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    if (areaColor != null) {
      _paint.color = areaColor;
    }
  }

  @override
  draw(Canvas canvas, List<Point> points, bool smooth, [int endPoint = 0]) {
    assert(points != null && points.length > endPoint);
    var minY = points[0].y.toDouble();
    var maxY = points[0].y.toDouble();
    points.forEach((p) {
      minY = p.y < minY ? p.y : minY;
      maxY = p.y > maxY ? p.y : maxY;
    });
    _paint.shader = _topToBottom
        ? _gradient.createShader(Rect.fromLTRB(
            points[0].x.toDouble(), minY, points[endPoint].x.toDouble(), maxY))
        : _gradient.createShader(Rect.fromLTRB(
            points[0].x.toDouble(), maxY, points[endPoint].x.toDouble(), minY));
    final path = Path()
      ..moveTo(points.first.x.toDouble(), points.first.y.toDouble());
    if (smooth) {
      MonotoneX.addCurve(path, points, endIndex: endPoint);
    } else {
      points
          .getRange(0, endPoint + 1)
          .forEach((p) => path.lineTo(p.x.toDouble(), p.y.toDouble()));
    }
    path.lineTo(points[endPoint].x.toDouble(), _topToBottom ? maxY : minY);
    canvas.drawPath(path, _paint);
  }
}
