import 'package:flutter/material.dart';

import 'package:simulop_v1/pages/home_page/home_tabs/selection_helper.dart';
import 'package:simulop_v1/locale/locales.dart';

class OU1Selection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final selectionTilesData = [
      SelectionTile(
          title: AppLocalizations.of(context).pumpingOfLiquidsName,
          description: AppLocalizations.of(context).pumpingOfLiquidsDescription,
          isDisable: false,
          imagePath: "assets/icon/ic_pump.png",
          route: "/pumpingOfFluidsInput"),
      SelectionTile(
        title: AppLocalizations.of(context).filterName,
        description: AppLocalizations.of(context).filterDescription,
        imagePath: "assets/icon/ic_filter.png",
        isDisable: true,
      ),
      SelectionTile(
        title: AppLocalizations.of(context).compressorName,
        description: AppLocalizations.of(context).compressorDescription,
        isDisable: true,
        imagePath: "assets/icon/ic_compressor.png",
      ),
    ];

    return ListView.builder(
      itemBuilder: (BuildContext context, int index) =>
          tileSelectionBuilder(context, selectionTilesData[index]),
      itemCount: selectionTilesData.length,
    );
  }
}
