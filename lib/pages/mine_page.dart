import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food/ui/mine_card.dart';
import 'package:food/ui/mine_member_card.dart';
import 'package:food/ui/mine_user_info.dart';
import 'package:food/ui/system_settings.dart';
import 'package:food/utils/route_utils.dart';

/// 我的
class MinePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MineState();
  }
}

class MineState extends State with AutomaticKeepAliveClientMixin {
  /// 标题字体透明度
  double _alpha = 0;

  /// 标题栏高度
  double _appBarHeight = 0;

  /// 用户头像文件缓存路径
  String _path;

  /// EventChannel
  EventChannel _eventChannel;

  final GlobalKey<MineUserInfoState> globalKey = GlobalKey();

  /// 创建AppBar
  AppBar _createAppBar() {
    AppBar appBar = AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      title: Opacity(opacity: _alpha, child: Text('我的')),
      textTheme: TextTheme(title: TextStyle(color: Colors.black, fontSize: 16)),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.settings, color: Colors.grey),
          onPressed: () {
            var url = 'sample://system_settings';
            RouteUtils.launch(context, SystemSettings(), url);
          },
        ),
        IconButton(
          icon: Icon(Icons.sms, color: Colors.grey),
          onPressed: () {},
        ),
      ],
    );
    _appBarHeight = appBar.preferredSize.height;
    return appBar;
  }

  Widget _createItem(String path, String text) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 0.1, color: Color(0xFF999999)),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: Image.asset(path, width: 25, height: 25),
              ),
              Expanded(child: Text(text)),
              Image.asset('images/ble.png', width: 15, height: 15),
            ],
          ),
        ),
      ),
      onTap: () => RouteUtils.launchUndone(context, text),
    );
  }

  void _onScroll(double pixels) {
    double value = pixels / _appBarHeight;
    if (value >= 1) {
      value = 1;
    } else if (_alpha != 0) {
      value = 0;
    } else {
      return;
    }
    setState(() => _alpha = value);
  }

  void _onData(Object data) {
    setState(() {
      _path = data.toString();
      globalKey.currentState.changedPath(_path);
    });
  }

  void _onError(Object error) {}

  @override
  void initState() {
    super.initState();
    _eventChannel = EventChannel('event_channel');
    _eventChannel
        .receiveBroadcastStream('flutter event channel')
        .listen(_onData, onError: _onError, cancelOnError: true);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: _createAppBar(),
      backgroundColor: Colors.white,
      body: NotificationListener(
        onNotification: (notification) {
          if (notification is ScrollUpdateNotification &&
              notification.depth == 0) {
            _onScroll(notification.metrics.pixels);
          }
          return false;
        },
        child: ListView(
          children: <Widget>[
            MineUserInfo(key: globalKey, path: _path),
            MineMemberCard(),
            Row(
              children: <Widget>[
                MineCard('红包卡券', '12', '个未使用'),
                MineCard('津贴', '¥20', '可用'),
                MineCard('钱包', null, '金币、借钱、福利'),
              ],
            ),
            _createItem('images/bdt.png', '我的收藏'),
            _createItem('images/bdy.png', '我的客服'),
            _createItem('images/bdl.png', '我的地址'),
            _createItem('images/bdu.png', '推荐有奖'),
            _createItem('images/bdi.png', '商务合作'),
            _createItem('images/bdo.png', '办卡有礼'),
            _createItem('images/bdr.png', '3小时公益'),
            _createItem('images/bdp.png', '企业订餐'),
            Container(color: Colors.white70, height: 80),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
