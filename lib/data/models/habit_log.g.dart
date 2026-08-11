// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_log.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HabitLogAdapter extends TypeAdapter<HabitLog> {
  @override
  final int typeId = 0;

  @override
  HabitLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HabitLog(
      id: fields[0] as String,
      timestamp: fields[1] as DateTime,
      sleepHours: fields[2] as double,
      sleepQuality: fields[3] as String,
      caffeineCups: fields[4] as int,
      exerciseType: fields[5] as String,
      exerciseMinutes: fields[6] as int,
      stressLevel: fields[7] as int,
      workContext: fields[8] as String,
      capacityAtTime: fields[9] as double,
    );
  }

  @override
  void write(BinaryWriter writer, HabitLog obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.timestamp)
      ..writeByte(2)
      ..write(obj.sleepHours)
      ..writeByte(3)
      ..write(obj.sleepQuality)
      ..writeByte(4)
      ..write(obj.caffeineCups)
      ..writeByte(5)
      ..write(obj.exerciseType)
      ..writeByte(6)
      ..write(obj.exerciseMinutes)
      ..writeByte(7)
      ..write(obj.stressLevel)
      ..writeByte(8)
      ..write(obj.workContext)
      ..writeByte(9)
      ..write(obj.capacityAtTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
