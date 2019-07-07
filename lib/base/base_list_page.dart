import 'package:andes_flutter/base/base_page.dart';
import 'package:flutter/widgets.dart';

abstract class BaseListPage extends BasePage {}

abstract class BaseListPageState<P extends BaseListPage, D>
    extends BasePageState<P> {
  List<D> _dataList;

  @override
  void initState() {
    super.initState();
    _dataList = generateDataList();
  }

  @override
  Widget buildBody() {
    return ListView.builder(
      itemCount: _dataList?.length ?? 0,
      itemBuilder: (context, position) => _getItemWidget(position),
    );
  }

  List<D> generateDataList();

  Widget _getItemWidget(int position) {
    return GestureDetector(
      child: buildItemWidget(_dataList[position], position),
      onTap: () => onItemClicked(_dataList[position], position),
    );
  }

  Widget buildItemWidget(D data, int position);

  onItemClicked(D data, int position){}
}
