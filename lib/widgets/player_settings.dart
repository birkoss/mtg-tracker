import 'package:flutter/material.dart';
import 'package:mtgtracker/widgets/ui/toggles.dart';

class PlayerSettings extends StatelessWidget {
  final Color backgroundColor;

  final bool hasPartner;
  final void Function(bool) onPartnerChanged;

  final bool isDead;
  final void Function(bool) onDeadChanged;

  final void Function() onClose;

  const PlayerSettings({
    Key? key,
    required this.backgroundColor,
    required this.hasPartner,
    required this.isDead,
    required this.onClose,
    required this.onDeadChanged,
    required this.onPartnerChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("PS.build()");

    return Padding(
      padding: const EdgeInsets.all(6),
      child: Container(
        color: backgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              "Settings",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Text(
                        "Has a partner",
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      const SizedBox(height: 10),
                      Switch(
                        value: hasPartner,
                        onChanged: onPartnerChanged,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Text(
                        "Is Dead!",
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      const SizedBox(height: 10),
                      Switch(
                        value: isDead,
                        onChanged: onDeadChanged,
                      ),
                    ],
                  ),
                )
              ],
            ),
            ElevatedButton.icon(
              onPressed: onClose,
              icon: const Icon(Icons.close),
              label: const Text("Close"),
            ),
          ],
        ),
      ),
    );
  }
}
