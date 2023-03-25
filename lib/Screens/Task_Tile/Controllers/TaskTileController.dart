import 'package:get/get.dart';
import 'package:xstask/services/theme.dart';

class TaskTileController extends GetxController {
  getBGClr(int no) {
    switch (no) {
      case 0:
        return bluishclr;
      case 1:
        return pinkclr;
      case 2:
        return yellowclr;
    }
  }
}
