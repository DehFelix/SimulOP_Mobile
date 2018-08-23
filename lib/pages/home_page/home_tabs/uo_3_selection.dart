import 'package:flutter/material.dart';

import 'package:simulop_v1/pages/home_page/home_tabs/selection_helper.dart';

class OU3Selection extends StatelessWidget {

  final selectionTilesData = [
    SelectionTile("dsd", Icons.cast_connected, "The McCabe–Thiele method is considered to be the simplest and perhaps most instructive method for the analysis of binary distillation. It uses the fact that the composition at each theoretical tray (or equilibrium stage) is completely determined by the mole fraction of one of the two components and is based on the assumption of constant molar overflow."),
    SelectionTile("sds", Icons.thumb_up, "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras viverra non nibh nec eleifend. Fusce eget lorem risus. Quisque rutrum mollis turpis. Pellentesque egestas condimentum diam in ultricies. Suspendisse finibus consectetur eros, in blandit arcu tincidunt sed. Sed a varius justo. Quisque iaculis metus sit amet vehicula pulvinar. Nunc sodales.")
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
