import 'package:flutter/material.dart';

import 'package:simulop_v1/pages/home_page/home_tabs/selection_helper.dart';
import 'package:simulop_v1/locale/locales.dart';

class OU2Selection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final selectionTilesData = [
      SelectionTile(
          AppLocalizations.of(context).doublePipeName,
          Icons.home,
          false,
          AppLocalizations.of(context).doublePipeDescription,
          "/doublePipeHeatX"),
      SelectionTile(AppLocalizations.of(context).multiPipeName, Icons.email,
          true, AppLocalizations.of(context).multiPipeDescription),
      SelectionTile(AppLocalizations.of(context).evaporatorName, Icons.chat,
          true, AppLocalizations.of(context).evaporatorDescription),
      SelectionTile(AppLocalizations.of(context).dryerName, Icons.new_releases,
          true, AppLocalizations.of(context).dryerDescription),
      SelectionTile(
          AppLocalizations.of(context).coolingTowerName,
          Icons.network_wifi,
          true,
          AppLocalizations.of(context).coolingTowerDescription),
    ];

    return ListView.builder(
      itemBuilder: (BuildContext context, int index) =>
          tileSelectionBuilder(context, selectionTilesData[index]),
      itemCount: selectionTilesData.length,
    );
  }
}
