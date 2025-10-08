import 'package:flutter/material.dart';
import 'package:haste/haste.dart';

class FootballScoreDemo extends StatelessWidget with Haste {
  const FootballScoreDemo({super.key});

  @override
  build(context) {
    final blueTeamSnap = stream.init(() async* {
      await Future.delayed(Duration(seconds: 2));
      yield 1;
      await Future.delayed(Duration(seconds: 8));
      yield 2;
      await Future.delayed(Duration(seconds: 5));
      yield 3;
    }, initialData: 0);
    final blueTeamScore = blueTeamSnap.data!;

    final redTeamSnap = stream.init(() async* {
      await Future.delayed(Duration(seconds: 5));
      yield 1;
      await Future.delayed(Duration(seconds: 15));
      yield 2;
    }, initialData: 0);
    final redTeamScore = redTeamSnap.data!;

    final scoreTotal = "Blue $blueTeamScore : Red $redTeamScore";
    final isGameOver =
        blueTeamSnap.connectionState == ConnectionState.done &&
        redTeamSnap.connectionState == ConnectionState.done;

    init(() {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Game on!')));
    });

    onChange(() {
      ScaffoldMessenger.of(context).clearSnackBars();

      if (isGameOver) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Game over! Final score: $scoreTotal')),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Goal! $scoreTotal')));
      }
    }, key: ValueKey(blueTeamScore + redTeamScore));

    return Row(
      spacing: 50,
      children: [
        Column(
          children: [
            Text(
              'Red team',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium!.copyWith(color: Colors.red),
            ),
            Text(
              '$redTeamScore',
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ],
        ),
        Column(
          children: [
            Text(
              'Blue team',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium!.copyWith(color: Colors.blue),
            ),
            Text(
              '$blueTeamScore',
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ],
        ),
      ],
    );
  }
}
