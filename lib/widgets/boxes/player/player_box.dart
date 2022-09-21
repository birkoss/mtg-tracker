import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mtgtracker/widgets/boxes/player/player_box_popup.dart';
import 'package:mtgtracker/widgets/boxes/player/player_box_settings.dart';
import 'package:provider/provider.dart';

import '../../../providers/players.dart';
import '../../../providers/player.dart';
import '../../../providers/setting.dart';
import 'player_box_panel.dart';

class PlayerBox extends StatefulWidget {
  // Rotation of this widget within the Grid
  final int rotation;

  const PlayerBox({
    Key? key,
    required this.rotation,
  }) : super(key: key);

  @override
  _PlayerBox createState() => _PlayerBox();
}

class _PlayerBox extends State<PlayerBox> {
  bool _showSettings = false;

  List<Widget> _getContent(Player player) {
    bool isDarkTheme = context.watch<SettingNotifier>().isDarkTheme;

    List<Widget> widgets = [];

    // Show the normal values (and toggling between types)
    widgets.add(
      PanelBoxPanel(
        showSettings: () {
          setState(() {
            _showSettings = true;
          });
        },
      ),
    );

    // Show the dead player
    if (player.isDead) {
      widgets.add(
        PlayerBoxPopup(
          backgroundColor: context.read<Player>().getColor(isDarkTheme),
          onPress: () {
            setState(() {
              _showSettings = true;
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: SvgPicture.asset(
              "assets/icons/skull.svg",
              fit: BoxFit.scaleDown,
              color: Colors.white24,
              semanticsLabel: 'Health',
            ),
          ),
        ),
      );
    }

    // Show the dice roll winner
    if (context.watch<Players>().diceRollWinner == player) {
      widgets.add(
        PlayerBoxPopup(
          backgroundColor: Colors.white,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              "You Win the Dice Roll",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: context.read<Player>().getColor(isDarkTheme),
              ),
            ),
          ),
        ),
      );
    }

    // Show the settings
    if (_showSettings) {
      widgets.add(
        PlayerBoxSettings(
          backgroundColor: context.read<SettingNotifier>().isDarkTheme
              ? Colors.black
              : Colors.white,
          hasPartner: player.totalCommanders == 2,
          isDead: player.isDead,
          onClose: () {
            setState(() {
              _showSettings = false;
            });
          },
          onDeadChanged: (bool value) {
            player.isDead = value;
            // Must notify all players to refresh the UI
            context.read<Players>().hasChanged();
          },
          onPartnerChanged: (bool value) {
            player.totalCommanders = value ? 2 : 1;
            // Must notify all players to refresh the UI
            context.read<Players>().hasChanged();
          },
        ),
      );
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    var player = Provider.of<Player>(context, listen: false);

    return Expanded(
      child: RotatedBox(
        quarterTurns: widget.rotation,
        child: Container(
          margin: const EdgeInsets.all(4),
          color: player.getColor(context.read<SettingNotifier>().isDarkTheme),
          alignment: Alignment.center,
          child: Stack(
            children: _getContent(player),
          ),
        ),
      ),
    );
  }
}
