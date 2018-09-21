import 'package:flutter/material.dart';

import 'package:simulop_v1/pages/home_page/home_tabs/selection_helper.dart';

class OU1Selection extends StatelessWidget {
  final selectionTilesData = [
    SelectionTile(
        "Pumping of liquids",
        Icons.play_circle_filled,
        false,
        "Frint itaration of the pump Applet. See what variables affects the NPSH and how to deal with tricky liquids",
        "/pumpingOfFluidsInput"),
    SelectionTile(
        "Filters",
        Icons.email,
        true,
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam faucibus arcu id lobortis tincidunt. Mauris vitae lacinia purus. Nullam lacinia rhoncus volutpat. Phasellus sapien sapien, tempus eu lorem et, auctor elementum tortor. Mauris rhoncus erat nec lectus congue, quis cursus justo euismod. Donec at neque odio. Nam ut tempor lectus.",
        "/exemple1"),
    SelectionTile("Compressures", Icons.chat, true,
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. In ut venenatis risus. Vivamus facilisis lorem nisl, at semper enim sodales sit amet. Vivamus ante diam, interdum sit amet ipsum quis, efficitur pharetra nulla. Phasellus at cursus massa. Ut sagittis turpis diam, elementum pretium dui tincidunt at. Suspendisse id purus sed."),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) =>
          tileSelectionBuilder(context, selectionTilesData[index]),
      itemCount: selectionTilesData.length,
    );
  }
}
