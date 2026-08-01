// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_information.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserInformation _$UserInformationFromJson(Map<String, dynamic> json) =>
    _UserInformation(
      fullName: json['full_name'] as String,
      qid: json['qid'] as String,
      phoneNumber: json['phone_number'] as String?,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$UserInformationToJson(_UserInformation instance) =>
    <String, dynamic>{
      'full_name': instance.fullName,
      'qid': instance.qid,
      'phone_number': instance.phoneNumber,
      'email': instance.email,
    };
