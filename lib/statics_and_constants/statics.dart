import 'package:flutter/material.dart';
import 'constants.dart';

String formattedPokemonIdStr(int id) {
  if (id < 10) {
    return '#00$id';
  } else if (id < 100) {
    return '#0$id';
  } else {
    return '#$id';
  }
}

String typesAsString(List<String> types) {
  String result = '';

  for (int i = 0; i < types.length; i++) {
    result += types[i].capitalize();
    if (i != types.length - 1) {
      result += ', ';
    }
  }
  return result;
}

Color pokemonBackgroundColor({required int typesCount}) {
  if (typesCount == 0) {
    return kYellowColor.withOpacity(0.1);
  } else if (typesCount == 1) {
    return kPurpleColor.withOpacity(0.1);
  }
  return kGreenColor.withOpacity(0.1);
}


//https://stackoverflow.com/questions/29628989/how-to-capitalize-the-first-letter-of-a-string-in-dart#:~:text=extension-,StringExtension,-on%20String%20%7B%0A%20%20%20%20String
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
