import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

import '../../../infrastructure/storage/hive/hive_type_ids.dart';

part 'user_information.freezed.dart';
part 'user_information.g.dart';

@freezed
@HiveType(typeId: HiveTypeIds.userInfoTypId)
abstract class UserInformation with _$UserInformation {
  const factory UserInformation({
    @HiveField(0)
    @JsonKey(name: 'full_name')
    required String fullName,

    @HiveField(1)
    @JsonKey(name: 'qid')
    required String qid,

    @HiveField(2)
    @JsonKey(name: 'phone_number')
    String? phoneNumber,

    @HiveField(3)
    String? email,
  }) = _UserInformation;

  factory UserInformation.empty() => const UserInformation(
        fullName: '',
        qid: '',
        phoneNumber: '',
        email: '',
      );

  static const defaultValue = UserInformation(
    fullName: '',
    qid: '',
    phoneNumber: '',
    email: '',
  );

  factory UserInformation.fromJson(Map<String, dynamic> json) =>
      _$UserInformationFromJson(json);
}
class UserInformationAdapter extends TypeAdapter<UserInformation> {
  @override
  final int typeId = HiveTypeIds.userInfoTypId;

  @override
  UserInformation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++)
        reader.readByte(): reader.read(),
    };

    return UserInformation(
      fullName: fields[0] as String,
      qid: fields[1] as String,
      phoneNumber: fields[2] as String?,
      email: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserInformation obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.fullName)
      ..writeByte(1)
      ..write(obj.qid)
      ..writeByte(2)
      ..write(obj.phoneNumber)
      ..writeByte(3)
      ..write(obj.email);
  }
}