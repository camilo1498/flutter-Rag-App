import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ragapp/models/notificationModel.dart';

class AnimatedBottomBar extends StatefulWidget {
  final List<BarItem> barItems;
  final Duration animationDuration;
  final Function onBarTap;
  final BarStyle barStyle;
  var profile;
  var lastIndex;

  AnimatedBottomBar(
      {this.barItems,
        this.animationDuration = const Duration(milliseconds: 500),
        this.onBarTap, this.barStyle, this.profile,this.lastIndex});

  @override
  _AnimatedBottomBarState createState() => _AnimatedBottomBarState();
}

class _AnimatedBottomBarState extends State<AnimatedBottomBar>
    with TickerProviderStateMixin {
  int selectedBarIndex = 2;
  int count = 0;
  int viewed = 0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    setState(() {
      selectedBarIndex == 0 ? selectedBarIndex =widget.lastIndex : selectedBarIndex = selectedBarIndex;
    });

    return Material(
      color: Colors.grey[900],
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15)
      ),
      elevation: 10.0,
      child: Container(
        padding: Platform.isIOS && (MediaQuery.of(context).size.height == 812 || MediaQuery.of(context).size.height == 896) ? EdgeInsets.only(
          bottom: 22.0,
          top: 8.0,
          left: 10.0,
          right: 16.0,
        ) : EdgeInsets.only(
          bottom: 8.0,
          top: 8.0,
          left: 10.0,
          right: 16.0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _buildBarItems(),
        ),
      ),
    );
  }

  List<Widget> _buildBarItems() {
    final _notifications = Provider.of<List<NotificationModel>>(context);
    int index = 0;
    int _view = 0;
    if(_notifications != null){
      _notifications.forEach((element) {
        if(element.view == false){
          setState(() {
            index = index +1;
            count = index;
          });
        }else{
          setState(() {
            _view = _view +1;
            viewed = _view;
            if(viewed == _notifications.length){
              count = 0;
            }
          });
        }
      });
    }
    List<Widget> _barItems = List();
    for (int i = 0; i < widget.barItems.length; i++) {
      BarItem item = widget.barItems[i];
      bool isSelected = selectedBarIndex == i;
      _barItems.add(InkWell(
        focusColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () {
          setState(() {
            selectedBarIndex = i;
            widget.onBarTap(selectedBarIndex);
          });
        },
        child: Stack(
          children: <Widget>[
            AnimatedContainer(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              duration: widget.animationDuration,
              decoration: BoxDecoration(
                  color: isSelected
                      ? item.color.withOpacity(0.15)
                      : Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              child: Row(
                children: <Widget>[
                  ImageIcon(
                    AssetImage(item.iconData),
                    color: isSelected ? item.color : Colors.grey[300],
                    size: 23,
                  ),
                  Visibility(
                    visible: item.text != '',
                    child: SizedBox(
                      width: 10.0,
                    ),
                  ),
                  AnimatedSize(
                    duration: widget.animationDuration,
                    curve: Curves.easeInOut,
                    vsync: this,
                    child: Text(
                      isSelected ? item.text : "",
                      style: TextStyle(
                          color: item.color,
                          fontWeight: widget.barStyle.fontWeight,
                          fontSize: 15),
                    ),
                  )
                ],
              ),
            ),
            if(i == 3)
              Visibility(
                visible: count != 0,
                child: Positioned(
                  left: 28,
                  top: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 2,horizontal: 3),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                        count.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 5
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ));
    }
    _barItems.add(widget.profile);
    return _barItems;
  }
}

class BarStyle {
  final double fontSize, iconSize;
  final FontWeight fontWeight;

  BarStyle({this.fontSize = 9.0, this.iconSize = 22, this.fontWeight = FontWeight.w600});
}

class BarItem {
  String text;
  var iconData;
  Color color;

  BarItem({this.text, this.iconData, this.color});
}