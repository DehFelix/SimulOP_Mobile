import 'package:flutter/material.dart';

import 'package:simulop_v1/pages/home_page/home_tabs/selection_helper.dart';
import 'package:simulop_v1/locale/locales.dart';

class OU3Selection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final selectionTilesData = [
      SelectionTile(
        title: AppLocalizations.of(context).mcCabeTheileName,
        description: AppLocalizations.of(context).mcCabeTheileDescription,
        isDisable: false,
        imagePath: "assets/icon/ic_mc_cabe_thiele.png",
        route: "/mcCabeThieleMethod",
      ),
      SelectionTile(
        title: AppLocalizations.of(context).absorptionColumnName,
        description: AppLocalizations.of(context).absorptionColumnDescription,
        isDisable: false,
        imagePath: "assets/icon/ic_absorbtion_columns.png",
        route: "/absorption_columns",
      ),
      SelectionTile(
        title: AppLocalizations.of(context).membranesName,
        description: AppLocalizations.of(context).membranesDescription,
        isDisable: true,
        imagePath: "assets/icon/ic_separation_membrane.png",
      ),
      SelectionTile(
        title: AppLocalizations.of(context).crystalizerName,
        description: AppLocalizations.of(context).crystalizerDescription,
        isDisable: true,
        imagePath: "assets/icon/ic_crystal.png"
      ),
      SelectionTile(
        title: AppLocalizations.of(context).distilationColumnName,
        description: AppLocalizations.of(context).distilationColumnDescription,
        isDisable: true,
        imagePath: "assets/icon/ic_distillation_column.png",
        route: "/mcCabeThieleMethodAnimated",
      ),
    ];

    return ListView.builder(
      itemBuilder: (BuildContext context, int index) =>
          tileSelectionBuilder(context, selectionTilesData[index]),
      itemCount: selectionTilesData.length,
    );
  }
}
