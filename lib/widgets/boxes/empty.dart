import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/player.dart';

class EmptyBox extends StatelessWidget {
  const EmptyBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var player = Provider.of<Player>(context, listen: false);
    return Expanded(
      child: Container(
        color: player.getColor(context),
      ),
    );
  }
}
