// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tab_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TabDataAdapter extends TypeAdapter<TabData> {
  @override
  final int typeId = 2;

  @override
  TabData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TabData(
      tabId: fields[0] as String,
      query: fields[1] as String,
      webResults: (fields[2] as List).cast<WebSearchResult>(),
      newsResults: (fields[3] as List).cast<NewsSearchResult>(),
      lastUpdated: fields[4] as DateTime,
      searchType: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TabData obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.tabId)
      ..writeByte(1)
      ..write(obj.query)
      ..writeByte(2)
      ..write(obj.webResults)
      ..writeByte(3)
      ..write(obj.newsResults)
      ..writeByte(4)
      ..write(obj.lastUpdated)
      ..writeByte(5)
      ..write(obj.searchType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TabDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
