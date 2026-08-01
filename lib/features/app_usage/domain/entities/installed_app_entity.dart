import 'dart:typed_data';

class InstalledAppEntity {
  const InstalledAppEntity({required this.packageName, required this.name, this.iconBytes});

  final String packageName;
  final String name;
  final Uint8List? iconBytes;
}
