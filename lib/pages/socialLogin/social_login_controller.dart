import 'dart:convert';

import 'package:berbe/utils/device_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:twitter_login/twitter_login.dart';

import '../../apiservice/api_service.dart';
import '../../main.dart';
import '../../routes/app_pages.dart';
import '../../utils/storage_utils.dart';
import '../login/login_main_model.dart';

class SocialLoginController extends GetxController {
  static const LOGIN_TYPE_GOOGLE = "google";
  static const LOGIN_TYPE_FACEBOOK = "facebook";
  static const LOGIN_TYPE_TWITTER = "twitter";
  static const LOGIN_TYPE_APPLE = "apple";

  final RxBool _isLoading = true.obs;

  RxBool get isLoading => _isLoading;

  set(value) {
    _isLoading.value = value;
  }

  void signInWithGoogle() async {
    openAndCloseLoadingDialog(true);
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    openAndCloseLoadingDialog(false);

    /*// Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    // Once signed in, return the UserCredential
    var userCredential =  await FirebaseAuth.instance.signInWithCredential(credential);*/
    if (googleUser?.id.isNotEmpty == true &&
        googleAuth?.accessToken?.isNotEmpty == true) {
      callLoginApi(
          googleUser?.displayName ?? "",
          googleUser?.email ?? "",
          LOGIN_TYPE_GOOGLE,
          googleUser?.id ?? "",
          googleAuth?.accessToken ?? "");
    }

    await GoogleSignIn().signOut();
    // return userCredential;
  }

  void signInWithFacebook() async {
    UserCredential? userCredential;
    try {
      // Trigger the sign-in flow
      openAndCloseLoadingDialog(true);
      final LoginResult loginResult = await FacebookAuth.instance
          .login(permissions: ["email", "public_profile"]);

      // Create a credential from the access token
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken?.token ?? "");

      // Once signed in, return the UserCredential
      userCredential = await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);

      if (loginResult.accessToken?.userId.isNotEmpty == true &&
          loginResult.accessToken?.token.isNotEmpty == true) {
        callLoginApi(
            userCredential.user?.displayName ?? "",
            userCredential.user?.email ?? "",
            LOGIN_TYPE_FACEBOOK,
            loginResult.accessToken?.userId ?? "",
            loginResult.accessToken?.token ?? "");
      }

      await FacebookAuth.instance.logOut();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'account-exists-with-different-credential':
          List<String> signInMethods = await FirebaseAuth.instance
              .fetchSignInMethodsForEmail(e.email ?? "");
          showSnackBar(Get.context!,
              'You are previously sign in as a ${signInMethods.first}.');
          break;
        case 'invalid-credential':
          showSnackBar(Get.context!, 'invalid-credential');
          break;
        case 'operation-not-allowed':
          showSnackBar(Get.context!, 'operation-not-allowed');
          break;
        case 'user-disabled':
          showSnackBar(Get.context!, 'user-disabled');
          break;
        case 'user-not-found':
          showSnackBar(Get.context!, 'user-not-found');
          break;
        case 'wrong-password':
          showSnackBar(Get.context!, 'wrong-password');
          break;
        case 'invalid-verification-code':
          showSnackBar(Get.context!, 'invalid-verification-code');
          break;
        case 'invalid-verification-id':
          showSnackBar(Get.context!, 'invalid-verification-id');
          break;
      }
    } finally {
      openAndCloseLoadingDialog(false);
    }
  }

  signInWithTwitter() async {
    openAndCloseLoadingDialog(true);
    final twitterLogin = TwitterLogin(
      apiKey: "jT7nn1nYdiZ4Gn4NEmsWFBznN",
      apiSecretKey: "1hXhoQ759zj74WwwoQfVxZBocftSD4P0jDGgJkMRQjoeRYvaUq",
      redirectURI: 'berbe-app-twitter-login://',
    );
    final authResult = await twitterLogin.loginV2();
    openAndCloseLoadingDialog(false);
    switch (authResult.status ?? "") {
      case TwitterLoginStatus.loggedIn:
        callLoginApi(
            authResult.user?.name ?? "",
            authResult.user?.email,
            LOGIN_TYPE_TWITTER,
            authResult.user?.id.toString() ?? "",
            authResult.authToken ?? "");
        break;
      case TwitterLoginStatus.cancelledByUser:
        // cancel
        break;
      case TwitterLoginStatus.error:
        // error
        break;
    }
  }

  callLoginApi(String? name, String? email, String? loginType, String? typeId,
      String? accessToken) async {
    var params = <String, dynamic>{
      'name': name ?? " ",
      'type': loginType,
      'type_id': typeId,
      'access_token': accessToken,
    };

    params.addAll(await DeviceInfo.instance.getDeviceInfo());

    if (email != null && email.isNotEmpty) {
      params['email'] = email;
    }

    openAndCloseLoadingDialog(true);
    ApiService.callPostApi(ApiService.socialLogin, params, Get.context, null)
        .then((value) {
      openAndCloseLoadingDialog(false);
      if (value == null) {
        showSnackBar(Get.context!, 'msg_something_went_wrong'.tr);
      } else {
        LoginMainModel userDataModel = LoginMainModel.fromMap(value);
        if (userDataModel.status) {
          if (userDataModel.data == null) {
            showSnackBar(Get.context!, userDataModel.message);
          } else {
            StorageUtil.setData(
                StorageUtil.keyToken, userDataModel.data!.token);

            StorageUtil.setData(StorageUtil.keyLoginData,
                jsonEncode(userDataModel.data!.toMap()));

            Get.offAllNamed(Routes.DASHBOARD);
          }
          logGoogleAnalyticsEvent('social-login', {});
        } else {
          showSnackBar(Get.context!, userDataModel.message);
        }
      }
    });
  }

  appleLoginAndroid(String strUri) {
    Uri? uri = Uri.parse(strUri);

    List<String> splitData = uri.query.split("data=");

    if (splitData.isNotEmpty) {
      Codec<String, String> stringToBase64 = utf8.fuse(base64);
      String decoded = stringToBase64.decode(splitData[1]);

      Get.back(result: json.decode(decoded));
    }
  }

  appleLoginWithApple() async {
    try {
      final appleResult = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      if (appleResult.userIdentifier != null) {
        final CredentialState credentialState =
            await SignInWithApple.getCredentialState(
                appleResult.userIdentifier!);
        switch (credentialState) {
          case CredentialState.authorized:
            final AuthCredential authCredential =
                OAuthProvider('apple.com').credential(
              accessToken: appleResult.authorizationCode,
              idToken: appleResult.identityToken,
            );

            await FirebaseAuth.instance.signInWithCredential(authCredential);

            callLoginApi(
                appleResult.givenName,
                appleResult.email,
                LOGIN_TYPE_APPLE,
                appleResult.userIdentifier,
                appleResult.identityToken);

            break;
          case CredentialState.revoked:
            break;
          case CredentialState.notFound:
            break;
        }
      }
    } catch (e) {}
  }
}
