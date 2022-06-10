import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../providers/player.dart';
import '../../widgets/boxes/amount.dart';

class AmountCommanderBox extends StatefulWidget {
  final Player selectedPlayer;

  const AmountCommanderBox({
    Key? key,
    required this.selectedPlayer,
  }) : super(key: key);

  @override
  State<AmountCommanderBox> createState() => _AmountCommanderBoxState();
}

class _AmountCommanderBoxState extends State<AmountCommanderBox> {
  @override
  Widget build(BuildContext context) {
    Player player = Provider.of<Player>(context, listen: false);

    return AmountBox(
      getValue: () {
        return player.commander[int.parse(widget.selectedPlayer.id)].toString();
      },
      setValue: (int modifier) {
        player.commander[int.parse(widget.selectedPlayer.id)] =
            player.commander[int.parse(widget.selectedPlayer.id)] + modifier;
      },
    );
  }
}
