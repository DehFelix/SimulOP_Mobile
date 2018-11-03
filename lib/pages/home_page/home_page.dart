import 'package:flutter/material.dart';

import 'package:simulop_v1/pages/home_page/home_tabs/uo_1_selection.dart';
import 'package:simulop_v1/pages/home_page/home_tabs/uo_2_selection.dart';
import 'package:simulop_v1/pages/home_page/home_tabs/uo_3_selection.dart';
import 'package:simulop_v1/locale/locales.dart';
import 'package:simulop_v1/pages/helper_classes/app_bar_menu_itens.dart';
import 'package:url_launcher/url_launcher.dart';

final helpItems = [HelpItem("info", "/default", ActionType.route)];

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  TabBar makeTabBar() {
    return TabBar(
      tabs: <Tab>[
        Tab(
          icon: Image.asset("assets/icon/ic_pump.png", scale: 1.8, color: Colors.white54,),
          text: AppLocalizations.of(context).ouIName,
        ),
        Tab(
          icon: Image.asset("assets/icon/ic_heat_exchanger.png", scale: 1.8, color: Colors.white54,),
          text: AppLocalizations.of(context).ouIIName,
        ),
        Tab(
          icon: Image.asset("assets/icon/ic_absorbtion_columns.png", scale: 1.8, color: Colors.white54,),
          text: AppLocalizations.of(context).ouIIIName,
        ),
      ],
      controller: tabController,
    );
  }

  TabBarView makeTabBarView(List<Widget> tabs) {
    return TabBarView(
      children: tabs,
      controller: tabController,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(AppLocalizations.of(context).simulop),
        bottom: makeTabBar(),
        actions: <Widget>[
          PopupMenuButton(
            itemBuilder: (context) => _appBarMenu(),
            onSelected: _selectMenu,
          ),
        ],
      ),
      body: makeTabBarView(
        <Widget>[
          OU1Selection(),
          OU2Selection(),
          OU3Selection(),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          "POLI-USP. Engenharia Química. AndréAntonio, RafaelTerras, prof.MoisésTeles",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16.0, color: Colors.grey[600]),
        ),
      ),
    );
  }

  List<PopupMenuItem> _appBarMenu() {
    return helpItems.map((HelpItem item) {
      return PopupMenuItem(
        value: item,
        child: Text(item.name),
      );
    }).toList();
  }

  void _lunchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw "Could not lunch $url";
    }
  }

  void _selectMenu(dynamic element) {
    var item = element as HelpItem;
    switch (item.actionType) {
      case ActionType.route:
        Navigator.of(context).pushNamed(item.action);
        break;
      case ActionType.url:
        _lunchURL(item.action);
        break;
      case ActionType.widgetAction:
        break;
      default:
    }
  }
}
