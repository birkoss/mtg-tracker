import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/history.dart';

class HistoryScreen extends StatefulWidget {
  static const routeName = '/history';

  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    HistoryNotifier history =
        Provider.of<HistoryNotifier>(context, listen: false);

    Map<String, String> titles = {
      "PanelBoxType.normal": "Life",
      "PanelBoxType.commander": "Commander Damage",
      "PanelBoxType.poison": "Poison Counter",
      "PanelBoxType.energy": "Energy Counter",
      "PanelBoxType.experience": "Experience Counter",
      "PanelBoxType.commanderTax": "Commander Tax",
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.separated(
              padding: const EdgeInsets.all(10),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: history.histories.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(
                height: 10,
              ),
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  color: history
                      .histories[history.histories.length - index - 1].player
                      .getColor(),
                  key: ValueKey<String>(index.toString()),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          history
                              .histories[history.histories.length - index - 1]
                              .player
                              .name,
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          (titles.containsKey(history
                                  .histories[
                                      history.histories.length - index - 1]
                                  .type
                                  .toString())
                              ? titles[history
                                  .histories[
                                      history.histories.length - index - 1]
                                  .type
                                  .toString()]!
                              : ""),
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                        ),
                        if (history
                                .histories[history.histories.length - index - 1]
                                .opponent !=
                            null)
                          Column(
                            children: [
                              const SizedBox(height: 10),
                              Text(
                                history
                                    .histories[
                                        history.histories.length - index - 1]
                                    .opponent!
                                    .name,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              history
                                  .histories[
                                      history.histories.length - index - 1]
                                  .from
                                  .toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    fontSize: 30,
                                    color: Colors.white,
                                  ),
                            ),
                            const SizedBox(width: 10),
                            const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 30,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              history
                                  .histories[
                                      history.histories.length - index - 1]
                                  .to
                                  .toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    fontSize: 30,
                                    color: Colors.white,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
