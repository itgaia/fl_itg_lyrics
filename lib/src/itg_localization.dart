import 'core/etc/itg_map.dart';

import 'core/debug.dart';

class ItgLocalization {
  static String language = 'en';
  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'language': 'Language',
      'helloWorld': 'Hello World',
      'appWindowTitle': 'Client',
      'appTitle': 'Client App',
      'welcomeMessage': 'What a Wonderful World for All of Us...',
      'welcomeMessage2': '(Click the menu up-right for the avaliable options)',
      'Customers': 'Customers',
      'Customer': 'Customer',
      'Products': 'Products',
      'Product': 'Product',
      'Resources': 'Resources',
      'Resource': 'Resource',
      'Suppliers': 'Suppliers',
      'Supplier': 'Supplier',
      'Tasks': 'Tasks',
      'Task': 'Task',
      'Dispatches': 'Dispatches',
      'Dispatch': 'Dispatch',
      'Dispatch Items': 'Dispatch Items',
      'DispatchItems': 'Dispatch Items',
      'DispatchItem': 'Dispatch Item',
      'Dispatch Templates': 'Dispatch Templates',
      'DispatchTemplates': 'Dispatch Templates',
      'DispatchTemplate': 'Dispatch Template',
      'Cultivations': 'Cultivations',
      'Cultivation': 'Cultivation',
      'Cultivation Chambers': 'Cultivation Chambers',
      'CultivationChambers': 'Cultivation Chambers',
      'CultivationChamber': 'Cultivation Chamber',
      'Cultivation Chamber': 'Cultivation Chamber',
      'Cultivation Fillings': 'Cultivation Fillings',
      'CultivationFillings': 'Cultivation Fillings',
      'CultivationFilling': 'Cultivation Filling',
      'Cultivation Filling': 'Cultivation Filling',
      'Cultivation Flushes': 'Cultivation Flushes',
      'CultivationFlushs': 'Cultivation Flushs',
      'CultivationFlush': 'Cultivation Flush',
      'Cultivation Flush': 'Cultivation Flush',
      'Cultivation Harvests': 'Cultivation Harvests',
      'CultivationHarvests': 'Cultivation Harvests',
      'CultivationHarvest': 'Cultivation Harvest',
      'Cultivation Harvest': 'Cultivation Harvest',
      'Cultivation Measurements': 'Cultivation Measurements',
      'CultivationMeasurements': 'Cultivation Measurements',
      'CultivationMeasurement': 'Cultivation Measurement',
      'Cultivation Measurement': 'Cultivation Measurement',
      'Cultivation Totals': 'Cultivation Totals',
      'CultivationTotals': 'Cultivation Totals',
      'CultivationTotal': 'Cultivation Total',
      'Cultivation Total': 'Cultivation Total',
      'Chamber': 'Chamber',
      'chamber': 'chamber',
      'Chambers': 'Chambers',
      'chambers': 'chambers',
      'cage': 'cage',
      'Cage': 'Cage',
      'cages': 'cages',
      'Cages': 'Cages',
      'spawn': 'spawn',
      'spawns': 'spawns',
      'Spawn': 'Spawn',
      'Spawns': 'Spawns',
      'kind': 'kind',
      'kinds': 'kinds',
      'Kind': 'Kind',
      'Kinds': 'Kinds',
      'Total Cages': 'Total Cages',
      'Per Block': 'Kg/Block',
      'Total Kg per Block': 'Total Kg/Block',
      'Temp Outdoor': 'Outside Temp',
      'Temp Chamber': 'Room Temp',
      'Temp Substrate': 'Substrate Temp',
    },
    'el': {
      'language': '????????????',
      'helloWorld': '???????????????? ??????????!',
      'appWindowTitle': 'Client',
      'appTitle': 'Client App',
      'welcomeMessage': '???????? ???????????????? ???????????? ?????? ?????????? ??????...',
      'welcomeMessage2': '(?????????????? ???? ?????????? ???????? ?????????? ?????? ?????? ???????????????????? ??????????????????????)',
      'Cultivation Chambers': '?????????????? ????????????????????????',
      'CultivationChambers': '?????????????? ????????????????????????',
    }
  };

  static String tr(String text, {String lang = ''}) {
    if (lang == '') lang = language;
    String? translated = _localizedValues[lang]![text];
    if (translated == null) translated = text;
    // if (text == 'appTitle') {
    //   itgLogVerbose('[ItgLocalization.tr] _localizedValues[$lang]: ${_localizedValues[lang]}');
    // }
    return translated;
  }

  static void custom(Map<String, Map<String, String>> values) {
    itgLogVerbose('[ItgLocalization.custom] values: $values');
    _localizedValues = mergeMap([_localizedValues, values]) as Map<String, Map<String, String>>;
    itgLogVerbose('[ItgLocalization.custom] after: $_localizedValues');
  }
}