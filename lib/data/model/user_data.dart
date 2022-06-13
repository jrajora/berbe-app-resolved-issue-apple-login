import 'dart:convert';

UserData userDataFromMap(String str) => UserData.fromMap(json.decode(str));

String userDataToMap(UserData data) => json.encode(data.toMap());

class UserData {
  UserData(
      {this.id,
      this.countryId,
      this.countryCode,
      this.userType,
      this.langauge,
      this.name,
      this.email,
      this.facebookId,
      this.twitterId,
      this.googleId,
      this.firstSocialLoginBy,
      this.dateOfBirth,
      this.gender,
      this.phoneNumber,
      this.profile,
      this.otp,
      this.otpExpire,
      this.phoneVerified,
      this.emailVerified,
      this.emailVerifiedExpired,
      this.emailVerifiedAt,
      this.createdAt,
      this.updatedAt,
      this.token,
      this.hasPassword});

  String? id;
  String? countryId;
  String? countryCode;
  String? userType;
  String? langauge;
  String? name;
  String? email;
  String? facebookId;
  String? twitterId;
  String? googleId;
  String? firstSocialLoginBy;
  String? dateOfBirth;
  String? gender;
  String? phoneNumber;
  String? profile;
  String? otp;
  String? otpExpire;
  String? phoneVerified;
  String? emailVerified;
  String? emailVerifiedExpired;
  String? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;
  String? token;
  bool? hasPassword;

  factory UserData.fromMap(Map<String, dynamic> json) => UserData(
        id: json["id"].toString(),
        countryId: json["country_id"].toString(),
        countryCode: json["country_code"].toString(),
        userType: json["user_type"].toString(),
        langauge: json["langauge"],
        name: json["name"],
        email: json["email"],
        facebookId: json["facebook_id"],
        twitterId: json["twitter_id"],
        googleId: json["google_id"],
        firstSocialLoginBy: json["first_social_login_by"],
        dateOfBirth: json["date_of_birth"],
        gender: json["gender"],
        phoneNumber: json["phone_number"],
        profile: json["profile"],
        otp: json["otp"].toString(),
        otpExpire: json["otp_expire"].toString(),
        phoneVerified: json["phone_verified"],
        emailVerified: json["email_verified"] is int
            ? json["email_verified"].toString()
            : json["email_verified"],
        emailVerifiedExpired: json["email_verified_expired"].toString(),
        emailVerifiedAt: json["email_verified_at"].toString(),
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        token: json["token"],
        hasPassword: json["has_password"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "country_id": countryId,
        "country_code": countryCode,
        "user_type": userType,
        "langauge": langauge,
        "name": name,
        "email": email,
        "facebook_id": facebookId,
        "twitter_id": twitterId,
        "google_id": googleId,
        "first_social_login_by": firstSocialLoginBy,
        "date_of_birth": dateOfBirth,
        "gender": gender,
        "phone_number": phoneNumber,
        "profile": profile,
        "otp": otp,
        "otp_expire": otpExpire,
        "phone_verified": phoneVerified,
        "email_verified": emailVerified,
        "email_verified_expired": emailVerifiedExpired,
        "email_verified_at": emailVerifiedAt,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "token": token,
        "has_password": hasPassword,
      };
}
