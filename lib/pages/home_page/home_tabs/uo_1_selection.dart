import 'package:flutter/material.dart';

import 'package:simulop_v1/pages/home_page/home_tabs/selection_helper.dart';

class OU1Selection extends StatelessWidget {
  final selectionTilesData = [
    SelectionTile("Home", Icons.home, "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque vitae pulvinar odio. Maecenas a ex consectetur elit dictum sodales ut at arcu. Cras rutrum odio ac ligula eleifend, et eleifend eros tempor. Pellentesque dictum sapien a cursus tempus. Pellentesque egestas consectetur quam, sit amet accumsan velit porttitor nec. Pellentesque vitae.",
    "/exemple1"),
    SelectionTile("email", Icons.email,"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam faucibus arcu id lobortis tincidunt. Mauris vitae lacinia purus. Nullam lacinia rhoncus volutpat. Phasellus sapien sapien, tempus eu lorem et, auctor elementum tortor. Mauris rhoncus erat nec lectus congue, quis cursus justo euismod. Donec at neque odio. Nam ut tempor lectus."),
    SelectionTile("Chat", Icons.chat,"Lorem ipsum dolor sit amet, consectetur adipiscing elit. In ut venenatis risus. Vivamus facilisis lorem nisl, at semper enim sodales sit amet. Vivamus ante diam, interdum sit amet ipsum quis, efficitur pharetra nulla. Phasellus at cursus massa. Ut sagittis turpis diam, elementum pretium dui tincidunt at. Suspendisse id purus sed."),
    SelectionTile("News", Icons.new_releases,"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur sem arcu, elementum sit amet sagittis ut, iaculis et nulla. Praesent pulvinar tortor at malesuada efficitur. Nulla sed sem at eros hendrerit aliquet in ac sapien. Integer euismod fringilla dictum. Sed lacinia porta libero id tristique. Suspendisse quis mi dignissim, efficitur."),
    SelectionTile("Net", Icons.network_wifi,"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent fringilla orci nunc, sit amet vulputate metus rhoncus sit amet. Sed consequat sem odio, et pellentesque lacus commodo at. Fusce mattis enim ut pulvinar hendrerit. Fusce faucibus eros vel ullamcorper ultrices. Donec non faucibus ipsum. Proin et dictum dolor. Etiam vestibulum."),
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
