import 'package:flutter/material.dart';

import 'package:simulop_v1/pages/home_page/home_tabs/selection_helper.dart';
import 'package:simulop_v1/locale/locales.dart';

class OU1Selection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final selectionTilesData = [
      SelectionTile(
          AppLocalizations.of(context).pumpingOfLiquidsName,
          Icons.play_circle_filled,
          false,
          AppLocalizations.of(context).pumpingOfLiquidsDescription,
          "/pumpingOfFluidsInput"),
      SelectionTile(AppLocalizations.of(context).filterName, Icons.email, true,
          AppLocalizations.of(context).filterDescription),
      SelectionTile(AppLocalizations.of(context).compressorName, Icons.chat,
          true, AppLocalizations.of(context).compressorDescription),
    ];

    return ListView.builder(
      itemBuilder: (BuildContext context, int index) =>
          tileSelectionBuilder(context, selectionTilesData[index]),
      itemCount: selectionTilesData.length,
    );
  }
}
