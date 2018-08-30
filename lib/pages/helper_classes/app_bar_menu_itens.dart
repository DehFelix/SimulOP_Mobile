import 'package:flutter/material.dart';

/// Helper class for [PopupMenuItem] menus.
class HelpItem {
  final String name;
  final String action;
  final ActionType actionType; 

  HelpItem(this.name, this.action, this.actionType);
}

enum ActionType {route, url, widgetAction}