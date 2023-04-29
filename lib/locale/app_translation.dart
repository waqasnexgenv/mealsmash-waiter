import 'package:get/get.dart';
import 'package:Mealsmash_Waiter/locale/german.dart';
import 'package:Mealsmash_Waiter/locale/portuguese.dart';
import 'package:Mealsmash_Waiter/locale/spanish.dart';
import 'arabic.dart';
import 'english.dart';
import 'french.dart';
import 'indonesian.dart';
import 'italian.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': english(),
        'fr': french(),
        'it': italian(),
        'pt': portuguese(),
        'es': spanish(),
        'de': german(),
        'ar': arabic(),
        'ind': indonesian(),
      };
}
