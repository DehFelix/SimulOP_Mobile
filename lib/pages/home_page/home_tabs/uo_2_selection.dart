import 'package:flutter/material.dart';

import 'package:simulop_v1/pages/home_page/home_tabs/selection_helper.dart';

class OU2Selection extends StatelessWidget {
  final selectionTilesData = [
    SelectionTile(
        "Double Pipe Heat Exchanger",
        Icons.home,
        false,
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque dignissim sed arcu ac gravida. Aenean placerat sem quis leo suscipit, quis placerat quam varius. Sed porta neque elit, sed aliquam elit pulvinar at. In consequat metus eu tellus ultricies pellentesque. Quisque ac risus ac erat faucibus tempus sed id metus.",
        "/doublePipeHeatX"),
    SelectionTile("Multi Pipe Heat Exchanger", Icons.email, true,
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse vulputate mattis nunc in elementum. Aliquam ante neque, sagittis non blandit dapibus, laoreet a tortor. Maecenas non rutrum risus, vel lacinia magna. Vivamus fringilla ut metus non dignissim. Interdum et malesuada fames ac ante ipsum primis in faucibus. Integer lobortis metus."),
    SelectionTile("Evaporator", Icons.chat, true,
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque gravida, mi et porta lobortis, tortor mi varius ex, eget sagittis nisi purus quis nisi. Maecenas in risus sed nunc finibus eleifend. Vivamus eu odio non lorem gravida finibus. Integer dictum purus ac hendrerit tempor. Vivamus ut fringilla augue. Maecenas iaculis."),
    SelectionTile("Dryers", Icons.new_releases, true,
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus id sapien dapibus, facilisis ligula at, posuere leo. Duis a nibh risus. Curabitur scelerisque diam pulvinar dolor tincidunt vehicula. Suspendisse ut finibus mi. Suspendisse dapibus erat a ligula porta, nec ornare magna luctus. Ut ultricies tempus tempus. In sem ligula, consectetur."),
    SelectionTile("Colling Tower", Icons.network_wifi, true,
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas tempor eleifend tellus, vel tincidunt quam congue eget. Etiam vitae nisi condimentum, lacinia sem quis, vehicula enim. Donec ullamcorper pellentesque ipsum, et elementum tellus blandit eget. Integer maximus commodo lectus, et hendrerit ipsum eleifend a. Proin rhoncus quam id blandit laoreet."),
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
