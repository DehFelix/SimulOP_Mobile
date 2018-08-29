import 'package:flutter/material.dart';

import 'package:simulop_v1/pages/home_page/home_tabs/uo_1_selection.dart';
import 'package:simulop_v1/pages/home_page/home_tabs/uo_2_selection.dart';
import 'package:simulop_v1/pages/home_page/home_tabs/uo_3_selection.dart';
import 'package:simulop_v1/locale/locales.dart';
import 'package:simulop_v1/pages/helper_classes/app_bar_menu_itens.dart';

final helpItems = [HelpItem("info", "/default", ActionType.route)];

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  
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
          icon: Icon(Icons.home),
          text: AppLocalizations.of(context).uo1Name,
        ),
        Tab(
          icon: Icon(Icons.settings),
          text: "UO II",
        ),
        Tab(
          icon: Icon(Icons.mood),
          text: "UO III",
        ),
      ],
      controller: tabController,
    );
  }

  TabBarView makeTabBarView(tabs) {
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
          title: Text(AppLocalizations.of(context).title),
          bottom: makeTabBar(),
          actions: <Widget>[
            PopupMenuButton(
              itemBuilder: (context) => _appBarMenu(),
              onSelected: _selectMenu,
            ),
          ],
        ),
        body: makeTabBarView(<Widget>[
          OU1Selection(),
          OU2Selection(),
          OU3Selection(),
        ]));
  }

  void _selectMenu(dynamic item) {
    Navigator.of(context).pushNamed(item.action);
  }

  List<Widget> _appBarMenu() {
    return helpItems.map((HelpItem item) {
      return PopupMenuItem(
        value: item,
        child: Text(item.name),
      );
    }).toList();
  }
}
