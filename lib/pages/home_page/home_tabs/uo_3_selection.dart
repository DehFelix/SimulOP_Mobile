import 'package:flutter/material.dart';

import 'package:simulop_v1/pages/home_page/home_tabs/selection_helper.dart';

class OU3Selection extends StatelessWidget {
  final selectionTilesData = [
    SelectionTile(
        "McCabe-Thiele Method",
        Icons.cast_connected,
        false,
        "The McCabe–Thiele method is considered to be the simplest and perhaps most instructive method for the analysis of binary distillation. It uses the fact that the composition at each theoretical tray (or equilibrium stage) is completely determined by the mole fraction of one of the two components and is based on the assumption of constant molar overflow.",
        "/mcCabeThieleMethod"),
    SelectionTile("Absorption Colums", Icons.thumb_up, true,
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras viverra non nibh nec eleifend. Fusce eget lorem risus. Quisque rutrum mollis turpis. Pellentesque egestas condimentum diam in ultricies. Suspendisse finibus consectetur eros, in blandit arcu tincidunt sed. Sed a varius justo. Quisque iaculis metus sit amet vehicula pulvinar. Nunc sodales."),
    SelectionTile("Separation Membranes", Icons.chat, true,
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque gravida, mi et porta lobortis, tortor mi varius ex, eget sagittis nisi purus quis nisi. Maecenas in risus sed nunc finibus eleifend. Vivamus eu odio non lorem gravida finibus. Integer dictum purus ac hendrerit tempor. Vivamus ut fringilla augue. Maecenas iaculis."),
    SelectionTile("Crystalizer", Icons.new_releases, true,
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus id sapien dapibus, facilisis ligula at, posuere leo. Duis a nibh risus. Curabitur scelerisque diam pulvinar dolor tincidunt vehicula. Suspendisse ut finibus mi. Suspendisse dapibus erat a ligula porta, nec ornare magna luctus. Ut ultricies tempus tempus. In sem ligula, consectetur."),
    SelectionTile("Destilation Tower", Icons.new_releases, true,
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus id sapien dapibus, facilisis ligula at, posuere leo. Duis a nibh risus. Curabitur scelerisque diam pulvinar dolor tincidunt vehicula. Suspendisse ut finibus mi. Suspendisse dapibus erat a ligula porta, nec ornare magna luctus. Ut ultricies tempus tempus. In sem ligula, consectetur."),
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
