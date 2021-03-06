import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:food/ui/location_info.dart';
import 'package:food/ui/search_info.dart';
import 'package:food/utils/route_utils.dart';

class HomeSearchSliver extends StatefulWidget {
  final String address;

  HomeSearchSliver(this.address);

  @override
  State<StatefulWidget> createState() {
    return HomeSearchSliverState();
  }
}

class HomeSearchSliverState extends State<HomeSearchSliver> {
  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      delegate: HomeSearchDelegate(widget.address),
      pinned: true,
    );
  }
}

class HomeSearchDelegate extends SliverPersistentHeaderDelegate {
  final double _minExtent = 50;

  final String _address;

  HomeSearchDelegate(this._address);

  double _convertAlpha(double shrinkOffset) {
    double offset = shrinkOffset / (maxExtent - minExtent);
    return offset > 1 ? 0 : 1 - offset;
  }

  Widget _createSearch(BuildContext context) {
    return FlatButton(
      onPressed: () {
        var url = 'sample://search_info';
        RouteUtils.launch(context, SearchInfo(), url);
      },
      color: Color(0xFFF0F0F0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 5, right: 5),
            child: Image.asset('images/ahh.png', width: 15, height: 15),
          ),
          Text('海底捞', style: TextStyle(color: Colors.grey))
        ],
      ),
      shape: StadiumBorder(
        side: BorderSide(color: Color(0xFFE0E0E0), width: 0.5),
      ),
    );
  }

  Widget _createLocation(BuildContext context) {
    return GestureDetector(
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Image.asset('images/ajk.png'),
            width: 30,
            height: 30,
          ),
          Expanded(
            child: Wrap(
              children: <Widget>[
                Text(_address, maxLines: 1, overflow: TextOverflow.ellipsis)
              ],
            ),
          ),
        ],
      ),
      onTap: () {
        var url = 'sample://location_info';
        Map<String, dynamic> urlParams = Map();
        urlParams['address'] = _address;
        RouteUtils.launch(context, LocationInfo(address: _address), url,
            urlParams: urlParams);
      },
    );
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: maxExtent,
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Opacity(
                opacity: _convertAlpha(shrinkOffset),
                child: Row(
                  children: <Widget>[
                    Expanded(child: _createLocation(context)),
                    Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Icon(Icons.settings, color: Colors.grey)),
                    Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Icon(Icons.sms, color: Colors.grey))
                  ],
                ),
              ),
              color: Colors.white,
            ),
          ),
          Container(
            height: _minExtent,
            margin: EdgeInsets.only(left: 10, right: 10),
            padding: EdgeInsets.only(top: 5, bottom: 5),
            child: _createSearch(context),
          )
        ],
      ),
    );
  }

  @override
  double get maxExtent => 100;

  @override
  double get minExtent => _minExtent;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
