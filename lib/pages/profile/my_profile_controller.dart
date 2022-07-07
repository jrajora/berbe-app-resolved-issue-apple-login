import 'dart:convert';
import 'dart:io';
import 'package:berbe/apiservice/api_service.dart';
import 'package:berbe/constants/app_size.dart';
import 'package:berbe/data/model/advertisement_main_model.dart';
import 'package:berbe/data/model/country_list_main_model.dart';
import 'package:berbe/data/model/user_data.dart';
import 'package:berbe/main.dart';
import 'package:berbe/pages/login/login_main_model.dart';
import 'package:berbe/routes/app_pages.dart';
import 'package:berbe/utils/storage_utils.dart';
import 'package:berbe/utils/string_utils.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:country_codes/country_codes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class MyProfileController extends GetxController {
  final emailVerified = true.obs;
  final emailController = TextEditingController().obs;
  final nameController = TextEditingController().obs;
  final dobController = TextEditingController().obs;
  final phoneController = TextEditingController().obs;
  final countryController = TextEditingController().obs;
  final languageName = "".obs;

  final profileImgFile = File("").obs;

  final redirectFrom = "".obs;

  final isAdAvailable = false.obs;
  final objCovidAppAd = AdvertisementData().obs;

  final countryList = <CountryListData>[].obs;
  final selectedCountryId = "".obs;

  final userData = UserData().obs;

  final countryCode = CountryCode(code: '', dialCode: '').obs;
  final stCountryCode = "".obs;

  final scrollController = ScrollController().obs;

  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    if (Get.arguments != null) {
      redirectFrom.value = Get.arguments['for'];
      print(redirectFrom.value);
    }
    await CountryCodes.init();
    final CountryDetails details = CountryCodes.detailsForLocale();
    print("Device Locale countryCode : ${details.dialCode}");
    countryCode.value = CountryCode(code: '', dialCode: details.dialCode);
    stCountryCode.value = details.dialCode ?? "";

    setLanguageName();
    // if (redirectFrom.value != "singup") {
    //TODO: Get Profile
    print(redirectFrom.value);
    StorageUtil.getData(StorageUtil.keyLoginData).then((storageData) {
      if (storageData != null) {
        userData.value = UserData.fromMap(jsonDecode(storageData));
        emailController.value =
            TextEditingController(text: userData.value.email ?? "");
        if (userData.value.email?.isNotEmpty == true) {
          emailVerified.value = userData.value.emailVerified == "1";
        } else {
          emailVerified.value = true;
        }
        nameController.value =
            TextEditingController(text: userData.value.name ?? "");
        // selectedDate.value =
        phoneController.value =
            TextEditingController(text: userData.value.phoneNumber ?? "");
        selectedCountryId.value = userData.value.countryId ?? "";
        selectedDate.value =
            DateFormat("yyyy-MM-dd").parse(userData.value.dateOfBirth ?? "");
        dobController.value = TextEditingController(text: stFormatShowDate());
        if (!checkString(userData.value.countryCode)) {
          //   print("CountryCode : ${userData.value.countryCode}");
          stCountryCode.value =
              userData.value.countryCode ?? (details.dialCode ?? "");
        }
      }
    });
    // }
    // getCovidAppBanner();
    getCountryList();
  }

  setLanguageName() {
    StorageUtil.getData(StorageUtil.keyLanguageName).then((value) {
      languageName.value = value ?? "English";
    });
  }

  void selectImage(String options) async {
    await ImagePicker()
        .pickImage(
      source:
          options == TYPE_GALLERY ? ImageSource.gallery : ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    )
        .then((value) {
      if (value != null) {
        Get.back();
        _cropImage(value.path);
      }
    }, onError: (error) async {
      print(error);
      await openAppSettings();
    });
  }

  _cropImage(filePath) async {
    await ImageCropper()
        .cropImage(
      sourcePath: filePath,
      maxWidth: 1080,
      maxHeight: 1080,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.original,
            ]
          : [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
            ],
      // aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0)
    )
        .then((value) {
      if (value != null) {
        profileImgFile.value = filePath;
        // profileImgFile.value = value;
      }
    });
  }

  callUpdateProfileApi() {
    if (checkString(nameController.value.text.toString().trim())) {
      showSnackBar(Get.context!, 'msg_enter_full_name'.tr);
    } else if (nameController.value.text.toString().trim().length > 70) {
      showSnackBar(Get.context!, 'msg_name_length'.tr);
    } else if (DateTime.now().difference(selectedDate.value).inDays == 0) {
      showSnackBar(Get.context!, 'msg_select_dob'.tr);
    } else if (checkString(phoneController.value.text.toString().trim())) {
      showSnackBar(Get.context!, 'msg_enter_phone_number'.tr);
    } else if (phoneController.value.text.toString().trim().length < 8) {
      showSnackBar(Get.context!, 'msg_phone_number_limit'.tr);
    } else if (phoneController.value.text.toString().trim().length > 15) {
      showSnackBar(Get.context!, 'msg_phone_number_max_limit'.tr);
    } else if (!phoneController.value.text.toString().trim().isNumericOnly) {
      showSnackBar(Get.context!, 'msg_enter_valid_phone_number'.tr);
    } else if (checkString(selectedCountryId.value)) {
      showSnackBar(Get.context!, 'msg_select_country'.tr);
    } else {
      openAndCloseLoadingDialog(true);
      callMultiPartApi().then((streamedResponse) {
        openAndCloseLoadingDialog(false);
        print("ApiService Post Response : $streamedResponse");

        if (streamedResponse.statusCode == ApiService.SUCCESS) {
          streamedResponse.stream.transform(utf8.decoder).listen((value) {
            print("ApiService Post Response : $value");
            LoginMainModel userDataModel =
                LoginMainModel.fromMap(jsonDecode(value));

            if (userDataModel.status) {
              StorageUtil.setData(StorageUtil.keyLoginData,
                  jsonEncode(userDataModel.data!.toMap()));
              if (redirectFrom.value == "singup") {
                Get.offAllNamed(Routes.DASHBOARD);
              } else {
                Get.back();
              }
            }
            showSnackBar(Get.context!, userDataModel.message);
            /* else {
                  showSnackBar(Get.context!, response.message);
                }*/
          });
        } else if (streamedResponse.statusCode == ApiService.UNAUTHORISED) {
          //TODO : Expired Login
          /*ApiService.forceLogoutDialog('lbl_session_expired'.tr,
              'lbl_session_expired_msg'.tr, Get.overlayContext!);*/
          ApiService.forceLogoutApiCall();
        } else {
          showSnackBar(Get.context!, 'msg_something_went_wrong'.tr);
        }
      });
    }
  }

  Future<StreamedResponse> callMultiPartApi() async {
    var token = await StorageUtil.getData(StorageUtil.keyToken);
    Map<String, String> header = <String, String>{};
    if (token != null) {
      header = <String, String>{
        'Authorization': 'Bearer $token',
      };
    }

    var request = http.MultipartRequest(
        'POST', Uri.parse(ApiService.BASE_URL + ApiService.updateProfile));
    if (profileImgFile.value.path.isNotEmpty) {
      request.files.add(http.MultipartFile(
          'profile',
          profileImgFile.value.readAsBytes().asStream(),
          profileImgFile.value.lengthSync(),
          filename: profileImgFile.value.path.split("/").last));

      // request.files.add(await http.MultipartFile.fromPath('image', profileImgFile.value.path));
    }
    request.headers.addAll(header);
    request.fields['email'] = emailController.value.text.toString().trim();
    request.fields['name'] = nameController.value.text.toString().trim();
    request.fields['date_of_birth'] = stFormatBackend();
    request.fields['phone_number'] =
        phoneController.value.text.toString().trim();
    request.fields['country_id'] = selectedCountryId.value;
    request.fields['country_code'] = stCountryCode.value;

    print(
        "ApiService Post Api: ${ApiService.BASE_URL + ApiService.updateProfile}");
    print("ApiService Api Header: $header");
    print("ApiService Api Params: ${request.fields}");

    return request.send();
  }

  callLoginApi() {
    checkConnectivity().then((value) {
      var params = <String, String>{};
      openAndCloseLoadingDialog(true);
      ApiService.callPostApi(
              ApiService.resendVerificationLink, params, Get.context, null)
          .then((value) {
        if (value == null) {
          showSnackBar(Get.context!, 'msg_something_went_wrong'.tr);
        } else {
          openAndCloseLoadingDialog(false);
          LoginMainModel userDataModel = LoginMainModel.fromMap(value);
          if (userDataModel.status) {
            // Get.back();
            // showSnackBar(Get.context!, userDataModel.message);
            logGoogleAnalyticsEvent('Resend Verification Link', {});
          } else {
            showSnackBar(Get.context!, userDataModel.message);
          }
        }
      });
    });
  }

  callDeleteAccountApi() {
    checkConnectivity().then((value) {
      var params = <String, String>{};
      openAndCloseLoadingDialog(true);
      ApiService.callPostApi(
              ApiService.deleteAccount, params, Get.context, null)
          .then((value) {
        if (value == null) {
          showSnackBar(Get.context!, 'msg_something_went_wrong'.tr);
        } else {
          openAndCloseLoadingDialog(false);
          StorageUtil.clearLoginData();
          Get.offAllNamed(Routes.LOGIN);
          // LoginMainModel userDataModel = LoginMainModel.fromMap(value);
          // if (userDataModel.status) {
          //   logGoogleAnalyticsEvent('Remove User Data and Account', {});
          // } else {
          //   showSnackBar(Get.context!, userDataModel.message);
          // }
        }
      });
    });
  }

  getCovidAppBanner() {
    checkConnectivity().then((connectivity) {
      if (connectivity) {
        openAndCloseLoadingDialog(true);
        ApiService.callGetApi(ApiService.banner, Get.context, null)
            .then((value) {
          openAndCloseLoadingDialog(false);
          if (value == null) {
            showSnackBar(Get.context!, 'msg_something_went_wrong'.tr);
          } else {
            AdvertisementMainModel responseModel =
                AdvertisementMainModel.fromMap(value);
            if (responseModel.status) {
              if (responseModel.data.isNotEmpty) {
                for (AdvertisementData data in responseModel.data) {
                  if ((data.title ?? "").toLowerCase() == "business api") {
                    isAdAvailable.value = true;
                    objCovidAppAd.value = data;
                    break;
                  }
                }
              }
            }
          }
          // getCountryList();
        });
      }
    });
    // getCountryList();
  }

  getCountryList() {
    checkConnectivity().then((connectivity) {
      if (connectivity) {
        ApiService.callGetApi(ApiService.countryList, Get.context, null)
            .then((value) {
          if (value == null) {
            showSnackBar(Get.context!, 'msg_something_went_wrong'.tr);
          } else {
            CountryListMainModel countryModel =
                CountryListMainModel.fromMap(value);
            if (countryModel.status) {
              countryList.value = countryModel.data;
            }
          }
          for (CountryListData data in countryList.value) {
            if (data.id == selectedCountryId.value) {
              countryController.value = TextEditingController(text: data.name);
              break;
            }
          }
          getCovidAppBanner();
        });
      }
    });
  }

  final selectedDate = DateTime.now().obs;

  selectDateOfBirth() async {
    if (Platform.isIOS) {
      showCupertinoModalPopup(
          context: Get.context!,
          builder: (BuildContext context) => Container(
                height: size_250,
                padding: const EdgeInsets.only(top: 6.0),
                // The Bottom margin is provided to align the popup above the system navigation bar.
                margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                // Provide a background color for the popup.
                color: CupertinoColors.systemBackground.resolveFrom(context),
                // Use a SafeArea widget to avoid system overlaps.
                child: SafeArea(
                  top: false,
                  child: CupertinoDatePicker(
                    initialDateTime: selectedDate.value,
                    mode: CupertinoDatePickerMode.date,
                    maximumDate: DateTime.now(),
                    minimumDate: DateTime(1900),
                    use24hFormat: true,
                    onDateTimeChanged: (DateTime newDate) {
                      if (newDate != selectedDate.value) {
                        if (DateTime.now().difference(newDate).inDays > 0) {
                          selectedDate.value = newDate;
                          dobController.value =
                              TextEditingController(text: stFormatShowDate());
                        }
                      }
                    },
                  ),
                ),
              ));
    } else {
      final DateTime? selected = await showDatePicker(
        context: Get.context!,
        initialDate: selectedDate.value,
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
      );

      if (selected != null && selected != selectedDate.value) {
        if (DateTime.now().difference(selected).inDays > 0) {
          selectedDate.value = selected;
          dobController.value = TextEditingController(text: stFormatShowDate());
        }
      }
    }
  }

  String stFormatShowDate() {
    return DateFormat('dd-MM-yyyy').format(selectedDate.value);
  }

  String stFormatBackend() {
    return DateFormat('yyyy-MM-dd').format(selectedDate.value);
  }
}
