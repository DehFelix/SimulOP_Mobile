import 'package:flutter/material.dart';

import 'package:simulop_v1/pages/home_page/home_tabs/selection_helper.dart';
import 'package:simulop_v1/locale/locales.dart';

class OU3Selection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final selectionTilesData = [
      SelectionTile(
          AppLocalizations.of(context).mcCabeThieleName,
          Icons.cast_connected,
          false,
          AppLocalizations.of(context).mcCabeThieleDescription,
          "/mcCabeThieleMethod"),
      SelectionTile(
          AppLocalizations.of(context).absorptionColumnName,
          Icons.thumb_up,
          true,
          AppLocalizations.of(context).absorptionColumnDescription),
      SelectionTile(AppLocalizations.of(context).membranesName, Icons.chat,
          true, AppLocalizations.of(context).membranesDescription),
      SelectionTile(
          AppLocalizations.of(context).crystalizerName,
          Icons.new_releases,
          true,
          AppLocalizations.of(context).crystalizerDescription),
      SelectionTile(
          AppLocalizations.of(context).distilationName,
          Icons.new_releases,
          true,
          AppLocalizations.of(context).distilationDescription),
    ];

    return ListView.builder(
      itemBuilder: (BuildContext context, int index) =>
          tileSelectionBuilder(context, selectionTilesData[index]),
      itemCount: selectionTilesData.length,
    );
  }
}
