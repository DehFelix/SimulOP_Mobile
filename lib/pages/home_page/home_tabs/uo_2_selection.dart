import 'package:flutter/material.dart';

import 'package:simulop_v1/pages/home_page/home_tabs/selection_helper.dart';
import 'package:simulop_v1/locale/locales.dart';

class OU2Selection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final selectionTilesData = [
      SelectionTile(
          title: AppLocalizations.of(context).doublePipeHeatXName,
          description: AppLocalizations.of(context).doublePipeHeatXDescription,
          isDisable: false,
          imagePath: "assets/icon/ic_double_pipe.png",
          route: "/doublePipeHeatX"),
      SelectionTile(
        title: AppLocalizations.of(context).multiPipeHeatXName,
        description: AppLocalizations.of(context).multiPipeHeatXDescription,
        isDisable: true,
        imagePath: "assets/icon/ic_heat_exchanger.png",
      ),
      SelectionTile(
        title: AppLocalizations.of(context).evaporatorsName,
        description: AppLocalizations.of(context).evaporatorsDescription,
        isDisable: true,
        imagePath: "assets/icon/ic_water_steam.png",
      ),
      SelectionTile(
        title: AppLocalizations.of(context).dryerName,
        description: AppLocalizations.of(context).dryerDescription,
        isDisable: true,
        imagePath: "assets/icon/ic_dryer.png",
      ),
      SelectionTile(
        title: AppLocalizations.of(context).coolingTowerName,
        description: AppLocalizations.of(context).coolingTowerDescription,
        isDisable: true,
        imagePath: "assets/icon/ic_cooling_tower.png",
      ),
    ];

    return ListView.builder(
      itemBuilder: (BuildContext context, int index) =>
          tileSelectionBuilder(context, selectionTilesData[index]),
      itemCount: selectionTilesData.length,
    );
  }
}
