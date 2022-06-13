import 'package:berbe/constants/app_constant.dart';
import 'package:berbe/utils/storage_utils.dart';
import 'package:get/get.dart';

import '../../main.dart';

class LanguageListController extends GetxController {
  final selectedPos = 0.obs;

  final languageList = listLangNameLocale.obs;

  changeSelectedPos(int pos) {
    if (selectedPos.value != pos) {
      selectedPos.value = pos;
      Get.updateLocale(languageList[pos].langLocal);
      saveLanguageData(
          languageList[pos].langLocal.languageCode,
          languageList[pos].langLocal.countryCode ?? "",
          languageList[pos].languageName);
      logGoogleAnalyticsEvent('language', {'language_code': languageList[pos].langLocal.languageCode});
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    StorageUtil.getData(StorageUtil.keyLanguageCode).then((value) {
      if (value == null) {
        selectedPos.value = 0;
      } else {
        for (int i = 0; i < languageList.length; i++) {
          if (languageList[i].langLocal.languageCode == value.toString()) {
            selectedPos.value = i;
            break;
          }
        }
      }

      saveLanguageData(
        languageList[selectedPos.value].langLocal.languageCode,
        languageList[selectedPos.value].langLocal.countryCode ?? "",
        languageList[selectedPos.value].languageName,
      );
    });
  }
}
