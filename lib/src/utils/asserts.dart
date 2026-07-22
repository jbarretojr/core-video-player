import 'package:flutter/widgets.dart';

bool assertState(BuildContext? context) {
  return context is StatefulElement && context.mounted;
}
