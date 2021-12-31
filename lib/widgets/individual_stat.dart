import 'package:flutter/material.dart';
import 'package:pokedex_test_project/statics_and_constants/constants.dart';

class IndividualStat extends StatelessWidget {
  final String statName;
  final int statValue;

  const IndividualStat({
    required this.statName,
    required this.statValue,
    Key? key,
  }) : super(key: key);

  Color valueColor() {
    if (statValue <= 30) {
      return kPurpleColor;
    } else if (statValue <= 60) {
      return kYellowColor;
    }
    return kGreenColor;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 18),
            child: Row(
              children: [
                Text(statName, style: kSmallDarkGrayTextStyle),
                Text('  $statValue', style: kSmallBlackTextStyle),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 18),
            child: LinearProgressIndicator(
              value: statValue.toDouble() / 100,
              minHeight: 5,
              valueColor: AlwaysStoppedAnimation<Color>(valueColor()),
              backgroundColor: kBackgroundColor,
            ),
          ),
        ],
      ),
    );
  }
}
