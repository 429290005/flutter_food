import 'package:flutter/material.dart';
import 'package:food/model/home_tab_model.dart';
import 'package:food/ui/home_tab_view_list.dart';

class HomeTabView extends StatefulWidget {
  final List<HomeTabModel> list;
  final TabController tabController;

  HomeTabView({this.list, this.tabController});

  @override
  State<StatefulWidget> createState() {
    return HomeTabViewState();
  }
}

class HomeTabViewState extends State<HomeTabView> {
  List<Widget> _createTabView() {
    List<HomeTabModel> list = widget.list;
    List<Widget> tabViews = List();
    list.forEach((i) => tabViews.add(_createTabContent(i)));
    return tabViews;
  }

  Widget _createTabContent(HomeTabModel model) {
    return HomeTabViewList(model);
  }

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: _createTabView(),
      controller: widget.tabController,
    );
  }
}
