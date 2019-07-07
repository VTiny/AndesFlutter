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
      itemBuilder: (context, position) => _getItemWidget(_dataList[position]),
    );
  }

  List<D> generateDataList();

  Widget _getItemWidget(D data) {
    return GestureDetector(
      child: buildItemWidget(data),
      onTap: () => onItemClicked(data),
    );
  }

  Widget buildItemWidget(D data);

  onItemClicked(D data){}
}
