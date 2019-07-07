import 'package:andes_flutter/base/base_page.dart';
import 'package:andes_flutter/biz/nested_scroll.dart';
import 'package:andes_flutter/monet/monet.dart';
import 'package:flutter/widgets.dart';

const ROUTE_NAME_NESTED = 'route_name_nested';
const ROUTE_NAME_MONET = 'route_name_monet';

class RouteUtil {
  static pushPage(BuildContext context, String route) {
    Navigator.of(context)
        .push(RightInRoute(_getRouterPageBuilder(context, route)));
  }

  static WidgetBuilder _getRouterPageBuilder(
      BuildContext context, String route) {
    BasePage widget;
    switch (route) {
      case ROUTE_NAME_NESTED:
        widget = NestedScrollPage();
        break;
      case ROUTE_NAME_MONET:
        widget = MonetPage();
        break;
    }
    return (context) => widget;
  }
}

const Duration ROUTE_TRANSITION_DURATION = const Duration(milliseconds: 300);

class RightInRoute extends PageRouteBuilder {
  final WidgetBuilder widgetBuilder;

  RightInRoute(this.widgetBuilder, {Duration duration, RouteSettings settings})
      : super(
            settings: settings,
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return widgetBuilder(context);
            },
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child) {
              return new SlideTransition(
                position: new Tween<Offset>(
                        begin: const Offset(1.0, 0.0), end: Offset.zero)
                    .animate(animation),
                child: child,
              );
            },
            transitionDuration: duration ?? ROUTE_TRANSITION_DURATION);
}
