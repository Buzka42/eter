// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProfilesTable extends Profiles
    with TableInfo<$ProfilesTable, ProfileRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _dobMeta = const VerificationMeta('dob');
  @override
  late final GeneratedColumn<DateTime> dob = GeneratedColumn<DateTime>(
      'dob', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _sexMeta = const VerificationMeta('sex');
  @override
  late final GeneratedColumn<String> sex = GeneratedColumn<String>(
      'sex', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _weightKgMeta =
      const VerificationMeta('weightKg');
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
      'weight_kg', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _heightCmMeta =
      const VerificationMeta('heightCm');
  @override
  late final GeneratedColumn<double> heightCm = GeneratedColumn<double>(
      'height_cm', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _unitsMeta = const VerificationMeta('units');
  @override
  late final GeneratedColumn<String> units = GeneratedColumn<String>(
      'units', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _hapticsEnabledMeta =
      const VerificationMeta('hapticsEnabled');
  @override
  late final GeneratedColumn<bool> hapticsEnabled = GeneratedColumn<bool>(
      'haptics_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("haptics_enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _flashEnabledMeta =
      const VerificationMeta('flashEnabled');
  @override
  late final GeneratedColumn<bool> flashEnabled = GeneratedColumn<bool>(
      'flash_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("flash_enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _nutritionEnabledMeta =
      const VerificationMeta('nutritionEnabled');
  @override
  late final GeneratedColumn<bool> nutritionEnabled = GeneratedColumn<bool>(
      'nutrition_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("nutrition_enabled" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _connectedSourcesJsonMeta =
      const VerificationMeta('connectedSourcesJson');
  @override
  late final GeneratedColumn<String> connectedSourcesJson =
      GeneratedColumn<String>('connected_sources_json', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant('[]'));
  static const VerificationMeta _firstNameMeta =
      const VerificationMeta('firstName');
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
      'first_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _guidanceModeMeta =
      const VerificationMeta('guidanceMode');
  @override
  late final GeneratedColumn<String> guidanceMode = GeneratedColumn<String>(
      'guidance_mode', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('balanced'));
  static const VerificationMeta _birthTimeMinutesMeta =
      const VerificationMeta('birthTimeMinutes');
  @override
  late final GeneratedColumn<int> birthTimeMinutes = GeneratedColumn<int>(
      'birth_time_minutes', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _birthUtcOffsetMinutesMeta =
      const VerificationMeta('birthUtcOffsetMinutes');
  @override
  late final GeneratedColumn<int> birthUtcOffsetMinutes = GeneratedColumn<int>(
      'birth_utc_offset_minutes', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _birthPlaceMeta =
      const VerificationMeta('birthPlace');
  @override
  late final GeneratedColumn<String> birthPlace = GeneratedColumn<String>(
      'birth_place', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _birthLatitudeMeta =
      const VerificationMeta('birthLatitude');
  @override
  late final GeneratedColumn<double> birthLatitude = GeneratedColumn<double>(
      'birth_latitude', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _birthLongitudeMeta =
      const VerificationMeta('birthLongitude');
  @override
  late final GeneratedColumn<double> birthLongitude = GeneratedColumn<double>(
      'birth_longitude', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        dob,
        sex,
        weightKg,
        heightCm,
        units,
        hapticsEnabled,
        flashEnabled,
        nutritionEnabled,
        connectedSourcesJson,
        firstName,
        guidanceMode,
        birthTimeMinutes,
        birthUtcOffsetMinutes,
        birthPlace,
        birthLatitude,
        birthLongitude
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profiles';
  @override
  VerificationContext validateIntegrity(Insertable<ProfileRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('dob')) {
      context.handle(
          _dobMeta, dob.isAcceptableOrUnknown(data['dob']!, _dobMeta));
    } else if (isInserting) {
      context.missing(_dobMeta);
    }
    if (data.containsKey('sex')) {
      context.handle(
          _sexMeta, sex.isAcceptableOrUnknown(data['sex']!, _sexMeta));
    } else if (isInserting) {
      context.missing(_sexMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(_weightKgMeta,
          weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta));
    } else if (isInserting) {
      context.missing(_weightKgMeta);
    }
    if (data.containsKey('height_cm')) {
      context.handle(_heightCmMeta,
          heightCm.isAcceptableOrUnknown(data['height_cm']!, _heightCmMeta));
    }
    if (data.containsKey('units')) {
      context.handle(
          _unitsMeta, units.isAcceptableOrUnknown(data['units']!, _unitsMeta));
    } else if (isInserting) {
      context.missing(_unitsMeta);
    }
    if (data.containsKey('haptics_enabled')) {
      context.handle(
          _hapticsEnabledMeta,
          hapticsEnabled.isAcceptableOrUnknown(
              data['haptics_enabled']!, _hapticsEnabledMeta));
    }
    if (data.containsKey('flash_enabled')) {
      context.handle(
          _flashEnabledMeta,
          flashEnabled.isAcceptableOrUnknown(
              data['flash_enabled']!, _flashEnabledMeta));
    }
    if (data.containsKey('nutrition_enabled')) {
      context.handle(
          _nutritionEnabledMeta,
          nutritionEnabled.isAcceptableOrUnknown(
              data['nutrition_enabled']!, _nutritionEnabledMeta));
    }
    if (data.containsKey('connected_sources_json')) {
      context.handle(
          _connectedSourcesJsonMeta,
          connectedSourcesJson.isAcceptableOrUnknown(
              data['connected_sources_json']!, _connectedSourcesJsonMeta));
    }
    if (data.containsKey('first_name')) {
      context.handle(_firstNameMeta,
          firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta));
    }
    if (data.containsKey('guidance_mode')) {
      context.handle(
          _guidanceModeMeta,
          guidanceMode.isAcceptableOrUnknown(
              data['guidance_mode']!, _guidanceModeMeta));
    }
    if (data.containsKey('birth_time_minutes')) {
      context.handle(
          _birthTimeMinutesMeta,
          birthTimeMinutes.isAcceptableOrUnknown(
              data['birth_time_minutes']!, _birthTimeMinutesMeta));
    }
    if (data.containsKey('birth_utc_offset_minutes')) {
      context.handle(
          _birthUtcOffsetMinutesMeta,
          birthUtcOffsetMinutes.isAcceptableOrUnknown(
              data['birth_utc_offset_minutes']!, _birthUtcOffsetMinutesMeta));
    }
    if (data.containsKey('birth_place')) {
      context.handle(
          _birthPlaceMeta,
          birthPlace.isAcceptableOrUnknown(
              data['birth_place']!, _birthPlaceMeta));
    }
    if (data.containsKey('birth_latitude')) {
      context.handle(
          _birthLatitudeMeta,
          birthLatitude.isAcceptableOrUnknown(
              data['birth_latitude']!, _birthLatitudeMeta));
    }
    if (data.containsKey('birth_longitude')) {
      context.handle(
          _birthLongitudeMeta,
          birthLongitude.isAcceptableOrUnknown(
              data['birth_longitude']!, _birthLongitudeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProfileRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProfileRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      dob: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}dob'])!,
      sex: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sex'])!,
      weightKg: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}weight_kg'])!,
      heightCm: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}height_cm']),
      units: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}units'])!,
      hapticsEnabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}haptics_enabled'])!,
      flashEnabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}flash_enabled'])!,
      nutritionEnabled: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}nutrition_enabled'])!,
      connectedSourcesJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}connected_sources_json'])!,
      firstName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}first_name']),
      guidanceMode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}guidance_mode'])!,
      birthTimeMinutes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}birth_time_minutes']),
      birthUtcOffsetMinutes: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}birth_utc_offset_minutes']),
      birthPlace: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}birth_place']),
      birthLatitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}birth_latitude']),
      birthLongitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}birth_longitude']),
    );
  }

  @override
  $ProfilesTable createAlias(String alias) {
    return $ProfilesTable(attachedDatabase, alias);
  }
}

class ProfileRow extends DataClass implements Insertable<ProfileRow> {
  final int id;
  final DateTime dob;
  final String sex;
  final double weightKg;
  final double? heightCm;
  final String units;
  final bool hapticsEnabled;
  final bool flashEnabled;
  final bool nutritionEnabled;
  final String connectedSourcesJson;
  final String? firstName;
  final String guidanceMode;
  final int? birthTimeMinutes;
  final int? birthUtcOffsetMinutes;
  final String? birthPlace;
  final double? birthLatitude;
  final double? birthLongitude;
  const ProfileRow(
      {required this.id,
      required this.dob,
      required this.sex,
      required this.weightKg,
      this.heightCm,
      required this.units,
      required this.hapticsEnabled,
      required this.flashEnabled,
      required this.nutritionEnabled,
      required this.connectedSourcesJson,
      this.firstName,
      required this.guidanceMode,
      this.birthTimeMinutes,
      this.birthUtcOffsetMinutes,
      this.birthPlace,
      this.birthLatitude,
      this.birthLongitude});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['dob'] = Variable<DateTime>(dob);
    map['sex'] = Variable<String>(sex);
    map['weight_kg'] = Variable<double>(weightKg);
    if (!nullToAbsent || heightCm != null) {
      map['height_cm'] = Variable<double>(heightCm);
    }
    map['units'] = Variable<String>(units);
    map['haptics_enabled'] = Variable<bool>(hapticsEnabled);
    map['flash_enabled'] = Variable<bool>(flashEnabled);
    map['nutrition_enabled'] = Variable<bool>(nutritionEnabled);
    map['connected_sources_json'] = Variable<String>(connectedSourcesJson);
    if (!nullToAbsent || firstName != null) {
      map['first_name'] = Variable<String>(firstName);
    }
    map['guidance_mode'] = Variable<String>(guidanceMode);
    if (!nullToAbsent || birthTimeMinutes != null) {
      map['birth_time_minutes'] = Variable<int>(birthTimeMinutes);
    }
    if (!nullToAbsent || birthUtcOffsetMinutes != null) {
      map['birth_utc_offset_minutes'] = Variable<int>(birthUtcOffsetMinutes);
    }
    if (!nullToAbsent || birthPlace != null) {
      map['birth_place'] = Variable<String>(birthPlace);
    }
    if (!nullToAbsent || birthLatitude != null) {
      map['birth_latitude'] = Variable<double>(birthLatitude);
    }
    if (!nullToAbsent || birthLongitude != null) {
      map['birth_longitude'] = Variable<double>(birthLongitude);
    }
    return map;
  }

  ProfilesCompanion toCompanion(bool nullToAbsent) {
    return ProfilesCompanion(
      id: Value(id),
      dob: Value(dob),
      sex: Value(sex),
      weightKg: Value(weightKg),
      heightCm: heightCm == null && nullToAbsent
          ? const Value.absent()
          : Value(heightCm),
      units: Value(units),
      hapticsEnabled: Value(hapticsEnabled),
      flashEnabled: Value(flashEnabled),
      nutritionEnabled: Value(nutritionEnabled),
      connectedSourcesJson: Value(connectedSourcesJson),
      firstName: firstName == null && nullToAbsent
          ? const Value.absent()
          : Value(firstName),
      guidanceMode: Value(guidanceMode),
      birthTimeMinutes: birthTimeMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(birthTimeMinutes),
      birthUtcOffsetMinutes: birthUtcOffsetMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(birthUtcOffsetMinutes),
      birthPlace: birthPlace == null && nullToAbsent
          ? const Value.absent()
          : Value(birthPlace),
      birthLatitude: birthLatitude == null && nullToAbsent
          ? const Value.absent()
          : Value(birthLatitude),
      birthLongitude: birthLongitude == null && nullToAbsent
          ? const Value.absent()
          : Value(birthLongitude),
    );
  }

  factory ProfileRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProfileRow(
      id: serializer.fromJson<int>(json['id']),
      dob: serializer.fromJson<DateTime>(json['dob']),
      sex: serializer.fromJson<String>(json['sex']),
      weightKg: serializer.fromJson<double>(json['weightKg']),
      heightCm: serializer.fromJson<double?>(json['heightCm']),
      units: serializer.fromJson<String>(json['units']),
      hapticsEnabled: serializer.fromJson<bool>(json['hapticsEnabled']),
      flashEnabled: serializer.fromJson<bool>(json['flashEnabled']),
      nutritionEnabled: serializer.fromJson<bool>(json['nutritionEnabled']),
      connectedSourcesJson:
          serializer.fromJson<String>(json['connectedSourcesJson']),
      firstName: serializer.fromJson<String?>(json['firstName']),
      guidanceMode: serializer.fromJson<String>(json['guidanceMode']),
      birthTimeMinutes: serializer.fromJson<int?>(json['birthTimeMinutes']),
      birthUtcOffsetMinutes:
          serializer.fromJson<int?>(json['birthUtcOffsetMinutes']),
      birthPlace: serializer.fromJson<String?>(json['birthPlace']),
      birthLatitude: serializer.fromJson<double?>(json['birthLatitude']),
      birthLongitude: serializer.fromJson<double?>(json['birthLongitude']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'dob': serializer.toJson<DateTime>(dob),
      'sex': serializer.toJson<String>(sex),
      'weightKg': serializer.toJson<double>(weightKg),
      'heightCm': serializer.toJson<double?>(heightCm),
      'units': serializer.toJson<String>(units),
      'hapticsEnabled': serializer.toJson<bool>(hapticsEnabled),
      'flashEnabled': serializer.toJson<bool>(flashEnabled),
      'nutritionEnabled': serializer.toJson<bool>(nutritionEnabled),
      'connectedSourcesJson': serializer.toJson<String>(connectedSourcesJson),
      'firstName': serializer.toJson<String?>(firstName),
      'guidanceMode': serializer.toJson<String>(guidanceMode),
      'birthTimeMinutes': serializer.toJson<int?>(birthTimeMinutes),
      'birthUtcOffsetMinutes': serializer.toJson<int?>(birthUtcOffsetMinutes),
      'birthPlace': serializer.toJson<String?>(birthPlace),
      'birthLatitude': serializer.toJson<double?>(birthLatitude),
      'birthLongitude': serializer.toJson<double?>(birthLongitude),
    };
  }

  ProfileRow copyWith(
          {int? id,
          DateTime? dob,
          String? sex,
          double? weightKg,
          Value<double?> heightCm = const Value.absent(),
          String? units,
          bool? hapticsEnabled,
          bool? flashEnabled,
          bool? nutritionEnabled,
          String? connectedSourcesJson,
          Value<String?> firstName = const Value.absent(),
          String? guidanceMode,
          Value<int?> birthTimeMinutes = const Value.absent(),
          Value<int?> birthUtcOffsetMinutes = const Value.absent(),
          Value<String?> birthPlace = const Value.absent(),
          Value<double?> birthLatitude = const Value.absent(),
          Value<double?> birthLongitude = const Value.absent()}) =>
      ProfileRow(
        id: id ?? this.id,
        dob: dob ?? this.dob,
        sex: sex ?? this.sex,
        weightKg: weightKg ?? this.weightKg,
        heightCm: heightCm.present ? heightCm.value : this.heightCm,
        units: units ?? this.units,
        hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
        flashEnabled: flashEnabled ?? this.flashEnabled,
        nutritionEnabled: nutritionEnabled ?? this.nutritionEnabled,
        connectedSourcesJson: connectedSourcesJson ?? this.connectedSourcesJson,
        firstName: firstName.present ? firstName.value : this.firstName,
        guidanceMode: guidanceMode ?? this.guidanceMode,
        birthTimeMinutes: birthTimeMinutes.present
            ? birthTimeMinutes.value
            : this.birthTimeMinutes,
        birthUtcOffsetMinutes: birthUtcOffsetMinutes.present
            ? birthUtcOffsetMinutes.value
            : this.birthUtcOffsetMinutes,
        birthPlace: birthPlace.present ? birthPlace.value : this.birthPlace,
        birthLatitude:
            birthLatitude.present ? birthLatitude.value : this.birthLatitude,
        birthLongitude:
            birthLongitude.present ? birthLongitude.value : this.birthLongitude,
      );
  ProfileRow copyWithCompanion(ProfilesCompanion data) {
    return ProfileRow(
      id: data.id.present ? data.id.value : this.id,
      dob: data.dob.present ? data.dob.value : this.dob,
      sex: data.sex.present ? data.sex.value : this.sex,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      heightCm: data.heightCm.present ? data.heightCm.value : this.heightCm,
      units: data.units.present ? data.units.value : this.units,
      hapticsEnabled: data.hapticsEnabled.present
          ? data.hapticsEnabled.value
          : this.hapticsEnabled,
      flashEnabled: data.flashEnabled.present
          ? data.flashEnabled.value
          : this.flashEnabled,
      nutritionEnabled: data.nutritionEnabled.present
          ? data.nutritionEnabled.value
          : this.nutritionEnabled,
      connectedSourcesJson: data.connectedSourcesJson.present
          ? data.connectedSourcesJson.value
          : this.connectedSourcesJson,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      guidanceMode: data.guidanceMode.present
          ? data.guidanceMode.value
          : this.guidanceMode,
      birthTimeMinutes: data.birthTimeMinutes.present
          ? data.birthTimeMinutes.value
          : this.birthTimeMinutes,
      birthUtcOffsetMinutes: data.birthUtcOffsetMinutes.present
          ? data.birthUtcOffsetMinutes.value
          : this.birthUtcOffsetMinutes,
      birthPlace:
          data.birthPlace.present ? data.birthPlace.value : this.birthPlace,
      birthLatitude: data.birthLatitude.present
          ? data.birthLatitude.value
          : this.birthLatitude,
      birthLongitude: data.birthLongitude.present
          ? data.birthLongitude.value
          : this.birthLongitude,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProfileRow(')
          ..write('id: $id, ')
          ..write('dob: $dob, ')
          ..write('sex: $sex, ')
          ..write('weightKg: $weightKg, ')
          ..write('heightCm: $heightCm, ')
          ..write('units: $units, ')
          ..write('hapticsEnabled: $hapticsEnabled, ')
          ..write('flashEnabled: $flashEnabled, ')
          ..write('nutritionEnabled: $nutritionEnabled, ')
          ..write('connectedSourcesJson: $connectedSourcesJson, ')
          ..write('firstName: $firstName, ')
          ..write('guidanceMode: $guidanceMode, ')
          ..write('birthTimeMinutes: $birthTimeMinutes, ')
          ..write('birthUtcOffsetMinutes: $birthUtcOffsetMinutes, ')
          ..write('birthPlace: $birthPlace, ')
          ..write('birthLatitude: $birthLatitude, ')
          ..write('birthLongitude: $birthLongitude')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      dob,
      sex,
      weightKg,
      heightCm,
      units,
      hapticsEnabled,
      flashEnabled,
      nutritionEnabled,
      connectedSourcesJson,
      firstName,
      guidanceMode,
      birthTimeMinutes,
      birthUtcOffsetMinutes,
      birthPlace,
      birthLatitude,
      birthLongitude);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProfileRow &&
          other.id == this.id &&
          other.dob == this.dob &&
          other.sex == this.sex &&
          other.weightKg == this.weightKg &&
          other.heightCm == this.heightCm &&
          other.units == this.units &&
          other.hapticsEnabled == this.hapticsEnabled &&
          other.flashEnabled == this.flashEnabled &&
          other.nutritionEnabled == this.nutritionEnabled &&
          other.connectedSourcesJson == this.connectedSourcesJson &&
          other.firstName == this.firstName &&
          other.guidanceMode == this.guidanceMode &&
          other.birthTimeMinutes == this.birthTimeMinutes &&
          other.birthUtcOffsetMinutes == this.birthUtcOffsetMinutes &&
          other.birthPlace == this.birthPlace &&
          other.birthLatitude == this.birthLatitude &&
          other.birthLongitude == this.birthLongitude);
}

class ProfilesCompanion extends UpdateCompanion<ProfileRow> {
  final Value<int> id;
  final Value<DateTime> dob;
  final Value<String> sex;
  final Value<double> weightKg;
  final Value<double?> heightCm;
  final Value<String> units;
  final Value<bool> hapticsEnabled;
  final Value<bool> flashEnabled;
  final Value<bool> nutritionEnabled;
  final Value<String> connectedSourcesJson;
  final Value<String?> firstName;
  final Value<String> guidanceMode;
  final Value<int?> birthTimeMinutes;
  final Value<int?> birthUtcOffsetMinutes;
  final Value<String?> birthPlace;
  final Value<double?> birthLatitude;
  final Value<double?> birthLongitude;
  const ProfilesCompanion({
    this.id = const Value.absent(),
    this.dob = const Value.absent(),
    this.sex = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.heightCm = const Value.absent(),
    this.units = const Value.absent(),
    this.hapticsEnabled = const Value.absent(),
    this.flashEnabled = const Value.absent(),
    this.nutritionEnabled = const Value.absent(),
    this.connectedSourcesJson = const Value.absent(),
    this.firstName = const Value.absent(),
    this.guidanceMode = const Value.absent(),
    this.birthTimeMinutes = const Value.absent(),
    this.birthUtcOffsetMinutes = const Value.absent(),
    this.birthPlace = const Value.absent(),
    this.birthLatitude = const Value.absent(),
    this.birthLongitude = const Value.absent(),
  });
  ProfilesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime dob,
    required String sex,
    required double weightKg,
    this.heightCm = const Value.absent(),
    required String units,
    this.hapticsEnabled = const Value.absent(),
    this.flashEnabled = const Value.absent(),
    this.nutritionEnabled = const Value.absent(),
    this.connectedSourcesJson = const Value.absent(),
    this.firstName = const Value.absent(),
    this.guidanceMode = const Value.absent(),
    this.birthTimeMinutes = const Value.absent(),
    this.birthUtcOffsetMinutes = const Value.absent(),
    this.birthPlace = const Value.absent(),
    this.birthLatitude = const Value.absent(),
    this.birthLongitude = const Value.absent(),
  })  : dob = Value(dob),
        sex = Value(sex),
        weightKg = Value(weightKg),
        units = Value(units);
  static Insertable<ProfileRow> custom({
    Expression<int>? id,
    Expression<DateTime>? dob,
    Expression<String>? sex,
    Expression<double>? weightKg,
    Expression<double>? heightCm,
    Expression<String>? units,
    Expression<bool>? hapticsEnabled,
    Expression<bool>? flashEnabled,
    Expression<bool>? nutritionEnabled,
    Expression<String>? connectedSourcesJson,
    Expression<String>? firstName,
    Expression<String>? guidanceMode,
    Expression<int>? birthTimeMinutes,
    Expression<int>? birthUtcOffsetMinutes,
    Expression<String>? birthPlace,
    Expression<double>? birthLatitude,
    Expression<double>? birthLongitude,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dob != null) 'dob': dob,
      if (sex != null) 'sex': sex,
      if (weightKg != null) 'weight_kg': weightKg,
      if (heightCm != null) 'height_cm': heightCm,
      if (units != null) 'units': units,
      if (hapticsEnabled != null) 'haptics_enabled': hapticsEnabled,
      if (flashEnabled != null) 'flash_enabled': flashEnabled,
      if (nutritionEnabled != null) 'nutrition_enabled': nutritionEnabled,
      if (connectedSourcesJson != null)
        'connected_sources_json': connectedSourcesJson,
      if (firstName != null) 'first_name': firstName,
      if (guidanceMode != null) 'guidance_mode': guidanceMode,
      if (birthTimeMinutes != null) 'birth_time_minutes': birthTimeMinutes,
      if (birthUtcOffsetMinutes != null)
        'birth_utc_offset_minutes': birthUtcOffsetMinutes,
      if (birthPlace != null) 'birth_place': birthPlace,
      if (birthLatitude != null) 'birth_latitude': birthLatitude,
      if (birthLongitude != null) 'birth_longitude': birthLongitude,
    });
  }

  ProfilesCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? dob,
      Value<String>? sex,
      Value<double>? weightKg,
      Value<double?>? heightCm,
      Value<String>? units,
      Value<bool>? hapticsEnabled,
      Value<bool>? flashEnabled,
      Value<bool>? nutritionEnabled,
      Value<String>? connectedSourcesJson,
      Value<String?>? firstName,
      Value<String>? guidanceMode,
      Value<int?>? birthTimeMinutes,
      Value<int?>? birthUtcOffsetMinutes,
      Value<String?>? birthPlace,
      Value<double?>? birthLatitude,
      Value<double?>? birthLongitude}) {
    return ProfilesCompanion(
      id: id ?? this.id,
      dob: dob ?? this.dob,
      sex: sex ?? this.sex,
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
      units: units ?? this.units,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      flashEnabled: flashEnabled ?? this.flashEnabled,
      nutritionEnabled: nutritionEnabled ?? this.nutritionEnabled,
      connectedSourcesJson: connectedSourcesJson ?? this.connectedSourcesJson,
      firstName: firstName ?? this.firstName,
      guidanceMode: guidanceMode ?? this.guidanceMode,
      birthTimeMinutes: birthTimeMinutes ?? this.birthTimeMinutes,
      birthUtcOffsetMinutes:
          birthUtcOffsetMinutes ?? this.birthUtcOffsetMinutes,
      birthPlace: birthPlace ?? this.birthPlace,
      birthLatitude: birthLatitude ?? this.birthLatitude,
      birthLongitude: birthLongitude ?? this.birthLongitude,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (dob.present) {
      map['dob'] = Variable<DateTime>(dob.value);
    }
    if (sex.present) {
      map['sex'] = Variable<String>(sex.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (heightCm.present) {
      map['height_cm'] = Variable<double>(heightCm.value);
    }
    if (units.present) {
      map['units'] = Variable<String>(units.value);
    }
    if (hapticsEnabled.present) {
      map['haptics_enabled'] = Variable<bool>(hapticsEnabled.value);
    }
    if (flashEnabled.present) {
      map['flash_enabled'] = Variable<bool>(flashEnabled.value);
    }
    if (nutritionEnabled.present) {
      map['nutrition_enabled'] = Variable<bool>(nutritionEnabled.value);
    }
    if (connectedSourcesJson.present) {
      map['connected_sources_json'] =
          Variable<String>(connectedSourcesJson.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (guidanceMode.present) {
      map['guidance_mode'] = Variable<String>(guidanceMode.value);
    }
    if (birthTimeMinutes.present) {
      map['birth_time_minutes'] = Variable<int>(birthTimeMinutes.value);
    }
    if (birthUtcOffsetMinutes.present) {
      map['birth_utc_offset_minutes'] =
          Variable<int>(birthUtcOffsetMinutes.value);
    }
    if (birthPlace.present) {
      map['birth_place'] = Variable<String>(birthPlace.value);
    }
    if (birthLatitude.present) {
      map['birth_latitude'] = Variable<double>(birthLatitude.value);
    }
    if (birthLongitude.present) {
      map['birth_longitude'] = Variable<double>(birthLongitude.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfilesCompanion(')
          ..write('id: $id, ')
          ..write('dob: $dob, ')
          ..write('sex: $sex, ')
          ..write('weightKg: $weightKg, ')
          ..write('heightCm: $heightCm, ')
          ..write('units: $units, ')
          ..write('hapticsEnabled: $hapticsEnabled, ')
          ..write('flashEnabled: $flashEnabled, ')
          ..write('nutritionEnabled: $nutritionEnabled, ')
          ..write('connectedSourcesJson: $connectedSourcesJson, ')
          ..write('firstName: $firstName, ')
          ..write('guidanceMode: $guidanceMode, ')
          ..write('birthTimeMinutes: $birthTimeMinutes, ')
          ..write('birthUtcOffsetMinutes: $birthUtcOffsetMinutes, ')
          ..write('birthPlace: $birthPlace, ')
          ..write('birthLatitude: $birthLatitude, ')
          ..write('birthLongitude: $birthLongitude')
          ..write(')'))
        .toString();
  }
}

class $DaySummariesTable extends DaySummaries
    with TableInfo<$DaySummariesTable, DaySummaryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DaySummariesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
      'date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _activeKcalMeta =
      const VerificationMeta('activeKcal');
  @override
  late final GeneratedColumn<double> activeKcal = GeneratedColumn<double>(
      'active_kcal', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _basalKcalMeta =
      const VerificationMeta('basalKcal');
  @override
  late final GeneratedColumn<double> basalKcal = GeneratedColumn<double>(
      'basal_kcal', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _intakeKcalMeta =
      const VerificationMeta('intakeKcal');
  @override
  late final GeneratedColumn<double> intakeKcal = GeneratedColumn<double>(
      'intake_kcal', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _stepsMeta = const VerificationMeta('steps');
  @override
  late final GeneratedColumn<int> steps = GeneratedColumn<int>(
      'steps', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _sessionsCountMeta =
      const VerificationMeta('sessionsCount');
  @override
  late final GeneratedColumn<int> sessionsCount = GeneratedColumn<int>(
      'sessions_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _milestonesFiredMeta =
      const VerificationMeta('milestonesFired');
  @override
  late final GeneratedColumn<int> milestonesFired = GeneratedColumn<int>(
      'milestones_fired', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lastMilestoneIndexMeta =
      const VerificationMeta('lastMilestoneIndex');
  @override
  late final GeneratedColumn<int> lastMilestoneIndex = GeneratedColumn<int>(
      'last_milestone_index', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _recalibratedMeta =
      const VerificationMeta('recalibrated');
  @override
  late final GeneratedColumn<bool> recalibrated = GeneratedColumn<bool>(
      'recalibrated', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("recalibrated" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        date,
        activeKcal,
        basalKcal,
        intakeKcal,
        steps,
        sessionsCount,
        milestonesFired,
        lastMilestoneIndex,
        recalibrated
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'day_summaries';
  @override
  VerificationContext validateIntegrity(Insertable<DaySummaryRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('active_kcal')) {
      context.handle(
          _activeKcalMeta,
          activeKcal.isAcceptableOrUnknown(
              data['active_kcal']!, _activeKcalMeta));
    }
    if (data.containsKey('basal_kcal')) {
      context.handle(_basalKcalMeta,
          basalKcal.isAcceptableOrUnknown(data['basal_kcal']!, _basalKcalMeta));
    }
    if (data.containsKey('intake_kcal')) {
      context.handle(
          _intakeKcalMeta,
          intakeKcal.isAcceptableOrUnknown(
              data['intake_kcal']!, _intakeKcalMeta));
    }
    if (data.containsKey('steps')) {
      context.handle(
          _stepsMeta, steps.isAcceptableOrUnknown(data['steps']!, _stepsMeta));
    }
    if (data.containsKey('sessions_count')) {
      context.handle(
          _sessionsCountMeta,
          sessionsCount.isAcceptableOrUnknown(
              data['sessions_count']!, _sessionsCountMeta));
    }
    if (data.containsKey('milestones_fired')) {
      context.handle(
          _milestonesFiredMeta,
          milestonesFired.isAcceptableOrUnknown(
              data['milestones_fired']!, _milestonesFiredMeta));
    }
    if (data.containsKey('last_milestone_index')) {
      context.handle(
          _lastMilestoneIndexMeta,
          lastMilestoneIndex.isAcceptableOrUnknown(
              data['last_milestone_index']!, _lastMilestoneIndexMeta));
    }
    if (data.containsKey('recalibrated')) {
      context.handle(
          _recalibratedMeta,
          recalibrated.isAcceptableOrUnknown(
              data['recalibrated']!, _recalibratedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {date};
  @override
  DaySummaryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DaySummaryRow(
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date'])!,
      activeKcal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}active_kcal'])!,
      basalKcal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}basal_kcal'])!,
      intakeKcal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}intake_kcal']),
      steps: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}steps'])!,
      sessionsCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sessions_count'])!,
      milestonesFired: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}milestones_fired'])!,
      lastMilestoneIndex: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}last_milestone_index'])!,
      recalibrated: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}recalibrated'])!,
    );
  }

  @override
  $DaySummariesTable createAlias(String alias) {
    return $DaySummariesTable(attachedDatabase, alias);
  }
}

class DaySummaryRow extends DataClass implements Insertable<DaySummaryRow> {
  final String date;
  final double activeKcal;
  final double basalKcal;
  final double? intakeKcal;
  final int steps;
  final int sessionsCount;
  final int milestonesFired;
  final int lastMilestoneIndex;
  final bool recalibrated;
  const DaySummaryRow(
      {required this.date,
      required this.activeKcal,
      required this.basalKcal,
      this.intakeKcal,
      required this.steps,
      required this.sessionsCount,
      required this.milestonesFired,
      required this.lastMilestoneIndex,
      required this.recalibrated});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date'] = Variable<String>(date);
    map['active_kcal'] = Variable<double>(activeKcal);
    map['basal_kcal'] = Variable<double>(basalKcal);
    if (!nullToAbsent || intakeKcal != null) {
      map['intake_kcal'] = Variable<double>(intakeKcal);
    }
    map['steps'] = Variable<int>(steps);
    map['sessions_count'] = Variable<int>(sessionsCount);
    map['milestones_fired'] = Variable<int>(milestonesFired);
    map['last_milestone_index'] = Variable<int>(lastMilestoneIndex);
    map['recalibrated'] = Variable<bool>(recalibrated);
    return map;
  }

  DaySummariesCompanion toCompanion(bool nullToAbsent) {
    return DaySummariesCompanion(
      date: Value(date),
      activeKcal: Value(activeKcal),
      basalKcal: Value(basalKcal),
      intakeKcal: intakeKcal == null && nullToAbsent
          ? const Value.absent()
          : Value(intakeKcal),
      steps: Value(steps),
      sessionsCount: Value(sessionsCount),
      milestonesFired: Value(milestonesFired),
      lastMilestoneIndex: Value(lastMilestoneIndex),
      recalibrated: Value(recalibrated),
    );
  }

  factory DaySummaryRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DaySummaryRow(
      date: serializer.fromJson<String>(json['date']),
      activeKcal: serializer.fromJson<double>(json['activeKcal']),
      basalKcal: serializer.fromJson<double>(json['basalKcal']),
      intakeKcal: serializer.fromJson<double?>(json['intakeKcal']),
      steps: serializer.fromJson<int>(json['steps']),
      sessionsCount: serializer.fromJson<int>(json['sessionsCount']),
      milestonesFired: serializer.fromJson<int>(json['milestonesFired']),
      lastMilestoneIndex: serializer.fromJson<int>(json['lastMilestoneIndex']),
      recalibrated: serializer.fromJson<bool>(json['recalibrated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'date': serializer.toJson<String>(date),
      'activeKcal': serializer.toJson<double>(activeKcal),
      'basalKcal': serializer.toJson<double>(basalKcal),
      'intakeKcal': serializer.toJson<double?>(intakeKcal),
      'steps': serializer.toJson<int>(steps),
      'sessionsCount': serializer.toJson<int>(sessionsCount),
      'milestonesFired': serializer.toJson<int>(milestonesFired),
      'lastMilestoneIndex': serializer.toJson<int>(lastMilestoneIndex),
      'recalibrated': serializer.toJson<bool>(recalibrated),
    };
  }

  DaySummaryRow copyWith(
          {String? date,
          double? activeKcal,
          double? basalKcal,
          Value<double?> intakeKcal = const Value.absent(),
          int? steps,
          int? sessionsCount,
          int? milestonesFired,
          int? lastMilestoneIndex,
          bool? recalibrated}) =>
      DaySummaryRow(
        date: date ?? this.date,
        activeKcal: activeKcal ?? this.activeKcal,
        basalKcal: basalKcal ?? this.basalKcal,
        intakeKcal: intakeKcal.present ? intakeKcal.value : this.intakeKcal,
        steps: steps ?? this.steps,
        sessionsCount: sessionsCount ?? this.sessionsCount,
        milestonesFired: milestonesFired ?? this.milestonesFired,
        lastMilestoneIndex: lastMilestoneIndex ?? this.lastMilestoneIndex,
        recalibrated: recalibrated ?? this.recalibrated,
      );
  DaySummaryRow copyWithCompanion(DaySummariesCompanion data) {
    return DaySummaryRow(
      date: data.date.present ? data.date.value : this.date,
      activeKcal:
          data.activeKcal.present ? data.activeKcal.value : this.activeKcal,
      basalKcal: data.basalKcal.present ? data.basalKcal.value : this.basalKcal,
      intakeKcal:
          data.intakeKcal.present ? data.intakeKcal.value : this.intakeKcal,
      steps: data.steps.present ? data.steps.value : this.steps,
      sessionsCount: data.sessionsCount.present
          ? data.sessionsCount.value
          : this.sessionsCount,
      milestonesFired: data.milestonesFired.present
          ? data.milestonesFired.value
          : this.milestonesFired,
      lastMilestoneIndex: data.lastMilestoneIndex.present
          ? data.lastMilestoneIndex.value
          : this.lastMilestoneIndex,
      recalibrated: data.recalibrated.present
          ? data.recalibrated.value
          : this.recalibrated,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DaySummaryRow(')
          ..write('date: $date, ')
          ..write('activeKcal: $activeKcal, ')
          ..write('basalKcal: $basalKcal, ')
          ..write('intakeKcal: $intakeKcal, ')
          ..write('steps: $steps, ')
          ..write('sessionsCount: $sessionsCount, ')
          ..write('milestonesFired: $milestonesFired, ')
          ..write('lastMilestoneIndex: $lastMilestoneIndex, ')
          ..write('recalibrated: $recalibrated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(date, activeKcal, basalKcal, intakeKcal,
      steps, sessionsCount, milestonesFired, lastMilestoneIndex, recalibrated);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DaySummaryRow &&
          other.date == this.date &&
          other.activeKcal == this.activeKcal &&
          other.basalKcal == this.basalKcal &&
          other.intakeKcal == this.intakeKcal &&
          other.steps == this.steps &&
          other.sessionsCount == this.sessionsCount &&
          other.milestonesFired == this.milestonesFired &&
          other.lastMilestoneIndex == this.lastMilestoneIndex &&
          other.recalibrated == this.recalibrated);
}

class DaySummariesCompanion extends UpdateCompanion<DaySummaryRow> {
  final Value<String> date;
  final Value<double> activeKcal;
  final Value<double> basalKcal;
  final Value<double?> intakeKcal;
  final Value<int> steps;
  final Value<int> sessionsCount;
  final Value<int> milestonesFired;
  final Value<int> lastMilestoneIndex;
  final Value<bool> recalibrated;
  final Value<int> rowid;
  const DaySummariesCompanion({
    this.date = const Value.absent(),
    this.activeKcal = const Value.absent(),
    this.basalKcal = const Value.absent(),
    this.intakeKcal = const Value.absent(),
    this.steps = const Value.absent(),
    this.sessionsCount = const Value.absent(),
    this.milestonesFired = const Value.absent(),
    this.lastMilestoneIndex = const Value.absent(),
    this.recalibrated = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DaySummariesCompanion.insert({
    required String date,
    this.activeKcal = const Value.absent(),
    this.basalKcal = const Value.absent(),
    this.intakeKcal = const Value.absent(),
    this.steps = const Value.absent(),
    this.sessionsCount = const Value.absent(),
    this.milestonesFired = const Value.absent(),
    this.lastMilestoneIndex = const Value.absent(),
    this.recalibrated = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : date = Value(date);
  static Insertable<DaySummaryRow> custom({
    Expression<String>? date,
    Expression<double>? activeKcal,
    Expression<double>? basalKcal,
    Expression<double>? intakeKcal,
    Expression<int>? steps,
    Expression<int>? sessionsCount,
    Expression<int>? milestonesFired,
    Expression<int>? lastMilestoneIndex,
    Expression<bool>? recalibrated,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
      if (activeKcal != null) 'active_kcal': activeKcal,
      if (basalKcal != null) 'basal_kcal': basalKcal,
      if (intakeKcal != null) 'intake_kcal': intakeKcal,
      if (steps != null) 'steps': steps,
      if (sessionsCount != null) 'sessions_count': sessionsCount,
      if (milestonesFired != null) 'milestones_fired': milestonesFired,
      if (lastMilestoneIndex != null)
        'last_milestone_index': lastMilestoneIndex,
      if (recalibrated != null) 'recalibrated': recalibrated,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DaySummariesCompanion copyWith(
      {Value<String>? date,
      Value<double>? activeKcal,
      Value<double>? basalKcal,
      Value<double?>? intakeKcal,
      Value<int>? steps,
      Value<int>? sessionsCount,
      Value<int>? milestonesFired,
      Value<int>? lastMilestoneIndex,
      Value<bool>? recalibrated,
      Value<int>? rowid}) {
    return DaySummariesCompanion(
      date: date ?? this.date,
      activeKcal: activeKcal ?? this.activeKcal,
      basalKcal: basalKcal ?? this.basalKcal,
      intakeKcal: intakeKcal ?? this.intakeKcal,
      steps: steps ?? this.steps,
      sessionsCount: sessionsCount ?? this.sessionsCount,
      milestonesFired: milestonesFired ?? this.milestonesFired,
      lastMilestoneIndex: lastMilestoneIndex ?? this.lastMilestoneIndex,
      recalibrated: recalibrated ?? this.recalibrated,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (activeKcal.present) {
      map['active_kcal'] = Variable<double>(activeKcal.value);
    }
    if (basalKcal.present) {
      map['basal_kcal'] = Variable<double>(basalKcal.value);
    }
    if (intakeKcal.present) {
      map['intake_kcal'] = Variable<double>(intakeKcal.value);
    }
    if (steps.present) {
      map['steps'] = Variable<int>(steps.value);
    }
    if (sessionsCount.present) {
      map['sessions_count'] = Variable<int>(sessionsCount.value);
    }
    if (milestonesFired.present) {
      map['milestones_fired'] = Variable<int>(milestonesFired.value);
    }
    if (lastMilestoneIndex.present) {
      map['last_milestone_index'] = Variable<int>(lastMilestoneIndex.value);
    }
    if (recalibrated.present) {
      map['recalibrated'] = Variable<bool>(recalibrated.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DaySummariesCompanion(')
          ..write('date: $date, ')
          ..write('activeKcal: $activeKcal, ')
          ..write('basalKcal: $basalKcal, ')
          ..write('intakeKcal: $intakeKcal, ')
          ..write('steps: $steps, ')
          ..write('sessionsCount: $sessionsCount, ')
          ..write('milestonesFired: $milestonesFired, ')
          ..write('lastMilestoneIndex: $lastMilestoneIndex, ')
          ..write('recalibrated: $recalibrated, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RawBucketsTable extends RawBuckets
    with TableInfo<$RawBucketsTable, RawBucketRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RawBucketsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _minuteUtcMeta =
      const VerificationMeta('minuteUtc');
  @override
  late final GeneratedColumn<DateTime> minuteUtc = GeneratedColumn<DateTime>(
      'minute_utc', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
      'source', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _activeKcalMeta =
      const VerificationMeta('activeKcal');
  @override
  late final GeneratedColumn<double> activeKcal = GeneratedColumn<double>(
      'active_kcal', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _stepsMeta = const VerificationMeta('steps');
  @override
  late final GeneratedColumn<int> steps = GeneratedColumn<int>(
      'steps', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _avgHrMeta = const VerificationMeta('avgHr');
  @override
  late final GeneratedColumn<double> avgHr = GeneratedColumn<double>(
      'avg_hr', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _hrSampleCountMeta =
      const VerificationMeta('hrSampleCount');
  @override
  late final GeneratedColumn<int> hrSampleCount = GeneratedColumn<int>(
      'hr_sample_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _priorityMeta =
      const VerificationMeta('priority');
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
      'priority', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _externalIdMeta =
      const VerificationMeta('externalId');
  @override
  late final GeneratedColumn<String> externalId = GeneratedColumn<String>(
      'external_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        minuteUtc,
        source,
        activeKcal,
        steps,
        avgHr,
        hrSampleCount,
        priority,
        externalId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'raw_buckets';
  @override
  VerificationContext validateIntegrity(Insertable<RawBucketRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('minute_utc')) {
      context.handle(_minuteUtcMeta,
          minuteUtc.isAcceptableOrUnknown(data['minute_utc']!, _minuteUtcMeta));
    } else if (isInserting) {
      context.missing(_minuteUtcMeta);
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta,
          source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('active_kcal')) {
      context.handle(
          _activeKcalMeta,
          activeKcal.isAcceptableOrUnknown(
              data['active_kcal']!, _activeKcalMeta));
    } else if (isInserting) {
      context.missing(_activeKcalMeta);
    }
    if (data.containsKey('steps')) {
      context.handle(
          _stepsMeta, steps.isAcceptableOrUnknown(data['steps']!, _stepsMeta));
    }
    if (data.containsKey('avg_hr')) {
      context.handle(
          _avgHrMeta, avgHr.isAcceptableOrUnknown(data['avg_hr']!, _avgHrMeta));
    }
    if (data.containsKey('hr_sample_count')) {
      context.handle(
          _hrSampleCountMeta,
          hrSampleCount.isAcceptableOrUnknown(
              data['hr_sample_count']!, _hrSampleCountMeta));
    }
    if (data.containsKey('priority')) {
      context.handle(_priorityMeta,
          priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta));
    } else if (isInserting) {
      context.missing(_priorityMeta);
    }
    if (data.containsKey('external_id')) {
      context.handle(
          _externalIdMeta,
          externalId.isAcceptableOrUnknown(
              data['external_id']!, _externalIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {source, minuteUtc};
  @override
  RawBucketRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RawBucketRow(
      minuteUtc: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}minute_utc'])!,
      source: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source'])!,
      activeKcal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}active_kcal'])!,
      steps: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}steps']),
      avgHr: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}avg_hr']),
      hrSampleCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}hr_sample_count'])!,
      priority: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}priority'])!,
      externalId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}external_id']),
    );
  }

  @override
  $RawBucketsTable createAlias(String alias) {
    return $RawBucketsTable(attachedDatabase, alias);
  }
}

class RawBucketRow extends DataClass implements Insertable<RawBucketRow> {
  final DateTime minuteUtc;
  final String source;
  final double activeKcal;
  final int? steps;
  final double? avgHr;
  final int hrSampleCount;
  final int priority;
  final String? externalId;
  const RawBucketRow(
      {required this.minuteUtc,
      required this.source,
      required this.activeKcal,
      this.steps,
      this.avgHr,
      required this.hrSampleCount,
      required this.priority,
      this.externalId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['minute_utc'] = Variable<DateTime>(minuteUtc);
    map['source'] = Variable<String>(source);
    map['active_kcal'] = Variable<double>(activeKcal);
    if (!nullToAbsent || steps != null) {
      map['steps'] = Variable<int>(steps);
    }
    if (!nullToAbsent || avgHr != null) {
      map['avg_hr'] = Variable<double>(avgHr);
    }
    map['hr_sample_count'] = Variable<int>(hrSampleCount);
    map['priority'] = Variable<int>(priority);
    if (!nullToAbsent || externalId != null) {
      map['external_id'] = Variable<String>(externalId);
    }
    return map;
  }

  RawBucketsCompanion toCompanion(bool nullToAbsent) {
    return RawBucketsCompanion(
      minuteUtc: Value(minuteUtc),
      source: Value(source),
      activeKcal: Value(activeKcal),
      steps:
          steps == null && nullToAbsent ? const Value.absent() : Value(steps),
      avgHr:
          avgHr == null && nullToAbsent ? const Value.absent() : Value(avgHr),
      hrSampleCount: Value(hrSampleCount),
      priority: Value(priority),
      externalId: externalId == null && nullToAbsent
          ? const Value.absent()
          : Value(externalId),
    );
  }

  factory RawBucketRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RawBucketRow(
      minuteUtc: serializer.fromJson<DateTime>(json['minuteUtc']),
      source: serializer.fromJson<String>(json['source']),
      activeKcal: serializer.fromJson<double>(json['activeKcal']),
      steps: serializer.fromJson<int?>(json['steps']),
      avgHr: serializer.fromJson<double?>(json['avgHr']),
      hrSampleCount: serializer.fromJson<int>(json['hrSampleCount']),
      priority: serializer.fromJson<int>(json['priority']),
      externalId: serializer.fromJson<String?>(json['externalId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'minuteUtc': serializer.toJson<DateTime>(minuteUtc),
      'source': serializer.toJson<String>(source),
      'activeKcal': serializer.toJson<double>(activeKcal),
      'steps': serializer.toJson<int?>(steps),
      'avgHr': serializer.toJson<double?>(avgHr),
      'hrSampleCount': serializer.toJson<int>(hrSampleCount),
      'priority': serializer.toJson<int>(priority),
      'externalId': serializer.toJson<String?>(externalId),
    };
  }

  RawBucketRow copyWith(
          {DateTime? minuteUtc,
          String? source,
          double? activeKcal,
          Value<int?> steps = const Value.absent(),
          Value<double?> avgHr = const Value.absent(),
          int? hrSampleCount,
          int? priority,
          Value<String?> externalId = const Value.absent()}) =>
      RawBucketRow(
        minuteUtc: minuteUtc ?? this.minuteUtc,
        source: source ?? this.source,
        activeKcal: activeKcal ?? this.activeKcal,
        steps: steps.present ? steps.value : this.steps,
        avgHr: avgHr.present ? avgHr.value : this.avgHr,
        hrSampleCount: hrSampleCount ?? this.hrSampleCount,
        priority: priority ?? this.priority,
        externalId: externalId.present ? externalId.value : this.externalId,
      );
  RawBucketRow copyWithCompanion(RawBucketsCompanion data) {
    return RawBucketRow(
      minuteUtc: data.minuteUtc.present ? data.minuteUtc.value : this.minuteUtc,
      source: data.source.present ? data.source.value : this.source,
      activeKcal:
          data.activeKcal.present ? data.activeKcal.value : this.activeKcal,
      steps: data.steps.present ? data.steps.value : this.steps,
      avgHr: data.avgHr.present ? data.avgHr.value : this.avgHr,
      hrSampleCount: data.hrSampleCount.present
          ? data.hrSampleCount.value
          : this.hrSampleCount,
      priority: data.priority.present ? data.priority.value : this.priority,
      externalId:
          data.externalId.present ? data.externalId.value : this.externalId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RawBucketRow(')
          ..write('minuteUtc: $minuteUtc, ')
          ..write('source: $source, ')
          ..write('activeKcal: $activeKcal, ')
          ..write('steps: $steps, ')
          ..write('avgHr: $avgHr, ')
          ..write('hrSampleCount: $hrSampleCount, ')
          ..write('priority: $priority, ')
          ..write('externalId: $externalId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(minuteUtc, source, activeKcal, steps, avgHr,
      hrSampleCount, priority, externalId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RawBucketRow &&
          other.minuteUtc == this.minuteUtc &&
          other.source == this.source &&
          other.activeKcal == this.activeKcal &&
          other.steps == this.steps &&
          other.avgHr == this.avgHr &&
          other.hrSampleCount == this.hrSampleCount &&
          other.priority == this.priority &&
          other.externalId == this.externalId);
}

class RawBucketsCompanion extends UpdateCompanion<RawBucketRow> {
  final Value<DateTime> minuteUtc;
  final Value<String> source;
  final Value<double> activeKcal;
  final Value<int?> steps;
  final Value<double?> avgHr;
  final Value<int> hrSampleCount;
  final Value<int> priority;
  final Value<String?> externalId;
  final Value<int> rowid;
  const RawBucketsCompanion({
    this.minuteUtc = const Value.absent(),
    this.source = const Value.absent(),
    this.activeKcal = const Value.absent(),
    this.steps = const Value.absent(),
    this.avgHr = const Value.absent(),
    this.hrSampleCount = const Value.absent(),
    this.priority = const Value.absent(),
    this.externalId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RawBucketsCompanion.insert({
    required DateTime minuteUtc,
    required String source,
    required double activeKcal,
    this.steps = const Value.absent(),
    this.avgHr = const Value.absent(),
    this.hrSampleCount = const Value.absent(),
    required int priority,
    this.externalId = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : minuteUtc = Value(minuteUtc),
        source = Value(source),
        activeKcal = Value(activeKcal),
        priority = Value(priority);
  static Insertable<RawBucketRow> custom({
    Expression<DateTime>? minuteUtc,
    Expression<String>? source,
    Expression<double>? activeKcal,
    Expression<int>? steps,
    Expression<double>? avgHr,
    Expression<int>? hrSampleCount,
    Expression<int>? priority,
    Expression<String>? externalId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (minuteUtc != null) 'minute_utc': minuteUtc,
      if (source != null) 'source': source,
      if (activeKcal != null) 'active_kcal': activeKcal,
      if (steps != null) 'steps': steps,
      if (avgHr != null) 'avg_hr': avgHr,
      if (hrSampleCount != null) 'hr_sample_count': hrSampleCount,
      if (priority != null) 'priority': priority,
      if (externalId != null) 'external_id': externalId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RawBucketsCompanion copyWith(
      {Value<DateTime>? minuteUtc,
      Value<String>? source,
      Value<double>? activeKcal,
      Value<int?>? steps,
      Value<double?>? avgHr,
      Value<int>? hrSampleCount,
      Value<int>? priority,
      Value<String?>? externalId,
      Value<int>? rowid}) {
    return RawBucketsCompanion(
      minuteUtc: minuteUtc ?? this.minuteUtc,
      source: source ?? this.source,
      activeKcal: activeKcal ?? this.activeKcal,
      steps: steps ?? this.steps,
      avgHr: avgHr ?? this.avgHr,
      hrSampleCount: hrSampleCount ?? this.hrSampleCount,
      priority: priority ?? this.priority,
      externalId: externalId ?? this.externalId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (minuteUtc.present) {
      map['minute_utc'] = Variable<DateTime>(minuteUtc.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (activeKcal.present) {
      map['active_kcal'] = Variable<double>(activeKcal.value);
    }
    if (steps.present) {
      map['steps'] = Variable<int>(steps.value);
    }
    if (avgHr.present) {
      map['avg_hr'] = Variable<double>(avgHr.value);
    }
    if (hrSampleCount.present) {
      map['hr_sample_count'] = Variable<int>(hrSampleCount.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (externalId.present) {
      map['external_id'] = Variable<String>(externalId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RawBucketsCompanion(')
          ..write('minuteUtc: $minuteUtc, ')
          ..write('source: $source, ')
          ..write('activeKcal: $activeKcal, ')
          ..write('steps: $steps, ')
          ..write('avgHr: $avgHr, ')
          ..write('hrSampleCount: $hrSampleCount, ')
          ..write('priority: $priority, ')
          ..write('externalId: $externalId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MinuteBucketsTable extends MinuteBuckets
    with TableInfo<$MinuteBucketsTable, MinuteBucketRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MinuteBucketsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _minuteUtcMeta =
      const VerificationMeta('minuteUtc');
  @override
  late final GeneratedColumn<DateTime> minuteUtc = GeneratedColumn<DateTime>(
      'minute_utc', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _activeKcalMeta =
      const VerificationMeta('activeKcal');
  @override
  late final GeneratedColumn<double> activeKcal = GeneratedColumn<double>(
      'active_kcal', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _stepsMeta = const VerificationMeta('steps');
  @override
  late final GeneratedColumn<int> steps = GeneratedColumn<int>(
      'steps', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _avgHrMeta = const VerificationMeta('avgHr');
  @override
  late final GeneratedColumn<double> avgHr = GeneratedColumn<double>(
      'avg_hr', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _winningSourceMeta =
      const VerificationMeta('winningSource');
  @override
  late final GeneratedColumn<String> winningSource = GeneratedColumn<String>(
      'winning_source', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _provenanceMeta =
      const VerificationMeta('provenance');
  @override
  late final GeneratedColumn<String> provenance = GeneratedColumn<String>(
      'provenance', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [minuteUtc, activeKcal, steps, avgHr, winningSource, provenance];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'minute_buckets';
  @override
  VerificationContext validateIntegrity(Insertable<MinuteBucketRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('minute_utc')) {
      context.handle(_minuteUtcMeta,
          minuteUtc.isAcceptableOrUnknown(data['minute_utc']!, _minuteUtcMeta));
    } else if (isInserting) {
      context.missing(_minuteUtcMeta);
    }
    if (data.containsKey('active_kcal')) {
      context.handle(
          _activeKcalMeta,
          activeKcal.isAcceptableOrUnknown(
              data['active_kcal']!, _activeKcalMeta));
    } else if (isInserting) {
      context.missing(_activeKcalMeta);
    }
    if (data.containsKey('steps')) {
      context.handle(
          _stepsMeta, steps.isAcceptableOrUnknown(data['steps']!, _stepsMeta));
    }
    if (data.containsKey('avg_hr')) {
      context.handle(
          _avgHrMeta, avgHr.isAcceptableOrUnknown(data['avg_hr']!, _avgHrMeta));
    }
    if (data.containsKey('winning_source')) {
      context.handle(
          _winningSourceMeta,
          winningSource.isAcceptableOrUnknown(
              data['winning_source']!, _winningSourceMeta));
    } else if (isInserting) {
      context.missing(_winningSourceMeta);
    }
    if (data.containsKey('provenance')) {
      context.handle(
          _provenanceMeta,
          provenance.isAcceptableOrUnknown(
              data['provenance']!, _provenanceMeta));
    } else if (isInserting) {
      context.missing(_provenanceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {minuteUtc};
  @override
  MinuteBucketRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MinuteBucketRow(
      minuteUtc: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}minute_utc'])!,
      activeKcal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}active_kcal'])!,
      steps: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}steps']),
      avgHr: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}avg_hr']),
      winningSource: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}winning_source'])!,
      provenance: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}provenance'])!,
    );
  }

  @override
  $MinuteBucketsTable createAlias(String alias) {
    return $MinuteBucketsTable(attachedDatabase, alias);
  }
}

class MinuteBucketRow extends DataClass implements Insertable<MinuteBucketRow> {
  final DateTime minuteUtc;
  final double activeKcal;
  final int? steps;
  final double? avgHr;
  final String winningSource;
  final String provenance;
  const MinuteBucketRow(
      {required this.minuteUtc,
      required this.activeKcal,
      this.steps,
      this.avgHr,
      required this.winningSource,
      required this.provenance});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['minute_utc'] = Variable<DateTime>(minuteUtc);
    map['active_kcal'] = Variable<double>(activeKcal);
    if (!nullToAbsent || steps != null) {
      map['steps'] = Variable<int>(steps);
    }
    if (!nullToAbsent || avgHr != null) {
      map['avg_hr'] = Variable<double>(avgHr);
    }
    map['winning_source'] = Variable<String>(winningSource);
    map['provenance'] = Variable<String>(provenance);
    return map;
  }

  MinuteBucketsCompanion toCompanion(bool nullToAbsent) {
    return MinuteBucketsCompanion(
      minuteUtc: Value(minuteUtc),
      activeKcal: Value(activeKcal),
      steps:
          steps == null && nullToAbsent ? const Value.absent() : Value(steps),
      avgHr:
          avgHr == null && nullToAbsent ? const Value.absent() : Value(avgHr),
      winningSource: Value(winningSource),
      provenance: Value(provenance),
    );
  }

  factory MinuteBucketRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MinuteBucketRow(
      minuteUtc: serializer.fromJson<DateTime>(json['minuteUtc']),
      activeKcal: serializer.fromJson<double>(json['activeKcal']),
      steps: serializer.fromJson<int?>(json['steps']),
      avgHr: serializer.fromJson<double?>(json['avgHr']),
      winningSource: serializer.fromJson<String>(json['winningSource']),
      provenance: serializer.fromJson<String>(json['provenance']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'minuteUtc': serializer.toJson<DateTime>(minuteUtc),
      'activeKcal': serializer.toJson<double>(activeKcal),
      'steps': serializer.toJson<int?>(steps),
      'avgHr': serializer.toJson<double?>(avgHr),
      'winningSource': serializer.toJson<String>(winningSource),
      'provenance': serializer.toJson<String>(provenance),
    };
  }

  MinuteBucketRow copyWith(
          {DateTime? minuteUtc,
          double? activeKcal,
          Value<int?> steps = const Value.absent(),
          Value<double?> avgHr = const Value.absent(),
          String? winningSource,
          String? provenance}) =>
      MinuteBucketRow(
        minuteUtc: minuteUtc ?? this.minuteUtc,
        activeKcal: activeKcal ?? this.activeKcal,
        steps: steps.present ? steps.value : this.steps,
        avgHr: avgHr.present ? avgHr.value : this.avgHr,
        winningSource: winningSource ?? this.winningSource,
        provenance: provenance ?? this.provenance,
      );
  MinuteBucketRow copyWithCompanion(MinuteBucketsCompanion data) {
    return MinuteBucketRow(
      minuteUtc: data.minuteUtc.present ? data.minuteUtc.value : this.minuteUtc,
      activeKcal:
          data.activeKcal.present ? data.activeKcal.value : this.activeKcal,
      steps: data.steps.present ? data.steps.value : this.steps,
      avgHr: data.avgHr.present ? data.avgHr.value : this.avgHr,
      winningSource: data.winningSource.present
          ? data.winningSource.value
          : this.winningSource,
      provenance:
          data.provenance.present ? data.provenance.value : this.provenance,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MinuteBucketRow(')
          ..write('minuteUtc: $minuteUtc, ')
          ..write('activeKcal: $activeKcal, ')
          ..write('steps: $steps, ')
          ..write('avgHr: $avgHr, ')
          ..write('winningSource: $winningSource, ')
          ..write('provenance: $provenance')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      minuteUtc, activeKcal, steps, avgHr, winningSource, provenance);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MinuteBucketRow &&
          other.minuteUtc == this.minuteUtc &&
          other.activeKcal == this.activeKcal &&
          other.steps == this.steps &&
          other.avgHr == this.avgHr &&
          other.winningSource == this.winningSource &&
          other.provenance == this.provenance);
}

class MinuteBucketsCompanion extends UpdateCompanion<MinuteBucketRow> {
  final Value<DateTime> minuteUtc;
  final Value<double> activeKcal;
  final Value<int?> steps;
  final Value<double?> avgHr;
  final Value<String> winningSource;
  final Value<String> provenance;
  final Value<int> rowid;
  const MinuteBucketsCompanion({
    this.minuteUtc = const Value.absent(),
    this.activeKcal = const Value.absent(),
    this.steps = const Value.absent(),
    this.avgHr = const Value.absent(),
    this.winningSource = const Value.absent(),
    this.provenance = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MinuteBucketsCompanion.insert({
    required DateTime minuteUtc,
    required double activeKcal,
    this.steps = const Value.absent(),
    this.avgHr = const Value.absent(),
    required String winningSource,
    required String provenance,
    this.rowid = const Value.absent(),
  })  : minuteUtc = Value(minuteUtc),
        activeKcal = Value(activeKcal),
        winningSource = Value(winningSource),
        provenance = Value(provenance);
  static Insertable<MinuteBucketRow> custom({
    Expression<DateTime>? minuteUtc,
    Expression<double>? activeKcal,
    Expression<int>? steps,
    Expression<double>? avgHr,
    Expression<String>? winningSource,
    Expression<String>? provenance,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (minuteUtc != null) 'minute_utc': minuteUtc,
      if (activeKcal != null) 'active_kcal': activeKcal,
      if (steps != null) 'steps': steps,
      if (avgHr != null) 'avg_hr': avgHr,
      if (winningSource != null) 'winning_source': winningSource,
      if (provenance != null) 'provenance': provenance,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MinuteBucketsCompanion copyWith(
      {Value<DateTime>? minuteUtc,
      Value<double>? activeKcal,
      Value<int?>? steps,
      Value<double?>? avgHr,
      Value<String>? winningSource,
      Value<String>? provenance,
      Value<int>? rowid}) {
    return MinuteBucketsCompanion(
      minuteUtc: minuteUtc ?? this.minuteUtc,
      activeKcal: activeKcal ?? this.activeKcal,
      steps: steps ?? this.steps,
      avgHr: avgHr ?? this.avgHr,
      winningSource: winningSource ?? this.winningSource,
      provenance: provenance ?? this.provenance,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (minuteUtc.present) {
      map['minute_utc'] = Variable<DateTime>(minuteUtc.value);
    }
    if (activeKcal.present) {
      map['active_kcal'] = Variable<double>(activeKcal.value);
    }
    if (steps.present) {
      map['steps'] = Variable<int>(steps.value);
    }
    if (avgHr.present) {
      map['avg_hr'] = Variable<double>(avgHr.value);
    }
    if (winningSource.present) {
      map['winning_source'] = Variable<String>(winningSource.value);
    }
    if (provenance.present) {
      map['provenance'] = Variable<String>(provenance.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MinuteBucketsCompanion(')
          ..write('minuteUtc: $minuteUtc, ')
          ..write('activeKcal: $activeKcal, ')
          ..write('steps: $steps, ')
          ..write('avgHr: $avgHr, ')
          ..write('winningSource: $winningSource, ')
          ..write('provenance: $provenance, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $IntegrationsTable extends Integrations
    with TableInfo<$IntegrationsTable, IntegrationRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IntegrationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _vendorMeta = const VerificationMeta('vendor');
  @override
  late final GeneratedColumn<String> vendor = GeneratedColumn<String>(
      'vendor', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lastAttemptMeta =
      const VerificationMeta('lastAttempt');
  @override
  late final GeneratedColumn<DateTime> lastAttempt = GeneratedColumn<DateTime>(
      'last_attempt', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _lastSyncMeta =
      const VerificationMeta('lastSync');
  @override
  late final GeneratedColumn<DateTime> lastSync = GeneratedColumn<DateTime>(
      'last_sync', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _changesTokenMeta =
      const VerificationMeta('changesToken');
  @override
  late final GeneratedColumn<String> changesToken = GeneratedColumn<String>(
      'changes_token', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _recordsTodayMeta =
      const VerificationMeta('recordsToday');
  @override
  late final GeneratedColumn<int> recordsToday = GeneratedColumn<int>(
      'records_today', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _diagnosticsJsonMeta =
      const VerificationMeta('diagnosticsJson');
  @override
  late final GeneratedColumn<String> diagnosticsJson = GeneratedColumn<String>(
      'diagnostics_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('{}'));
  static const VerificationMeta _lastErrorMeta =
      const VerificationMeta('lastError');
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
      'last_error', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        vendor,
        status,
        lastAttempt,
        lastSync,
        changesToken,
        recordsToday,
        diagnosticsJson,
        lastError
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'integrations';
  @override
  VerificationContext validateIntegrity(Insertable<IntegrationRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('vendor')) {
      context.handle(_vendorMeta,
          vendor.isAcceptableOrUnknown(data['vendor']!, _vendorMeta));
    } else if (isInserting) {
      context.missing(_vendorMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('last_attempt')) {
      context.handle(
          _lastAttemptMeta,
          lastAttempt.isAcceptableOrUnknown(
              data['last_attempt']!, _lastAttemptMeta));
    }
    if (data.containsKey('last_sync')) {
      context.handle(_lastSyncMeta,
          lastSync.isAcceptableOrUnknown(data['last_sync']!, _lastSyncMeta));
    }
    if (data.containsKey('changes_token')) {
      context.handle(
          _changesTokenMeta,
          changesToken.isAcceptableOrUnknown(
              data['changes_token']!, _changesTokenMeta));
    }
    if (data.containsKey('records_today')) {
      context.handle(
          _recordsTodayMeta,
          recordsToday.isAcceptableOrUnknown(
              data['records_today']!, _recordsTodayMeta));
    }
    if (data.containsKey('diagnostics_json')) {
      context.handle(
          _diagnosticsJsonMeta,
          diagnosticsJson.isAcceptableOrUnknown(
              data['diagnostics_json']!, _diagnosticsJsonMeta));
    }
    if (data.containsKey('last_error')) {
      context.handle(_lastErrorMeta,
          lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {vendor};
  @override
  IntegrationRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IntegrationRow(
      vendor: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}vendor'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      lastAttempt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_attempt']),
      lastSync: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_sync']),
      changesToken: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}changes_token']),
      recordsToday: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}records_today'])!,
      diagnosticsJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}diagnostics_json'])!,
      lastError: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_error']),
    );
  }

  @override
  $IntegrationsTable createAlias(String alias) {
    return $IntegrationsTable(attachedDatabase, alias);
  }
}

class IntegrationRow extends DataClass implements Insertable<IntegrationRow> {
  final String vendor;
  final String status;
  final DateTime? lastAttempt;
  final DateTime? lastSync;
  final String? changesToken;
  final int recordsToday;
  final String diagnosticsJson;
  final String? lastError;
  const IntegrationRow(
      {required this.vendor,
      required this.status,
      this.lastAttempt,
      this.lastSync,
      this.changesToken,
      required this.recordsToday,
      required this.diagnosticsJson,
      this.lastError});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['vendor'] = Variable<String>(vendor);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || lastAttempt != null) {
      map['last_attempt'] = Variable<DateTime>(lastAttempt);
    }
    if (!nullToAbsent || lastSync != null) {
      map['last_sync'] = Variable<DateTime>(lastSync);
    }
    if (!nullToAbsent || changesToken != null) {
      map['changes_token'] = Variable<String>(changesToken);
    }
    map['records_today'] = Variable<int>(recordsToday);
    map['diagnostics_json'] = Variable<String>(diagnosticsJson);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    return map;
  }

  IntegrationsCompanion toCompanion(bool nullToAbsent) {
    return IntegrationsCompanion(
      vendor: Value(vendor),
      status: Value(status),
      lastAttempt: lastAttempt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastAttempt),
      lastSync: lastSync == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSync),
      changesToken: changesToken == null && nullToAbsent
          ? const Value.absent()
          : Value(changesToken),
      recordsToday: Value(recordsToday),
      diagnosticsJson: Value(diagnosticsJson),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
    );
  }

  factory IntegrationRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IntegrationRow(
      vendor: serializer.fromJson<String>(json['vendor']),
      status: serializer.fromJson<String>(json['status']),
      lastAttempt: serializer.fromJson<DateTime?>(json['lastAttempt']),
      lastSync: serializer.fromJson<DateTime?>(json['lastSync']),
      changesToken: serializer.fromJson<String?>(json['changesToken']),
      recordsToday: serializer.fromJson<int>(json['recordsToday']),
      diagnosticsJson: serializer.fromJson<String>(json['diagnosticsJson']),
      lastError: serializer.fromJson<String?>(json['lastError']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'vendor': serializer.toJson<String>(vendor),
      'status': serializer.toJson<String>(status),
      'lastAttempt': serializer.toJson<DateTime?>(lastAttempt),
      'lastSync': serializer.toJson<DateTime?>(lastSync),
      'changesToken': serializer.toJson<String?>(changesToken),
      'recordsToday': serializer.toJson<int>(recordsToday),
      'diagnosticsJson': serializer.toJson<String>(diagnosticsJson),
      'lastError': serializer.toJson<String?>(lastError),
    };
  }

  IntegrationRow copyWith(
          {String? vendor,
          String? status,
          Value<DateTime?> lastAttempt = const Value.absent(),
          Value<DateTime?> lastSync = const Value.absent(),
          Value<String?> changesToken = const Value.absent(),
          int? recordsToday,
          String? diagnosticsJson,
          Value<String?> lastError = const Value.absent()}) =>
      IntegrationRow(
        vendor: vendor ?? this.vendor,
        status: status ?? this.status,
        lastAttempt: lastAttempt.present ? lastAttempt.value : this.lastAttempt,
        lastSync: lastSync.present ? lastSync.value : this.lastSync,
        changesToken:
            changesToken.present ? changesToken.value : this.changesToken,
        recordsToday: recordsToday ?? this.recordsToday,
        diagnosticsJson: diagnosticsJson ?? this.diagnosticsJson,
        lastError: lastError.present ? lastError.value : this.lastError,
      );
  IntegrationRow copyWithCompanion(IntegrationsCompanion data) {
    return IntegrationRow(
      vendor: data.vendor.present ? data.vendor.value : this.vendor,
      status: data.status.present ? data.status.value : this.status,
      lastAttempt:
          data.lastAttempt.present ? data.lastAttempt.value : this.lastAttempt,
      lastSync: data.lastSync.present ? data.lastSync.value : this.lastSync,
      changesToken: data.changesToken.present
          ? data.changesToken.value
          : this.changesToken,
      recordsToday: data.recordsToday.present
          ? data.recordsToday.value
          : this.recordsToday,
      diagnosticsJson: data.diagnosticsJson.present
          ? data.diagnosticsJson.value
          : this.diagnosticsJson,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IntegrationRow(')
          ..write('vendor: $vendor, ')
          ..write('status: $status, ')
          ..write('lastAttempt: $lastAttempt, ')
          ..write('lastSync: $lastSync, ')
          ..write('changesToken: $changesToken, ')
          ..write('recordsToday: $recordsToday, ')
          ..write('diagnosticsJson: $diagnosticsJson, ')
          ..write('lastError: $lastError')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(vendor, status, lastAttempt, lastSync,
      changesToken, recordsToday, diagnosticsJson, lastError);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IntegrationRow &&
          other.vendor == this.vendor &&
          other.status == this.status &&
          other.lastAttempt == this.lastAttempt &&
          other.lastSync == this.lastSync &&
          other.changesToken == this.changesToken &&
          other.recordsToday == this.recordsToday &&
          other.diagnosticsJson == this.diagnosticsJson &&
          other.lastError == this.lastError);
}

class IntegrationsCompanion extends UpdateCompanion<IntegrationRow> {
  final Value<String> vendor;
  final Value<String> status;
  final Value<DateTime?> lastAttempt;
  final Value<DateTime?> lastSync;
  final Value<String?> changesToken;
  final Value<int> recordsToday;
  final Value<String> diagnosticsJson;
  final Value<String?> lastError;
  final Value<int> rowid;
  const IntegrationsCompanion({
    this.vendor = const Value.absent(),
    this.status = const Value.absent(),
    this.lastAttempt = const Value.absent(),
    this.lastSync = const Value.absent(),
    this.changesToken = const Value.absent(),
    this.recordsToday = const Value.absent(),
    this.diagnosticsJson = const Value.absent(),
    this.lastError = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  IntegrationsCompanion.insert({
    required String vendor,
    required String status,
    this.lastAttempt = const Value.absent(),
    this.lastSync = const Value.absent(),
    this.changesToken = const Value.absent(),
    this.recordsToday = const Value.absent(),
    this.diagnosticsJson = const Value.absent(),
    this.lastError = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : vendor = Value(vendor),
        status = Value(status);
  static Insertable<IntegrationRow> custom({
    Expression<String>? vendor,
    Expression<String>? status,
    Expression<DateTime>? lastAttempt,
    Expression<DateTime>? lastSync,
    Expression<String>? changesToken,
    Expression<int>? recordsToday,
    Expression<String>? diagnosticsJson,
    Expression<String>? lastError,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (vendor != null) 'vendor': vendor,
      if (status != null) 'status': status,
      if (lastAttempt != null) 'last_attempt': lastAttempt,
      if (lastSync != null) 'last_sync': lastSync,
      if (changesToken != null) 'changes_token': changesToken,
      if (recordsToday != null) 'records_today': recordsToday,
      if (diagnosticsJson != null) 'diagnostics_json': diagnosticsJson,
      if (lastError != null) 'last_error': lastError,
      if (rowid != null) 'rowid': rowid,
    });
  }

  IntegrationsCompanion copyWith(
      {Value<String>? vendor,
      Value<String>? status,
      Value<DateTime?>? lastAttempt,
      Value<DateTime?>? lastSync,
      Value<String?>? changesToken,
      Value<int>? recordsToday,
      Value<String>? diagnosticsJson,
      Value<String?>? lastError,
      Value<int>? rowid}) {
    return IntegrationsCompanion(
      vendor: vendor ?? this.vendor,
      status: status ?? this.status,
      lastAttempt: lastAttempt ?? this.lastAttempt,
      lastSync: lastSync ?? this.lastSync,
      changesToken: changesToken ?? this.changesToken,
      recordsToday: recordsToday ?? this.recordsToday,
      diagnosticsJson: diagnosticsJson ?? this.diagnosticsJson,
      lastError: lastError ?? this.lastError,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (vendor.present) {
      map['vendor'] = Variable<String>(vendor.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (lastAttempt.present) {
      map['last_attempt'] = Variable<DateTime>(lastAttempt.value);
    }
    if (lastSync.present) {
      map['last_sync'] = Variable<DateTime>(lastSync.value);
    }
    if (changesToken.present) {
      map['changes_token'] = Variable<String>(changesToken.value);
    }
    if (recordsToday.present) {
      map['records_today'] = Variable<int>(recordsToday.value);
    }
    if (diagnosticsJson.present) {
      map['diagnostics_json'] = Variable<String>(diagnosticsJson.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IntegrationsCompanion(')
          ..write('vendor: $vendor, ')
          ..write('status: $status, ')
          ..write('lastAttempt: $lastAttempt, ')
          ..write('lastSync: $lastSync, ')
          ..write('changesToken: $changesToken, ')
          ..write('recordsToday: $recordsToday, ')
          ..write('diagnosticsJson: $diagnosticsJson, ')
          ..write('lastError: $lastError, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StrengthWorkoutsTable extends StrengthWorkouts
    with TableInfo<$StrengthWorkoutsTable, StrengthWorkoutRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StrengthWorkoutsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _startedAtMeta =
      const VerificationMeta('startedAt');
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
      'started_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _endedAtMeta =
      const VerificationMeta('endedAt');
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
      'ended_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _bodyWeightKgAtTimeMeta =
      const VerificationMeta('bodyWeightKgAtTime');
  @override
  late final GeneratedColumn<double> bodyWeightKgAtTime =
      GeneratedColumn<double>('body_weight_kg_at_time', aliasedName, false,
          type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _exercisesJsonMeta =
      const VerificationMeta('exercisesJson');
  @override
  late final GeneratedColumn<String> exercisesJson = GeneratedColumn<String>(
      'exercises_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fallbackKcalMeta =
      const VerificationMeta('fallbackKcal');
  @override
  late final GeneratedColumn<double> fallbackKcal = GeneratedColumn<double>(
      'fallback_kcal', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _finalKcalMeta =
      const VerificationMeta('finalKcal');
  @override
  late final GeneratedColumn<double> finalKcal = GeneratedColumn<double>(
      'final_kcal', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
      'method', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('fallback'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        startedAt,
        endedAt,
        bodyWeightKgAtTime,
        exercisesJson,
        fallbackKcal,
        finalKcal,
        method
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'strength_workouts';
  @override
  VerificationContext validateIntegrity(Insertable<StrengthWorkoutRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(_startedAtMeta,
          startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta));
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(_endedAtMeta,
          endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta));
    } else if (isInserting) {
      context.missing(_endedAtMeta);
    }
    if (data.containsKey('body_weight_kg_at_time')) {
      context.handle(
          _bodyWeightKgAtTimeMeta,
          bodyWeightKgAtTime.isAcceptableOrUnknown(
              data['body_weight_kg_at_time']!, _bodyWeightKgAtTimeMeta));
    } else if (isInserting) {
      context.missing(_bodyWeightKgAtTimeMeta);
    }
    if (data.containsKey('exercises_json')) {
      context.handle(
          _exercisesJsonMeta,
          exercisesJson.isAcceptableOrUnknown(
              data['exercises_json']!, _exercisesJsonMeta));
    } else if (isInserting) {
      context.missing(_exercisesJsonMeta);
    }
    if (data.containsKey('fallback_kcal')) {
      context.handle(
          _fallbackKcalMeta,
          fallbackKcal.isAcceptableOrUnknown(
              data['fallback_kcal']!, _fallbackKcalMeta));
    } else if (isInserting) {
      context.missing(_fallbackKcalMeta);
    }
    if (data.containsKey('final_kcal')) {
      context.handle(_finalKcalMeta,
          finalKcal.isAcceptableOrUnknown(data['final_kcal']!, _finalKcalMeta));
    } else if (isInserting) {
      context.missing(_finalKcalMeta);
    }
    if (data.containsKey('method')) {
      context.handle(_methodMeta,
          method.isAcceptableOrUnknown(data['method']!, _methodMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StrengthWorkoutRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StrengthWorkoutRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      startedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}started_at'])!,
      endedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}ended_at'])!,
      bodyWeightKgAtTime: attachedDatabase.typeMapping.read(DriftSqlType.double,
          data['${effectivePrefix}body_weight_kg_at_time'])!,
      exercisesJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}exercises_json'])!,
      fallbackKcal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}fallback_kcal'])!,
      finalKcal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}final_kcal'])!,
      method: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}method'])!,
    );
  }

  @override
  $StrengthWorkoutsTable createAlias(String alias) {
    return $StrengthWorkoutsTable(attachedDatabase, alias);
  }
}

class StrengthWorkoutRow extends DataClass
    implements Insertable<StrengthWorkoutRow> {
  final String id;
  final DateTime startedAt;
  final DateTime endedAt;
  final double bodyWeightKgAtTime;
  final String exercisesJson;
  final double fallbackKcal;
  final double finalKcal;
  final String method;
  const StrengthWorkoutRow(
      {required this.id,
      required this.startedAt,
      required this.endedAt,
      required this.bodyWeightKgAtTime,
      required this.exercisesJson,
      required this.fallbackKcal,
      required this.finalKcal,
      required this.method});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['started_at'] = Variable<DateTime>(startedAt);
    map['ended_at'] = Variable<DateTime>(endedAt);
    map['body_weight_kg_at_time'] = Variable<double>(bodyWeightKgAtTime);
    map['exercises_json'] = Variable<String>(exercisesJson);
    map['fallback_kcal'] = Variable<double>(fallbackKcal);
    map['final_kcal'] = Variable<double>(finalKcal);
    map['method'] = Variable<String>(method);
    return map;
  }

  StrengthWorkoutsCompanion toCompanion(bool nullToAbsent) {
    return StrengthWorkoutsCompanion(
      id: Value(id),
      startedAt: Value(startedAt),
      endedAt: Value(endedAt),
      bodyWeightKgAtTime: Value(bodyWeightKgAtTime),
      exercisesJson: Value(exercisesJson),
      fallbackKcal: Value(fallbackKcal),
      finalKcal: Value(finalKcal),
      method: Value(method),
    );
  }

  factory StrengthWorkoutRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StrengthWorkoutRow(
      id: serializer.fromJson<String>(json['id']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime>(json['endedAt']),
      bodyWeightKgAtTime:
          serializer.fromJson<double>(json['bodyWeightKgAtTime']),
      exercisesJson: serializer.fromJson<String>(json['exercisesJson']),
      fallbackKcal: serializer.fromJson<double>(json['fallbackKcal']),
      finalKcal: serializer.fromJson<double>(json['finalKcal']),
      method: serializer.fromJson<String>(json['method']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime>(endedAt),
      'bodyWeightKgAtTime': serializer.toJson<double>(bodyWeightKgAtTime),
      'exercisesJson': serializer.toJson<String>(exercisesJson),
      'fallbackKcal': serializer.toJson<double>(fallbackKcal),
      'finalKcal': serializer.toJson<double>(finalKcal),
      'method': serializer.toJson<String>(method),
    };
  }

  StrengthWorkoutRow copyWith(
          {String? id,
          DateTime? startedAt,
          DateTime? endedAt,
          double? bodyWeightKgAtTime,
          String? exercisesJson,
          double? fallbackKcal,
          double? finalKcal,
          String? method}) =>
      StrengthWorkoutRow(
        id: id ?? this.id,
        startedAt: startedAt ?? this.startedAt,
        endedAt: endedAt ?? this.endedAt,
        bodyWeightKgAtTime: bodyWeightKgAtTime ?? this.bodyWeightKgAtTime,
        exercisesJson: exercisesJson ?? this.exercisesJson,
        fallbackKcal: fallbackKcal ?? this.fallbackKcal,
        finalKcal: finalKcal ?? this.finalKcal,
        method: method ?? this.method,
      );
  StrengthWorkoutRow copyWithCompanion(StrengthWorkoutsCompanion data) {
    return StrengthWorkoutRow(
      id: data.id.present ? data.id.value : this.id,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      bodyWeightKgAtTime: data.bodyWeightKgAtTime.present
          ? data.bodyWeightKgAtTime.value
          : this.bodyWeightKgAtTime,
      exercisesJson: data.exercisesJson.present
          ? data.exercisesJson.value
          : this.exercisesJson,
      fallbackKcal: data.fallbackKcal.present
          ? data.fallbackKcal.value
          : this.fallbackKcal,
      finalKcal: data.finalKcal.present ? data.finalKcal.value : this.finalKcal,
      method: data.method.present ? data.method.value : this.method,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StrengthWorkoutRow(')
          ..write('id: $id, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('bodyWeightKgAtTime: $bodyWeightKgAtTime, ')
          ..write('exercisesJson: $exercisesJson, ')
          ..write('fallbackKcal: $fallbackKcal, ')
          ..write('finalKcal: $finalKcal, ')
          ..write('method: $method')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, startedAt, endedAt, bodyWeightKgAtTime,
      exercisesJson, fallbackKcal, finalKcal, method);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StrengthWorkoutRow &&
          other.id == this.id &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.bodyWeightKgAtTime == this.bodyWeightKgAtTime &&
          other.exercisesJson == this.exercisesJson &&
          other.fallbackKcal == this.fallbackKcal &&
          other.finalKcal == this.finalKcal &&
          other.method == this.method);
}

class StrengthWorkoutsCompanion extends UpdateCompanion<StrengthWorkoutRow> {
  final Value<String> id;
  final Value<DateTime> startedAt;
  final Value<DateTime> endedAt;
  final Value<double> bodyWeightKgAtTime;
  final Value<String> exercisesJson;
  final Value<double> fallbackKcal;
  final Value<double> finalKcal;
  final Value<String> method;
  final Value<int> rowid;
  const StrengthWorkoutsCompanion({
    this.id = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.bodyWeightKgAtTime = const Value.absent(),
    this.exercisesJson = const Value.absent(),
    this.fallbackKcal = const Value.absent(),
    this.finalKcal = const Value.absent(),
    this.method = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StrengthWorkoutsCompanion.insert({
    required String id,
    required DateTime startedAt,
    required DateTime endedAt,
    required double bodyWeightKgAtTime,
    required String exercisesJson,
    required double fallbackKcal,
    required double finalKcal,
    this.method = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        startedAt = Value(startedAt),
        endedAt = Value(endedAt),
        bodyWeightKgAtTime = Value(bodyWeightKgAtTime),
        exercisesJson = Value(exercisesJson),
        fallbackKcal = Value(fallbackKcal),
        finalKcal = Value(finalKcal);
  static Insertable<StrengthWorkoutRow> custom({
    Expression<String>? id,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<double>? bodyWeightKgAtTime,
    Expression<String>? exercisesJson,
    Expression<double>? fallbackKcal,
    Expression<double>? finalKcal,
    Expression<String>? method,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (bodyWeightKgAtTime != null)
        'body_weight_kg_at_time': bodyWeightKgAtTime,
      if (exercisesJson != null) 'exercises_json': exercisesJson,
      if (fallbackKcal != null) 'fallback_kcal': fallbackKcal,
      if (finalKcal != null) 'final_kcal': finalKcal,
      if (method != null) 'method': method,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StrengthWorkoutsCompanion copyWith(
      {Value<String>? id,
      Value<DateTime>? startedAt,
      Value<DateTime>? endedAt,
      Value<double>? bodyWeightKgAtTime,
      Value<String>? exercisesJson,
      Value<double>? fallbackKcal,
      Value<double>? finalKcal,
      Value<String>? method,
      Value<int>? rowid}) {
    return StrengthWorkoutsCompanion(
      id: id ?? this.id,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      bodyWeightKgAtTime: bodyWeightKgAtTime ?? this.bodyWeightKgAtTime,
      exercisesJson: exercisesJson ?? this.exercisesJson,
      fallbackKcal: fallbackKcal ?? this.fallbackKcal,
      finalKcal: finalKcal ?? this.finalKcal,
      method: method ?? this.method,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (bodyWeightKgAtTime.present) {
      map['body_weight_kg_at_time'] =
          Variable<double>(bodyWeightKgAtTime.value);
    }
    if (exercisesJson.present) {
      map['exercises_json'] = Variable<String>(exercisesJson.value);
    }
    if (fallbackKcal.present) {
      map['fallback_kcal'] = Variable<double>(fallbackKcal.value);
    }
    if (finalKcal.present) {
      map['final_kcal'] = Variable<double>(finalKcal.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StrengthWorkoutsCompanion(')
          ..write('id: $id, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('bodyWeightKgAtTime: $bodyWeightKgAtTime, ')
          ..write('exercisesJson: $exercisesJson, ')
          ..write('fallbackKcal: $fallbackKcal, ')
          ..write('finalKcal: $finalKcal, ')
          ..write('method: $method, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WeightEntriesTable extends WeightEntries
    with TableInfo<$WeightEntriesTable, WeightEntryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeightEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _recordedAtMeta =
      const VerificationMeta('recordedAt');
  @override
  late final GeneratedColumn<DateTime> recordedAt = GeneratedColumn<DateTime>(
      'recorded_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _kgMeta = const VerificationMeta('kg');
  @override
  late final GeneratedColumn<double> kg = GeneratedColumn<double>(
      'kg', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
      'source', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('manual'));
  @override
  List<GeneratedColumn> get $columns => [id, recordedAt, kg, source];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weight_entries';
  @override
  VerificationContext validateIntegrity(Insertable<WeightEntryRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
          _recordedAtMeta,
          recordedAt.isAcceptableOrUnknown(
              data['recorded_at']!, _recordedAtMeta));
    } else if (isInserting) {
      context.missing(_recordedAtMeta);
    }
    if (data.containsKey('kg')) {
      context.handle(_kgMeta, kg.isAcceptableOrUnknown(data['kg']!, _kgMeta));
    } else if (isInserting) {
      context.missing(_kgMeta);
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta,
          source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WeightEntryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeightEntryRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      recordedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}recorded_at'])!,
      kg: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}kg'])!,
      source: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source'])!,
    );
  }

  @override
  $WeightEntriesTable createAlias(String alias) {
    return $WeightEntriesTable(attachedDatabase, alias);
  }
}

class WeightEntryRow extends DataClass implements Insertable<WeightEntryRow> {
  final int id;
  final DateTime recordedAt;
  final double kg;
  final String source;
  const WeightEntryRow(
      {required this.id,
      required this.recordedAt,
      required this.kg,
      required this.source});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['recorded_at'] = Variable<DateTime>(recordedAt);
    map['kg'] = Variable<double>(kg);
    map['source'] = Variable<String>(source);
    return map;
  }

  WeightEntriesCompanion toCompanion(bool nullToAbsent) {
    return WeightEntriesCompanion(
      id: Value(id),
      recordedAt: Value(recordedAt),
      kg: Value(kg),
      source: Value(source),
    );
  }

  factory WeightEntryRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeightEntryRow(
      id: serializer.fromJson<int>(json['id']),
      recordedAt: serializer.fromJson<DateTime>(json['recordedAt']),
      kg: serializer.fromJson<double>(json['kg']),
      source: serializer.fromJson<String>(json['source']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'recordedAt': serializer.toJson<DateTime>(recordedAt),
      'kg': serializer.toJson<double>(kg),
      'source': serializer.toJson<String>(source),
    };
  }

  WeightEntryRow copyWith(
          {int? id, DateTime? recordedAt, double? kg, String? source}) =>
      WeightEntryRow(
        id: id ?? this.id,
        recordedAt: recordedAt ?? this.recordedAt,
        kg: kg ?? this.kg,
        source: source ?? this.source,
      );
  WeightEntryRow copyWithCompanion(WeightEntriesCompanion data) {
    return WeightEntryRow(
      id: data.id.present ? data.id.value : this.id,
      recordedAt:
          data.recordedAt.present ? data.recordedAt.value : this.recordedAt,
      kg: data.kg.present ? data.kg.value : this.kg,
      source: data.source.present ? data.source.value : this.source,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeightEntryRow(')
          ..write('id: $id, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('kg: $kg, ')
          ..write('source: $source')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, recordedAt, kg, source);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeightEntryRow &&
          other.id == this.id &&
          other.recordedAt == this.recordedAt &&
          other.kg == this.kg &&
          other.source == this.source);
}

class WeightEntriesCompanion extends UpdateCompanion<WeightEntryRow> {
  final Value<int> id;
  final Value<DateTime> recordedAt;
  final Value<double> kg;
  final Value<String> source;
  const WeightEntriesCompanion({
    this.id = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.kg = const Value.absent(),
    this.source = const Value.absent(),
  });
  WeightEntriesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime recordedAt,
    required double kg,
    this.source = const Value.absent(),
  })  : recordedAt = Value(recordedAt),
        kg = Value(kg);
  static Insertable<WeightEntryRow> custom({
    Expression<int>? id,
    Expression<DateTime>? recordedAt,
    Expression<double>? kg,
    Expression<String>? source,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (kg != null) 'kg': kg,
      if (source != null) 'source': source,
    });
  }

  WeightEntriesCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? recordedAt,
      Value<double>? kg,
      Value<String>? source}) {
    return WeightEntriesCompanion(
      id: id ?? this.id,
      recordedAt: recordedAt ?? this.recordedAt,
      kg: kg ?? this.kg,
      source: source ?? this.source,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<DateTime>(recordedAt.value);
    }
    if (kg.present) {
      map['kg'] = Variable<double>(kg.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeightEntriesCompanion(')
          ..write('id: $id, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('kg: $kg, ')
          ..write('source: $source')
          ..write(')'))
        .toString();
  }
}

class $NutritionEntriesTable extends NutritionEntries
    with TableInfo<$NutritionEntriesTable, NutritionEntryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NutritionEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _recordedAtMeta =
      const VerificationMeta('recordedAt');
  @override
  late final GeneratedColumn<DateTime> recordedAt = GeneratedColumn<DateTime>(
      'recorded_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _kcalMeta = const VerificationMeta('kcal');
  @override
  late final GeneratedColumn<double> kcal = GeneratedColumn<double>(
      'kcal', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _proteinGMeta =
      const VerificationMeta('proteinG');
  @override
  late final GeneratedColumn<double> proteinG = GeneratedColumn<double>(
      'protein_g', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _carbsGMeta = const VerificationMeta('carbsG');
  @override
  late final GeneratedColumn<double> carbsG = GeneratedColumn<double>(
      'carbs_g', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _fatGMeta = const VerificationMeta('fatG');
  @override
  late final GeneratedColumn<double> fatG = GeneratedColumn<double>(
      'fat_g', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _mealMeta = const VerificationMeta('meal');
  @override
  late final GeneratedColumn<String> meal = GeneratedColumn<String>(
      'meal', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
      'source', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('eter'));
  static const VerificationMeta _metadataJsonMeta =
      const VerificationMeta('metadataJson');
  @override
  late final GeneratedColumn<String> metadataJson = GeneratedColumn<String>(
      'metadata_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('{}'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        recordedAt,
        kcal,
        proteinG,
        carbsG,
        fatG,
        meal,
        source,
        metadataJson
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'nutrition_entries';
  @override
  VerificationContext validateIntegrity(Insertable<NutritionEntryRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
          _recordedAtMeta,
          recordedAt.isAcceptableOrUnknown(
              data['recorded_at']!, _recordedAtMeta));
    } else if (isInserting) {
      context.missing(_recordedAtMeta);
    }
    if (data.containsKey('kcal')) {
      context.handle(
          _kcalMeta, kcal.isAcceptableOrUnknown(data['kcal']!, _kcalMeta));
    } else if (isInserting) {
      context.missing(_kcalMeta);
    }
    if (data.containsKey('protein_g')) {
      context.handle(_proteinGMeta,
          proteinG.isAcceptableOrUnknown(data['protein_g']!, _proteinGMeta));
    }
    if (data.containsKey('carbs_g')) {
      context.handle(_carbsGMeta,
          carbsG.isAcceptableOrUnknown(data['carbs_g']!, _carbsGMeta));
    }
    if (data.containsKey('fat_g')) {
      context.handle(
          _fatGMeta, fatG.isAcceptableOrUnknown(data['fat_g']!, _fatGMeta));
    }
    if (data.containsKey('meal')) {
      context.handle(
          _mealMeta, meal.isAcceptableOrUnknown(data['meal']!, _mealMeta));
    } else if (isInserting) {
      context.missing(_mealMeta);
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta,
          source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    }
    if (data.containsKey('metadata_json')) {
      context.handle(
          _metadataJsonMeta,
          metadataJson.isAcceptableOrUnknown(
              data['metadata_json']!, _metadataJsonMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NutritionEntryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NutritionEntryRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      recordedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}recorded_at'])!,
      kcal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}kcal'])!,
      proteinG: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}protein_g']),
      carbsG: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}carbs_g']),
      fatG: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}fat_g']),
      meal: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}meal'])!,
      source: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source'])!,
      metadataJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}metadata_json'])!,
    );
  }

  @override
  $NutritionEntriesTable createAlias(String alias) {
    return $NutritionEntriesTable(attachedDatabase, alias);
  }
}

class NutritionEntryRow extends DataClass
    implements Insertable<NutritionEntryRow> {
  final int id;
  final DateTime recordedAt;
  final double kcal;
  final double? proteinG;
  final double? carbsG;
  final double? fatG;
  final String meal;
  final String source;
  final String metadataJson;
  const NutritionEntryRow(
      {required this.id,
      required this.recordedAt,
      required this.kcal,
      this.proteinG,
      this.carbsG,
      this.fatG,
      required this.meal,
      required this.source,
      required this.metadataJson});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['recorded_at'] = Variable<DateTime>(recordedAt);
    map['kcal'] = Variable<double>(kcal);
    if (!nullToAbsent || proteinG != null) {
      map['protein_g'] = Variable<double>(proteinG);
    }
    if (!nullToAbsent || carbsG != null) {
      map['carbs_g'] = Variable<double>(carbsG);
    }
    if (!nullToAbsent || fatG != null) {
      map['fat_g'] = Variable<double>(fatG);
    }
    map['meal'] = Variable<String>(meal);
    map['source'] = Variable<String>(source);
    map['metadata_json'] = Variable<String>(metadataJson);
    return map;
  }

  NutritionEntriesCompanion toCompanion(bool nullToAbsent) {
    return NutritionEntriesCompanion(
      id: Value(id),
      recordedAt: Value(recordedAt),
      kcal: Value(kcal),
      proteinG: proteinG == null && nullToAbsent
          ? const Value.absent()
          : Value(proteinG),
      carbsG:
          carbsG == null && nullToAbsent ? const Value.absent() : Value(carbsG),
      fatG: fatG == null && nullToAbsent ? const Value.absent() : Value(fatG),
      meal: Value(meal),
      source: Value(source),
      metadataJson: Value(metadataJson),
    );
  }

  factory NutritionEntryRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NutritionEntryRow(
      id: serializer.fromJson<int>(json['id']),
      recordedAt: serializer.fromJson<DateTime>(json['recordedAt']),
      kcal: serializer.fromJson<double>(json['kcal']),
      proteinG: serializer.fromJson<double?>(json['proteinG']),
      carbsG: serializer.fromJson<double?>(json['carbsG']),
      fatG: serializer.fromJson<double?>(json['fatG']),
      meal: serializer.fromJson<String>(json['meal']),
      source: serializer.fromJson<String>(json['source']),
      metadataJson: serializer.fromJson<String>(json['metadataJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'recordedAt': serializer.toJson<DateTime>(recordedAt),
      'kcal': serializer.toJson<double>(kcal),
      'proteinG': serializer.toJson<double?>(proteinG),
      'carbsG': serializer.toJson<double?>(carbsG),
      'fatG': serializer.toJson<double?>(fatG),
      'meal': serializer.toJson<String>(meal),
      'source': serializer.toJson<String>(source),
      'metadataJson': serializer.toJson<String>(metadataJson),
    };
  }

  NutritionEntryRow copyWith(
          {int? id,
          DateTime? recordedAt,
          double? kcal,
          Value<double?> proteinG = const Value.absent(),
          Value<double?> carbsG = const Value.absent(),
          Value<double?> fatG = const Value.absent(),
          String? meal,
          String? source,
          String? metadataJson}) =>
      NutritionEntryRow(
        id: id ?? this.id,
        recordedAt: recordedAt ?? this.recordedAt,
        kcal: kcal ?? this.kcal,
        proteinG: proteinG.present ? proteinG.value : this.proteinG,
        carbsG: carbsG.present ? carbsG.value : this.carbsG,
        fatG: fatG.present ? fatG.value : this.fatG,
        meal: meal ?? this.meal,
        source: source ?? this.source,
        metadataJson: metadataJson ?? this.metadataJson,
      );
  NutritionEntryRow copyWithCompanion(NutritionEntriesCompanion data) {
    return NutritionEntryRow(
      id: data.id.present ? data.id.value : this.id,
      recordedAt:
          data.recordedAt.present ? data.recordedAt.value : this.recordedAt,
      kcal: data.kcal.present ? data.kcal.value : this.kcal,
      proteinG: data.proteinG.present ? data.proteinG.value : this.proteinG,
      carbsG: data.carbsG.present ? data.carbsG.value : this.carbsG,
      fatG: data.fatG.present ? data.fatG.value : this.fatG,
      meal: data.meal.present ? data.meal.value : this.meal,
      source: data.source.present ? data.source.value : this.source,
      metadataJson: data.metadataJson.present
          ? data.metadataJson.value
          : this.metadataJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NutritionEntryRow(')
          ..write('id: $id, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('kcal: $kcal, ')
          ..write('proteinG: $proteinG, ')
          ..write('carbsG: $carbsG, ')
          ..write('fatG: $fatG, ')
          ..write('meal: $meal, ')
          ..write('source: $source, ')
          ..write('metadataJson: $metadataJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, recordedAt, kcal, proteinG, carbsG, fatG, meal, source, metadataJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NutritionEntryRow &&
          other.id == this.id &&
          other.recordedAt == this.recordedAt &&
          other.kcal == this.kcal &&
          other.proteinG == this.proteinG &&
          other.carbsG == this.carbsG &&
          other.fatG == this.fatG &&
          other.meal == this.meal &&
          other.source == this.source &&
          other.metadataJson == this.metadataJson);
}

class NutritionEntriesCompanion extends UpdateCompanion<NutritionEntryRow> {
  final Value<int> id;
  final Value<DateTime> recordedAt;
  final Value<double> kcal;
  final Value<double?> proteinG;
  final Value<double?> carbsG;
  final Value<double?> fatG;
  final Value<String> meal;
  final Value<String> source;
  final Value<String> metadataJson;
  const NutritionEntriesCompanion({
    this.id = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.kcal = const Value.absent(),
    this.proteinG = const Value.absent(),
    this.carbsG = const Value.absent(),
    this.fatG = const Value.absent(),
    this.meal = const Value.absent(),
    this.source = const Value.absent(),
    this.metadataJson = const Value.absent(),
  });
  NutritionEntriesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime recordedAt,
    required double kcal,
    this.proteinG = const Value.absent(),
    this.carbsG = const Value.absent(),
    this.fatG = const Value.absent(),
    required String meal,
    this.source = const Value.absent(),
    this.metadataJson = const Value.absent(),
  })  : recordedAt = Value(recordedAt),
        kcal = Value(kcal),
        meal = Value(meal);
  static Insertable<NutritionEntryRow> custom({
    Expression<int>? id,
    Expression<DateTime>? recordedAt,
    Expression<double>? kcal,
    Expression<double>? proteinG,
    Expression<double>? carbsG,
    Expression<double>? fatG,
    Expression<String>? meal,
    Expression<String>? source,
    Expression<String>? metadataJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (kcal != null) 'kcal': kcal,
      if (proteinG != null) 'protein_g': proteinG,
      if (carbsG != null) 'carbs_g': carbsG,
      if (fatG != null) 'fat_g': fatG,
      if (meal != null) 'meal': meal,
      if (source != null) 'source': source,
      if (metadataJson != null) 'metadata_json': metadataJson,
    });
  }

  NutritionEntriesCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? recordedAt,
      Value<double>? kcal,
      Value<double?>? proteinG,
      Value<double?>? carbsG,
      Value<double?>? fatG,
      Value<String>? meal,
      Value<String>? source,
      Value<String>? metadataJson}) {
    return NutritionEntriesCompanion(
      id: id ?? this.id,
      recordedAt: recordedAt ?? this.recordedAt,
      kcal: kcal ?? this.kcal,
      proteinG: proteinG ?? this.proteinG,
      carbsG: carbsG ?? this.carbsG,
      fatG: fatG ?? this.fatG,
      meal: meal ?? this.meal,
      source: source ?? this.source,
      metadataJson: metadataJson ?? this.metadataJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<DateTime>(recordedAt.value);
    }
    if (kcal.present) {
      map['kcal'] = Variable<double>(kcal.value);
    }
    if (proteinG.present) {
      map['protein_g'] = Variable<double>(proteinG.value);
    }
    if (carbsG.present) {
      map['carbs_g'] = Variable<double>(carbsG.value);
    }
    if (fatG.present) {
      map['fat_g'] = Variable<double>(fatG.value);
    }
    if (meal.present) {
      map['meal'] = Variable<String>(meal.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (metadataJson.present) {
      map['metadata_json'] = Variable<String>(metadataJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NutritionEntriesCompanion(')
          ..write('id: $id, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('kcal: $kcal, ')
          ..write('proteinG: $proteinG, ')
          ..write('carbsG: $carbsG, ')
          ..write('fatG: $fatG, ')
          ..write('meal: $meal, ')
          ..write('source: $source, ')
          ..write('metadataJson: $metadataJson')
          ..write(')'))
        .toString();
  }
}

class $LiveSessionsTable extends LiveSessions
    with TableInfo<$LiveSessionsTable, LiveSessionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LiveSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _startedAtMeta =
      const VerificationMeta('startedAt');
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
      'started_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _endedAtMeta =
      const VerificationMeta('endedAt');
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
      'ended_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _sourceIdMeta =
      const VerificationMeta('sourceId');
  @override
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
      'source_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _hrSeriesJsonMeta =
      const VerificationMeta('hrSeriesJson');
  @override
  late final GeneratedColumn<String> hrSeriesJson = GeneratedColumn<String>(
      'hr_series_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _finalKcalMeta =
      const VerificationMeta('finalKcal');
  @override
  late final GeneratedColumn<double> finalKcal = GeneratedColumn<double>(
      'final_kcal', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, startedAt, endedAt, sourceId, hrSeriesJson, finalKcal];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'live_sessions';
  @override
  VerificationContext validateIntegrity(Insertable<LiveSessionRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(_startedAtMeta,
          startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta));
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(_endedAtMeta,
          endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta));
    } else if (isInserting) {
      context.missing(_endedAtMeta);
    }
    if (data.containsKey('source_id')) {
      context.handle(_sourceIdMeta,
          sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta));
    } else if (isInserting) {
      context.missing(_sourceIdMeta);
    }
    if (data.containsKey('hr_series_json')) {
      context.handle(
          _hrSeriesJsonMeta,
          hrSeriesJson.isAcceptableOrUnknown(
              data['hr_series_json']!, _hrSeriesJsonMeta));
    } else if (isInserting) {
      context.missing(_hrSeriesJsonMeta);
    }
    if (data.containsKey('final_kcal')) {
      context.handle(_finalKcalMeta,
          finalKcal.isAcceptableOrUnknown(data['final_kcal']!, _finalKcalMeta));
    } else if (isInserting) {
      context.missing(_finalKcalMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LiveSessionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LiveSessionRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      startedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}started_at'])!,
      endedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}ended_at'])!,
      sourceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source_id'])!,
      hrSeriesJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}hr_series_json'])!,
      finalKcal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}final_kcal'])!,
    );
  }

  @override
  $LiveSessionsTable createAlias(String alias) {
    return $LiveSessionsTable(attachedDatabase, alias);
  }
}

class LiveSessionRow extends DataClass implements Insertable<LiveSessionRow> {
  final String id;
  final DateTime startedAt;
  final DateTime endedAt;
  final String sourceId;
  final String hrSeriesJson;
  final double finalKcal;
  const LiveSessionRow(
      {required this.id,
      required this.startedAt,
      required this.endedAt,
      required this.sourceId,
      required this.hrSeriesJson,
      required this.finalKcal});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['started_at'] = Variable<DateTime>(startedAt);
    map['ended_at'] = Variable<DateTime>(endedAt);
    map['source_id'] = Variable<String>(sourceId);
    map['hr_series_json'] = Variable<String>(hrSeriesJson);
    map['final_kcal'] = Variable<double>(finalKcal);
    return map;
  }

  LiveSessionsCompanion toCompanion(bool nullToAbsent) {
    return LiveSessionsCompanion(
      id: Value(id),
      startedAt: Value(startedAt),
      endedAt: Value(endedAt),
      sourceId: Value(sourceId),
      hrSeriesJson: Value(hrSeriesJson),
      finalKcal: Value(finalKcal),
    );
  }

  factory LiveSessionRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LiveSessionRow(
      id: serializer.fromJson<String>(json['id']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime>(json['endedAt']),
      sourceId: serializer.fromJson<String>(json['sourceId']),
      hrSeriesJson: serializer.fromJson<String>(json['hrSeriesJson']),
      finalKcal: serializer.fromJson<double>(json['finalKcal']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime>(endedAt),
      'sourceId': serializer.toJson<String>(sourceId),
      'hrSeriesJson': serializer.toJson<String>(hrSeriesJson),
      'finalKcal': serializer.toJson<double>(finalKcal),
    };
  }

  LiveSessionRow copyWith(
          {String? id,
          DateTime? startedAt,
          DateTime? endedAt,
          String? sourceId,
          String? hrSeriesJson,
          double? finalKcal}) =>
      LiveSessionRow(
        id: id ?? this.id,
        startedAt: startedAt ?? this.startedAt,
        endedAt: endedAt ?? this.endedAt,
        sourceId: sourceId ?? this.sourceId,
        hrSeriesJson: hrSeriesJson ?? this.hrSeriesJson,
        finalKcal: finalKcal ?? this.finalKcal,
      );
  LiveSessionRow copyWithCompanion(LiveSessionsCompanion data) {
    return LiveSessionRow(
      id: data.id.present ? data.id.value : this.id,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      hrSeriesJson: data.hrSeriesJson.present
          ? data.hrSeriesJson.value
          : this.hrSeriesJson,
      finalKcal: data.finalKcal.present ? data.finalKcal.value : this.finalKcal,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LiveSessionRow(')
          ..write('id: $id, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('sourceId: $sourceId, ')
          ..write('hrSeriesJson: $hrSeriesJson, ')
          ..write('finalKcal: $finalKcal')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, startedAt, endedAt, sourceId, hrSeriesJson, finalKcal);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LiveSessionRow &&
          other.id == this.id &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.sourceId == this.sourceId &&
          other.hrSeriesJson == this.hrSeriesJson &&
          other.finalKcal == this.finalKcal);
}

class LiveSessionsCompanion extends UpdateCompanion<LiveSessionRow> {
  final Value<String> id;
  final Value<DateTime> startedAt;
  final Value<DateTime> endedAt;
  final Value<String> sourceId;
  final Value<String> hrSeriesJson;
  final Value<double> finalKcal;
  final Value<int> rowid;
  const LiveSessionsCompanion({
    this.id = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.hrSeriesJson = const Value.absent(),
    this.finalKcal = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LiveSessionsCompanion.insert({
    required String id,
    required DateTime startedAt,
    required DateTime endedAt,
    required String sourceId,
    required String hrSeriesJson,
    required double finalKcal,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        startedAt = Value(startedAt),
        endedAt = Value(endedAt),
        sourceId = Value(sourceId),
        hrSeriesJson = Value(hrSeriesJson),
        finalKcal = Value(finalKcal);
  static Insertable<LiveSessionRow> custom({
    Expression<String>? id,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<String>? sourceId,
    Expression<String>? hrSeriesJson,
    Expression<double>? finalKcal,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (sourceId != null) 'source_id': sourceId,
      if (hrSeriesJson != null) 'hr_series_json': hrSeriesJson,
      if (finalKcal != null) 'final_kcal': finalKcal,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LiveSessionsCompanion copyWith(
      {Value<String>? id,
      Value<DateTime>? startedAt,
      Value<DateTime>? endedAt,
      Value<String>? sourceId,
      Value<String>? hrSeriesJson,
      Value<double>? finalKcal,
      Value<int>? rowid}) {
    return LiveSessionsCompanion(
      id: id ?? this.id,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      sourceId: sourceId ?? this.sourceId,
      hrSeriesJson: hrSeriesJson ?? this.hrSeriesJson,
      finalKcal: finalKcal ?? this.finalKcal,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    if (hrSeriesJson.present) {
      map['hr_series_json'] = Variable<String>(hrSeriesJson.value);
    }
    if (finalKcal.present) {
      map['final_kcal'] = Variable<double>(finalKcal.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LiveSessionsCompanion(')
          ..write('id: $id, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('sourceId: $sourceId, ')
          ..write('hrSeriesJson: $hrSeriesJson, ')
          ..write('finalKcal: $finalKcal, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RememberedSensorsTable extends RememberedSensors
    with TableInfo<$RememberedSensorsTable, RememberedSensorRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RememberedSensorsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _deviceIdMeta =
      const VerificationMeta('deviceId');
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
      'device_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _pairedMeta = const VerificationMeta('paired');
  @override
  late final GeneratedColumn<bool> paired = GeneratedColumn<bool>(
      'paired', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("paired" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _lastConnectedMeta =
      const VerificationMeta('lastConnected');
  @override
  late final GeneratedColumn<DateTime> lastConnected =
      GeneratedColumn<DateTime>('last_connected', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [deviceId, name, paired, lastConnected];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'remembered_sensors';
  @override
  VerificationContext validateIntegrity(
      Insertable<RememberedSensorRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('paired')) {
      context.handle(_pairedMeta,
          paired.isAcceptableOrUnknown(data['paired']!, _pairedMeta));
    }
    if (data.containsKey('last_connected')) {
      context.handle(
          _lastConnectedMeta,
          lastConnected.isAcceptableOrUnknown(
              data['last_connected']!, _lastConnectedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {deviceId};
  @override
  RememberedSensorRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RememberedSensorRow(
      deviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      paired: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}paired'])!,
      lastConnected: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_connected']),
    );
  }

  @override
  $RememberedSensorsTable createAlias(String alias) {
    return $RememberedSensorsTable(attachedDatabase, alias);
  }
}

class RememberedSensorRow extends DataClass
    implements Insertable<RememberedSensorRow> {
  final String deviceId;
  final String name;
  final bool paired;
  final DateTime? lastConnected;
  const RememberedSensorRow(
      {required this.deviceId,
      required this.name,
      required this.paired,
      this.lastConnected});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['device_id'] = Variable<String>(deviceId);
    map['name'] = Variable<String>(name);
    map['paired'] = Variable<bool>(paired);
    if (!nullToAbsent || lastConnected != null) {
      map['last_connected'] = Variable<DateTime>(lastConnected);
    }
    return map;
  }

  RememberedSensorsCompanion toCompanion(bool nullToAbsent) {
    return RememberedSensorsCompanion(
      deviceId: Value(deviceId),
      name: Value(name),
      paired: Value(paired),
      lastConnected: lastConnected == null && nullToAbsent
          ? const Value.absent()
          : Value(lastConnected),
    );
  }

  factory RememberedSensorRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RememberedSensorRow(
      deviceId: serializer.fromJson<String>(json['deviceId']),
      name: serializer.fromJson<String>(json['name']),
      paired: serializer.fromJson<bool>(json['paired']),
      lastConnected: serializer.fromJson<DateTime?>(json['lastConnected']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'deviceId': serializer.toJson<String>(deviceId),
      'name': serializer.toJson<String>(name),
      'paired': serializer.toJson<bool>(paired),
      'lastConnected': serializer.toJson<DateTime?>(lastConnected),
    };
  }

  RememberedSensorRow copyWith(
          {String? deviceId,
          String? name,
          bool? paired,
          Value<DateTime?> lastConnected = const Value.absent()}) =>
      RememberedSensorRow(
        deviceId: deviceId ?? this.deviceId,
        name: name ?? this.name,
        paired: paired ?? this.paired,
        lastConnected:
            lastConnected.present ? lastConnected.value : this.lastConnected,
      );
  RememberedSensorRow copyWithCompanion(RememberedSensorsCompanion data) {
    return RememberedSensorRow(
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      name: data.name.present ? data.name.value : this.name,
      paired: data.paired.present ? data.paired.value : this.paired,
      lastConnected: data.lastConnected.present
          ? data.lastConnected.value
          : this.lastConnected,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RememberedSensorRow(')
          ..write('deviceId: $deviceId, ')
          ..write('name: $name, ')
          ..write('paired: $paired, ')
          ..write('lastConnected: $lastConnected')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(deviceId, name, paired, lastConnected);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RememberedSensorRow &&
          other.deviceId == this.deviceId &&
          other.name == this.name &&
          other.paired == this.paired &&
          other.lastConnected == this.lastConnected);
}

class RememberedSensorsCompanion extends UpdateCompanion<RememberedSensorRow> {
  final Value<String> deviceId;
  final Value<String> name;
  final Value<bool> paired;
  final Value<DateTime?> lastConnected;
  final Value<int> rowid;
  const RememberedSensorsCompanion({
    this.deviceId = const Value.absent(),
    this.name = const Value.absent(),
    this.paired = const Value.absent(),
    this.lastConnected = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RememberedSensorsCompanion.insert({
    required String deviceId,
    required String name,
    this.paired = const Value.absent(),
    this.lastConnected = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : deviceId = Value(deviceId),
        name = Value(name);
  static Insertable<RememberedSensorRow> custom({
    Expression<String>? deviceId,
    Expression<String>? name,
    Expression<bool>? paired,
    Expression<DateTime>? lastConnected,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (deviceId != null) 'device_id': deviceId,
      if (name != null) 'name': name,
      if (paired != null) 'paired': paired,
      if (lastConnected != null) 'last_connected': lastConnected,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RememberedSensorsCompanion copyWith(
      {Value<String>? deviceId,
      Value<String>? name,
      Value<bool>? paired,
      Value<DateTime?>? lastConnected,
      Value<int>? rowid}) {
    return RememberedSensorsCompanion(
      deviceId: deviceId ?? this.deviceId,
      name: name ?? this.name,
      paired: paired ?? this.paired,
      lastConnected: lastConnected ?? this.lastConnected,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (paired.present) {
      map['paired'] = Variable<bool>(paired.value);
    }
    if (lastConnected.present) {
      map['last_connected'] = Variable<DateTime>(lastConnected.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RememberedSensorsCompanion(')
          ..write('deviceId: $deviceId, ')
          ..write('name: $name, ')
          ..write('paired: $paired, ')
          ..write('lastConnected: $lastConnected, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GuidanceCacheTable extends GuidanceCache
    with TableInfo<$GuidanceCacheTable, GuidanceCacheRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GuidanceCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _generatedAtMeta =
      const VerificationMeta('generatedAt');
  @override
  late final GeneratedColumn<DateTime> generatedAt = GeneratedColumn<DateTime>(
      'generated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _contextFingerprintMeta =
      const VerificationMeta('contextFingerprint');
  @override
  late final GeneratedColumn<String> contextFingerprint =
      GeneratedColumn<String>('context_fingerprint', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contentJsonMeta =
      const VerificationMeta('contentJson');
  @override
  late final GeneratedColumn<String> contentJson = GeneratedColumn<String>(
      'content_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
      'source', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, generatedAt, contextFingerprint, contentJson, source];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'guidance_cache';
  @override
  VerificationContext validateIntegrity(Insertable<GuidanceCacheRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('generated_at')) {
      context.handle(
          _generatedAtMeta,
          generatedAt.isAcceptableOrUnknown(
              data['generated_at']!, _generatedAtMeta));
    } else if (isInserting) {
      context.missing(_generatedAtMeta);
    }
    if (data.containsKey('context_fingerprint')) {
      context.handle(
          _contextFingerprintMeta,
          contextFingerprint.isAcceptableOrUnknown(
              data['context_fingerprint']!, _contextFingerprintMeta));
    } else if (isInserting) {
      context.missing(_contextFingerprintMeta);
    }
    if (data.containsKey('content_json')) {
      context.handle(
          _contentJsonMeta,
          contentJson.isAcceptableOrUnknown(
              data['content_json']!, _contentJsonMeta));
    } else if (isInserting) {
      context.missing(_contentJsonMeta);
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta,
          source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GuidanceCacheRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GuidanceCacheRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      generatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}generated_at'])!,
      contextFingerprint: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}context_fingerprint'])!,
      contentJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content_json'])!,
      source: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source'])!,
    );
  }

  @override
  $GuidanceCacheTable createAlias(String alias) {
    return $GuidanceCacheTable(attachedDatabase, alias);
  }
}

class GuidanceCacheRow extends DataClass
    implements Insertable<GuidanceCacheRow> {
  final int id;
  final DateTime generatedAt;
  final String contextFingerprint;
  final String contentJson;
  final String source;
  const GuidanceCacheRow(
      {required this.id,
      required this.generatedAt,
      required this.contextFingerprint,
      required this.contentJson,
      required this.source});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['generated_at'] = Variable<DateTime>(generatedAt);
    map['context_fingerprint'] = Variable<String>(contextFingerprint);
    map['content_json'] = Variable<String>(contentJson);
    map['source'] = Variable<String>(source);
    return map;
  }

  GuidanceCacheCompanion toCompanion(bool nullToAbsent) {
    return GuidanceCacheCompanion(
      id: Value(id),
      generatedAt: Value(generatedAt),
      contextFingerprint: Value(contextFingerprint),
      contentJson: Value(contentJson),
      source: Value(source),
    );
  }

  factory GuidanceCacheRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GuidanceCacheRow(
      id: serializer.fromJson<int>(json['id']),
      generatedAt: serializer.fromJson<DateTime>(json['generatedAt']),
      contextFingerprint:
          serializer.fromJson<String>(json['contextFingerprint']),
      contentJson: serializer.fromJson<String>(json['contentJson']),
      source: serializer.fromJson<String>(json['source']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'generatedAt': serializer.toJson<DateTime>(generatedAt),
      'contextFingerprint': serializer.toJson<String>(contextFingerprint),
      'contentJson': serializer.toJson<String>(contentJson),
      'source': serializer.toJson<String>(source),
    };
  }

  GuidanceCacheRow copyWith(
          {int? id,
          DateTime? generatedAt,
          String? contextFingerprint,
          String? contentJson,
          String? source}) =>
      GuidanceCacheRow(
        id: id ?? this.id,
        generatedAt: generatedAt ?? this.generatedAt,
        contextFingerprint: contextFingerprint ?? this.contextFingerprint,
        contentJson: contentJson ?? this.contentJson,
        source: source ?? this.source,
      );
  GuidanceCacheRow copyWithCompanion(GuidanceCacheCompanion data) {
    return GuidanceCacheRow(
      id: data.id.present ? data.id.value : this.id,
      generatedAt:
          data.generatedAt.present ? data.generatedAt.value : this.generatedAt,
      contextFingerprint: data.contextFingerprint.present
          ? data.contextFingerprint.value
          : this.contextFingerprint,
      contentJson:
          data.contentJson.present ? data.contentJson.value : this.contentJson,
      source: data.source.present ? data.source.value : this.source,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GuidanceCacheRow(')
          ..write('id: $id, ')
          ..write('generatedAt: $generatedAt, ')
          ..write('contextFingerprint: $contextFingerprint, ')
          ..write('contentJson: $contentJson, ')
          ..write('source: $source')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, generatedAt, contextFingerprint, contentJson, source);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GuidanceCacheRow &&
          other.id == this.id &&
          other.generatedAt == this.generatedAt &&
          other.contextFingerprint == this.contextFingerprint &&
          other.contentJson == this.contentJson &&
          other.source == this.source);
}

class GuidanceCacheCompanion extends UpdateCompanion<GuidanceCacheRow> {
  final Value<int> id;
  final Value<DateTime> generatedAt;
  final Value<String> contextFingerprint;
  final Value<String> contentJson;
  final Value<String> source;
  const GuidanceCacheCompanion({
    this.id = const Value.absent(),
    this.generatedAt = const Value.absent(),
    this.contextFingerprint = const Value.absent(),
    this.contentJson = const Value.absent(),
    this.source = const Value.absent(),
  });
  GuidanceCacheCompanion.insert({
    this.id = const Value.absent(),
    required DateTime generatedAt,
    required String contextFingerprint,
    required String contentJson,
    required String source,
  })  : generatedAt = Value(generatedAt),
        contextFingerprint = Value(contextFingerprint),
        contentJson = Value(contentJson),
        source = Value(source);
  static Insertable<GuidanceCacheRow> custom({
    Expression<int>? id,
    Expression<DateTime>? generatedAt,
    Expression<String>? contextFingerprint,
    Expression<String>? contentJson,
    Expression<String>? source,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (generatedAt != null) 'generated_at': generatedAt,
      if (contextFingerprint != null) 'context_fingerprint': contextFingerprint,
      if (contentJson != null) 'content_json': contentJson,
      if (source != null) 'source': source,
    });
  }

  GuidanceCacheCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? generatedAt,
      Value<String>? contextFingerprint,
      Value<String>? contentJson,
      Value<String>? source}) {
    return GuidanceCacheCompanion(
      id: id ?? this.id,
      generatedAt: generatedAt ?? this.generatedAt,
      contextFingerprint: contextFingerprint ?? this.contextFingerprint,
      contentJson: contentJson ?? this.contentJson,
      source: source ?? this.source,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (generatedAt.present) {
      map['generated_at'] = Variable<DateTime>(generatedAt.value);
    }
    if (contextFingerprint.present) {
      map['context_fingerprint'] = Variable<String>(contextFingerprint.value);
    }
    if (contentJson.present) {
      map['content_json'] = Variable<String>(contentJson.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GuidanceCacheCompanion(')
          ..write('id: $id, ')
          ..write('generatedAt: $generatedAt, ')
          ..write('contextFingerprint: $contextFingerprint, ')
          ..write('contentJson: $contentJson, ')
          ..write('source: $source')
          ..write(')'))
        .toString();
  }
}

class $LifestyleEntriesTable extends LifestyleEntries
    with TableInfo<$LifestyleEntriesTable, LifestyleEntryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LifestyleEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _recordedAtMeta =
      const VerificationMeta('recordedAt');
  @override
  late final GeneratedColumn<DateTime> recordedAt = GeneratedColumn<DateTime>(
      'recorded_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
      'kind', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
      'value', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _durationMinutesMeta =
      const VerificationMeta('durationMinutes');
  @override
  late final GeneratedColumn<double> durationMinutes = GeneratedColumn<double>(
      'duration_minutes', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
      'source', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('self-report'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, recordedAt, kind, value, durationMinutes, note, source];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lifestyle_entries';
  @override
  VerificationContext validateIntegrity(Insertable<LifestyleEntryRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
          _recordedAtMeta,
          recordedAt.isAcceptableOrUnknown(
              data['recorded_at']!, _recordedAtMeta));
    } else if (isInserting) {
      context.missing(_recordedAtMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
          _kindMeta, kind.isAcceptableOrUnknown(data['kind']!, _kindMeta));
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    }
    if (data.containsKey('duration_minutes')) {
      context.handle(
          _durationMinutesMeta,
          durationMinutes.isAcceptableOrUnknown(
              data['duration_minutes']!, _durationMinutesMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta,
          source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LifestyleEntryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LifestyleEntryRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      recordedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}recorded_at'])!,
      kind: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}kind'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}value']),
      durationMinutes: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}duration_minutes']),
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      source: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source'])!,
    );
  }

  @override
  $LifestyleEntriesTable createAlias(String alias) {
    return $LifestyleEntriesTable(attachedDatabase, alias);
  }
}

class LifestyleEntryRow extends DataClass
    implements Insertable<LifestyleEntryRow> {
  final int id;
  final DateTime recordedAt;
  final String kind;
  final double? value;
  final double? durationMinutes;
  final String? note;
  final String source;
  const LifestyleEntryRow(
      {required this.id,
      required this.recordedAt,
      required this.kind,
      this.value,
      this.durationMinutes,
      this.note,
      required this.source});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['recorded_at'] = Variable<DateTime>(recordedAt);
    map['kind'] = Variable<String>(kind);
    if (!nullToAbsent || value != null) {
      map['value'] = Variable<double>(value);
    }
    if (!nullToAbsent || durationMinutes != null) {
      map['duration_minutes'] = Variable<double>(durationMinutes);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['source'] = Variable<String>(source);
    return map;
  }

  LifestyleEntriesCompanion toCompanion(bool nullToAbsent) {
    return LifestyleEntriesCompanion(
      id: Value(id),
      recordedAt: Value(recordedAt),
      kind: Value(kind),
      value:
          value == null && nullToAbsent ? const Value.absent() : Value(value),
      durationMinutes: durationMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(durationMinutes),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      source: Value(source),
    );
  }

  factory LifestyleEntryRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LifestyleEntryRow(
      id: serializer.fromJson<int>(json['id']),
      recordedAt: serializer.fromJson<DateTime>(json['recordedAt']),
      kind: serializer.fromJson<String>(json['kind']),
      value: serializer.fromJson<double?>(json['value']),
      durationMinutes: serializer.fromJson<double?>(json['durationMinutes']),
      note: serializer.fromJson<String?>(json['note']),
      source: serializer.fromJson<String>(json['source']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'recordedAt': serializer.toJson<DateTime>(recordedAt),
      'kind': serializer.toJson<String>(kind),
      'value': serializer.toJson<double?>(value),
      'durationMinutes': serializer.toJson<double?>(durationMinutes),
      'note': serializer.toJson<String?>(note),
      'source': serializer.toJson<String>(source),
    };
  }

  LifestyleEntryRow copyWith(
          {int? id,
          DateTime? recordedAt,
          String? kind,
          Value<double?> value = const Value.absent(),
          Value<double?> durationMinutes = const Value.absent(),
          Value<String?> note = const Value.absent(),
          String? source}) =>
      LifestyleEntryRow(
        id: id ?? this.id,
        recordedAt: recordedAt ?? this.recordedAt,
        kind: kind ?? this.kind,
        value: value.present ? value.value : this.value,
        durationMinutes: durationMinutes.present
            ? durationMinutes.value
            : this.durationMinutes,
        note: note.present ? note.value : this.note,
        source: source ?? this.source,
      );
  LifestyleEntryRow copyWithCompanion(LifestyleEntriesCompanion data) {
    return LifestyleEntryRow(
      id: data.id.present ? data.id.value : this.id,
      recordedAt:
          data.recordedAt.present ? data.recordedAt.value : this.recordedAt,
      kind: data.kind.present ? data.kind.value : this.kind,
      value: data.value.present ? data.value.value : this.value,
      durationMinutes: data.durationMinutes.present
          ? data.durationMinutes.value
          : this.durationMinutes,
      note: data.note.present ? data.note.value : this.note,
      source: data.source.present ? data.source.value : this.source,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LifestyleEntryRow(')
          ..write('id: $id, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('kind: $kind, ')
          ..write('value: $value, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('note: $note, ')
          ..write('source: $source')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, recordedAt, kind, value, durationMinutes, note, source);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LifestyleEntryRow &&
          other.id == this.id &&
          other.recordedAt == this.recordedAt &&
          other.kind == this.kind &&
          other.value == this.value &&
          other.durationMinutes == this.durationMinutes &&
          other.note == this.note &&
          other.source == this.source);
}

class LifestyleEntriesCompanion extends UpdateCompanion<LifestyleEntryRow> {
  final Value<int> id;
  final Value<DateTime> recordedAt;
  final Value<String> kind;
  final Value<double?> value;
  final Value<double?> durationMinutes;
  final Value<String?> note;
  final Value<String> source;
  const LifestyleEntriesCompanion({
    this.id = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.kind = const Value.absent(),
    this.value = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.note = const Value.absent(),
    this.source = const Value.absent(),
  });
  LifestyleEntriesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime recordedAt,
    required String kind,
    this.value = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.note = const Value.absent(),
    this.source = const Value.absent(),
  })  : recordedAt = Value(recordedAt),
        kind = Value(kind);
  static Insertable<LifestyleEntryRow> custom({
    Expression<int>? id,
    Expression<DateTime>? recordedAt,
    Expression<String>? kind,
    Expression<double>? value,
    Expression<double>? durationMinutes,
    Expression<String>? note,
    Expression<String>? source,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (kind != null) 'kind': kind,
      if (value != null) 'value': value,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (note != null) 'note': note,
      if (source != null) 'source': source,
    });
  }

  LifestyleEntriesCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? recordedAt,
      Value<String>? kind,
      Value<double?>? value,
      Value<double?>? durationMinutes,
      Value<String?>? note,
      Value<String>? source}) {
    return LifestyleEntriesCompanion(
      id: id ?? this.id,
      recordedAt: recordedAt ?? this.recordedAt,
      kind: kind ?? this.kind,
      value: value ?? this.value,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      note: note ?? this.note,
      source: source ?? this.source,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<DateTime>(recordedAt.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (durationMinutes.present) {
      map['duration_minutes'] = Variable<double>(durationMinutes.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LifestyleEntriesCompanion(')
          ..write('id: $id, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('kind: $kind, ')
          ..write('value: $value, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('note: $note, ')
          ..write('source: $source')
          ..write(')'))
        .toString();
  }
}

class $PatternCandidatesTable extends PatternCandidates
    with TableInfo<$PatternCandidatesTable, PatternCandidateRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PatternCandidatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _computedAtMeta =
      const VerificationMeta('computedAt');
  @override
  late final GeneratedColumn<DateTime> computedAt = GeneratedColumn<DateTime>(
      'computed_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _summaryMeta =
      const VerificationMeta('summary');
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
      'summary', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _evidenceJsonMeta =
      const VerificationMeta('evidenceJson');
  @override
  late final GeneratedColumn<String> evidenceJson = GeneratedColumn<String>(
      'evidence_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _confidenceMeta =
      const VerificationMeta('confidence');
  @override
  late final GeneratedColumn<double> confidence = GeneratedColumn<double>(
      'confidence', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('active'));
  @override
  List<GeneratedColumn> get $columns =>
      [key, computedAt, summary, evidenceJson, confidence, status];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pattern_candidates';
  @override
  VerificationContext validateIntegrity(
      Insertable<PatternCandidateRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('computed_at')) {
      context.handle(
          _computedAtMeta,
          computedAt.isAcceptableOrUnknown(
              data['computed_at']!, _computedAtMeta));
    } else if (isInserting) {
      context.missing(_computedAtMeta);
    }
    if (data.containsKey('summary')) {
      context.handle(_summaryMeta,
          summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta));
    } else if (isInserting) {
      context.missing(_summaryMeta);
    }
    if (data.containsKey('evidence_json')) {
      context.handle(
          _evidenceJsonMeta,
          evidenceJson.isAcceptableOrUnknown(
              data['evidence_json']!, _evidenceJsonMeta));
    } else if (isInserting) {
      context.missing(_evidenceJsonMeta);
    }
    if (data.containsKey('confidence')) {
      context.handle(
          _confidenceMeta,
          confidence.isAcceptableOrUnknown(
              data['confidence']!, _confidenceMeta));
    } else if (isInserting) {
      context.missing(_confidenceMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  PatternCandidateRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PatternCandidateRow(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      computedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}computed_at'])!,
      summary: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}summary'])!,
      evidenceJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}evidence_json'])!,
      confidence: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}confidence'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
    );
  }

  @override
  $PatternCandidatesTable createAlias(String alias) {
    return $PatternCandidatesTable(attachedDatabase, alias);
  }
}

class PatternCandidateRow extends DataClass
    implements Insertable<PatternCandidateRow> {
  final String key;
  final DateTime computedAt;
  final String summary;
  final String evidenceJson;
  final double confidence;
  final String status;
  const PatternCandidateRow(
      {required this.key,
      required this.computedAt,
      required this.summary,
      required this.evidenceJson,
      required this.confidence,
      required this.status});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['computed_at'] = Variable<DateTime>(computedAt);
    map['summary'] = Variable<String>(summary);
    map['evidence_json'] = Variable<String>(evidenceJson);
    map['confidence'] = Variable<double>(confidence);
    map['status'] = Variable<String>(status);
    return map;
  }

  PatternCandidatesCompanion toCompanion(bool nullToAbsent) {
    return PatternCandidatesCompanion(
      key: Value(key),
      computedAt: Value(computedAt),
      summary: Value(summary),
      evidenceJson: Value(evidenceJson),
      confidence: Value(confidence),
      status: Value(status),
    );
  }

  factory PatternCandidateRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PatternCandidateRow(
      key: serializer.fromJson<String>(json['key']),
      computedAt: serializer.fromJson<DateTime>(json['computedAt']),
      summary: serializer.fromJson<String>(json['summary']),
      evidenceJson: serializer.fromJson<String>(json['evidenceJson']),
      confidence: serializer.fromJson<double>(json['confidence']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'computedAt': serializer.toJson<DateTime>(computedAt),
      'summary': serializer.toJson<String>(summary),
      'evidenceJson': serializer.toJson<String>(evidenceJson),
      'confidence': serializer.toJson<double>(confidence),
      'status': serializer.toJson<String>(status),
    };
  }

  PatternCandidateRow copyWith(
          {String? key,
          DateTime? computedAt,
          String? summary,
          String? evidenceJson,
          double? confidence,
          String? status}) =>
      PatternCandidateRow(
        key: key ?? this.key,
        computedAt: computedAt ?? this.computedAt,
        summary: summary ?? this.summary,
        evidenceJson: evidenceJson ?? this.evidenceJson,
        confidence: confidence ?? this.confidence,
        status: status ?? this.status,
      );
  PatternCandidateRow copyWithCompanion(PatternCandidatesCompanion data) {
    return PatternCandidateRow(
      key: data.key.present ? data.key.value : this.key,
      computedAt:
          data.computedAt.present ? data.computedAt.value : this.computedAt,
      summary: data.summary.present ? data.summary.value : this.summary,
      evidenceJson: data.evidenceJson.present
          ? data.evidenceJson.value
          : this.evidenceJson,
      confidence:
          data.confidence.present ? data.confidence.value : this.confidence,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PatternCandidateRow(')
          ..write('key: $key, ')
          ..write('computedAt: $computedAt, ')
          ..write('summary: $summary, ')
          ..write('evidenceJson: $evidenceJson, ')
          ..write('confidence: $confidence, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(key, computedAt, summary, evidenceJson, confidence, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PatternCandidateRow &&
          other.key == this.key &&
          other.computedAt == this.computedAt &&
          other.summary == this.summary &&
          other.evidenceJson == this.evidenceJson &&
          other.confidence == this.confidence &&
          other.status == this.status);
}

class PatternCandidatesCompanion extends UpdateCompanion<PatternCandidateRow> {
  final Value<String> key;
  final Value<DateTime> computedAt;
  final Value<String> summary;
  final Value<String> evidenceJson;
  final Value<double> confidence;
  final Value<String> status;
  final Value<int> rowid;
  const PatternCandidatesCompanion({
    this.key = const Value.absent(),
    this.computedAt = const Value.absent(),
    this.summary = const Value.absent(),
    this.evidenceJson = const Value.absent(),
    this.confidence = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PatternCandidatesCompanion.insert({
    required String key,
    required DateTime computedAt,
    required String summary,
    required String evidenceJson,
    required double confidence,
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : key = Value(key),
        computedAt = Value(computedAt),
        summary = Value(summary),
        evidenceJson = Value(evidenceJson),
        confidence = Value(confidence);
  static Insertable<PatternCandidateRow> custom({
    Expression<String>? key,
    Expression<DateTime>? computedAt,
    Expression<String>? summary,
    Expression<String>? evidenceJson,
    Expression<double>? confidence,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (computedAt != null) 'computed_at': computedAt,
      if (summary != null) 'summary': summary,
      if (evidenceJson != null) 'evidence_json': evidenceJson,
      if (confidence != null) 'confidence': confidence,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PatternCandidatesCompanion copyWith(
      {Value<String>? key,
      Value<DateTime>? computedAt,
      Value<String>? summary,
      Value<String>? evidenceJson,
      Value<double>? confidence,
      Value<String>? status,
      Value<int>? rowid}) {
    return PatternCandidatesCompanion(
      key: key ?? this.key,
      computedAt: computedAt ?? this.computedAt,
      summary: summary ?? this.summary,
      evidenceJson: evidenceJson ?? this.evidenceJson,
      confidence: confidence ?? this.confidence,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (computedAt.present) {
      map['computed_at'] = Variable<DateTime>(computedAt.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (evidenceJson.present) {
      map['evidence_json'] = Variable<String>(evidenceJson.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<double>(confidence.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PatternCandidatesCompanion(')
          ..write('key: $key, ')
          ..write('computedAt: $computedAt, ')
          ..write('summary: $summary, ')
          ..write('evidenceJson: $evidenceJson, ')
          ..write('confidence: $confidence, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $JournalEntriesTable extends JournalEntries
    with TableInfo<$JournalEntriesTable, JournalEntryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JournalEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _entryTextMeta =
      const VerificationMeta('entryText');
  @override
  late final GeneratedColumn<String> entryText = GeneratedColumn<String>(
      'text', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
      'source', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('typed'));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _extractionJsonMeta =
      const VerificationMeta('extractionJson');
  @override
  late final GeneratedColumn<String> extractionJson = GeneratedColumn<String>(
      'extraction_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _modelMeta = const VerificationMeta('model');
  @override
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
      'model', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _appliedAtMeta =
      const VerificationMeta('appliedAt');
  @override
  late final GeneratedColumn<DateTime> appliedAt = GeneratedColumn<DateTime>(
      'applied_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        createdAt,
        entryText,
        source,
        status,
        extractionJson,
        model,
        appliedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'journal_entries';
  @override
  VerificationContext validateIntegrity(Insertable<JournalEntryRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('text')) {
      context.handle(_entryTextMeta,
          entryText.isAcceptableOrUnknown(data['text']!, _entryTextMeta));
    } else if (isInserting) {
      context.missing(_entryTextMeta);
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta,
          source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('extraction_json')) {
      context.handle(
          _extractionJsonMeta,
          extractionJson.isAcceptableOrUnknown(
              data['extraction_json']!, _extractionJsonMeta));
    }
    if (data.containsKey('model')) {
      context.handle(
          _modelMeta, model.isAcceptableOrUnknown(data['model']!, _modelMeta));
    }
    if (data.containsKey('applied_at')) {
      context.handle(_appliedAtMeta,
          appliedAt.isAcceptableOrUnknown(data['applied_at']!, _appliedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  JournalEntryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JournalEntryRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      entryText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}text'])!,
      source: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      extractionJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}extraction_json']),
      model: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}model']),
      appliedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}applied_at']),
    );
  }

  @override
  $JournalEntriesTable createAlias(String alias) {
    return $JournalEntriesTable(attachedDatabase, alias);
  }
}

class JournalEntryRow extends DataClass implements Insertable<JournalEntryRow> {
  final int id;
  final DateTime createdAt;
  final String entryText;

  /// `typed` or `spoken`. Spoken entries came through on-device speech
  /// recognition, so they carry transcription error the user may want to fix.
  final String source;

  /// `pending` — written but not yet classified (offline, or queued).
  /// `classified` — extraction applied to the other tables.
  /// `needsDetail` — classified, but something (strength sets) wants the user.
  /// `failed` — extraction rejected; the prose is still safe.
  final String status;
  final String? extractionJson;
  final String? model;

  /// Set once the derived rows have been written, so a retry cannot double-log
  /// the same meal into `NutritionEntries`.
  final DateTime? appliedAt;
  const JournalEntryRow(
      {required this.id,
      required this.createdAt,
      required this.entryText,
      required this.source,
      required this.status,
      this.extractionJson,
      this.model,
      this.appliedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['text'] = Variable<String>(entryText);
    map['source'] = Variable<String>(source);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || extractionJson != null) {
      map['extraction_json'] = Variable<String>(extractionJson);
    }
    if (!nullToAbsent || model != null) {
      map['model'] = Variable<String>(model);
    }
    if (!nullToAbsent || appliedAt != null) {
      map['applied_at'] = Variable<DateTime>(appliedAt);
    }
    return map;
  }

  JournalEntriesCompanion toCompanion(bool nullToAbsent) {
    return JournalEntriesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      entryText: Value(entryText),
      source: Value(source),
      status: Value(status),
      extractionJson: extractionJson == null && nullToAbsent
          ? const Value.absent()
          : Value(extractionJson),
      model:
          model == null && nullToAbsent ? const Value.absent() : Value(model),
      appliedAt: appliedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(appliedAt),
    );
  }

  factory JournalEntryRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JournalEntryRow(
      id: serializer.fromJson<int>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      entryText: serializer.fromJson<String>(json['entryText']),
      source: serializer.fromJson<String>(json['source']),
      status: serializer.fromJson<String>(json['status']),
      extractionJson: serializer.fromJson<String?>(json['extractionJson']),
      model: serializer.fromJson<String?>(json['model']),
      appliedAt: serializer.fromJson<DateTime?>(json['appliedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'entryText': serializer.toJson<String>(entryText),
      'source': serializer.toJson<String>(source),
      'status': serializer.toJson<String>(status),
      'extractionJson': serializer.toJson<String?>(extractionJson),
      'model': serializer.toJson<String?>(model),
      'appliedAt': serializer.toJson<DateTime?>(appliedAt),
    };
  }

  JournalEntryRow copyWith(
          {int? id,
          DateTime? createdAt,
          String? entryText,
          String? source,
          String? status,
          Value<String?> extractionJson = const Value.absent(),
          Value<String?> model = const Value.absent(),
          Value<DateTime?> appliedAt = const Value.absent()}) =>
      JournalEntryRow(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        entryText: entryText ?? this.entryText,
        source: source ?? this.source,
        status: status ?? this.status,
        extractionJson:
            extractionJson.present ? extractionJson.value : this.extractionJson,
        model: model.present ? model.value : this.model,
        appliedAt: appliedAt.present ? appliedAt.value : this.appliedAt,
      );
  JournalEntryRow copyWithCompanion(JournalEntriesCompanion data) {
    return JournalEntryRow(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      entryText: data.entryText.present ? data.entryText.value : this.entryText,
      source: data.source.present ? data.source.value : this.source,
      status: data.status.present ? data.status.value : this.status,
      extractionJson: data.extractionJson.present
          ? data.extractionJson.value
          : this.extractionJson,
      model: data.model.present ? data.model.value : this.model,
      appliedAt: data.appliedAt.present ? data.appliedAt.value : this.appliedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JournalEntryRow(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('entryText: $entryText, ')
          ..write('source: $source, ')
          ..write('status: $status, ')
          ..write('extractionJson: $extractionJson, ')
          ..write('model: $model, ')
          ..write('appliedAt: $appliedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, createdAt, entryText, source, status,
      extractionJson, model, appliedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JournalEntryRow &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.entryText == this.entryText &&
          other.source == this.source &&
          other.status == this.status &&
          other.extractionJson == this.extractionJson &&
          other.model == this.model &&
          other.appliedAt == this.appliedAt);
}

class JournalEntriesCompanion extends UpdateCompanion<JournalEntryRow> {
  final Value<int> id;
  final Value<DateTime> createdAt;
  final Value<String> entryText;
  final Value<String> source;
  final Value<String> status;
  final Value<String?> extractionJson;
  final Value<String?> model;
  final Value<DateTime?> appliedAt;
  const JournalEntriesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.entryText = const Value.absent(),
    this.source = const Value.absent(),
    this.status = const Value.absent(),
    this.extractionJson = const Value.absent(),
    this.model = const Value.absent(),
    this.appliedAt = const Value.absent(),
  });
  JournalEntriesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime createdAt,
    required String entryText,
    this.source = const Value.absent(),
    this.status = const Value.absent(),
    this.extractionJson = const Value.absent(),
    this.model = const Value.absent(),
    this.appliedAt = const Value.absent(),
  })  : createdAt = Value(createdAt),
        entryText = Value(entryText);
  static Insertable<JournalEntryRow> custom({
    Expression<int>? id,
    Expression<DateTime>? createdAt,
    Expression<String>? entryText,
    Expression<String>? source,
    Expression<String>? status,
    Expression<String>? extractionJson,
    Expression<String>? model,
    Expression<DateTime>? appliedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (entryText != null) 'text': entryText,
      if (source != null) 'source': source,
      if (status != null) 'status': status,
      if (extractionJson != null) 'extraction_json': extractionJson,
      if (model != null) 'model': model,
      if (appliedAt != null) 'applied_at': appliedAt,
    });
  }

  JournalEntriesCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? createdAt,
      Value<String>? entryText,
      Value<String>? source,
      Value<String>? status,
      Value<String?>? extractionJson,
      Value<String?>? model,
      Value<DateTime?>? appliedAt}) {
    return JournalEntriesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      entryText: entryText ?? this.entryText,
      source: source ?? this.source,
      status: status ?? this.status,
      extractionJson: extractionJson ?? this.extractionJson,
      model: model ?? this.model,
      appliedAt: appliedAt ?? this.appliedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (entryText.present) {
      map['text'] = Variable<String>(entryText.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (extractionJson.present) {
      map['extraction_json'] = Variable<String>(extractionJson.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (appliedAt.present) {
      map['applied_at'] = Variable<DateTime>(appliedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JournalEntriesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('entryText: $entryText, ')
          ..write('source: $source, ')
          ..write('status: $status, ')
          ..write('extractionJson: $extractionJson, ')
          ..write('model: $model, ')
          ..write('appliedAt: $appliedAt')
          ..write(')'))
        .toString();
  }
}

class $VesselReadingsTable extends VesselReadings
    with TableInfo<$VesselReadingsTable, VesselReadingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VesselReadingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _inputHashMeta =
      const VerificationMeta('inputHash');
  @override
  late final GeneratedColumn<String> inputHash = GeneratedColumn<String>(
      'input_hash', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _contentJsonMeta =
      const VerificationMeta('contentJson');
  @override
  late final GeneratedColumn<String> contentJson = GeneratedColumn<String>(
      'content_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _modelMeta = const VerificationMeta('model');
  @override
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
      'model', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [inputHash, createdAt, contentJson, model];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vessel_readings';
  @override
  VerificationContext validateIntegrity(Insertable<VesselReadingRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('input_hash')) {
      context.handle(_inputHashMeta,
          inputHash.isAcceptableOrUnknown(data['input_hash']!, _inputHashMeta));
    } else if (isInserting) {
      context.missing(_inputHashMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('content_json')) {
      context.handle(
          _contentJsonMeta,
          contentJson.isAcceptableOrUnknown(
              data['content_json']!, _contentJsonMeta));
    } else if (isInserting) {
      context.missing(_contentJsonMeta);
    }
    if (data.containsKey('model')) {
      context.handle(
          _modelMeta, model.isAcceptableOrUnknown(data['model']!, _modelMeta));
    } else if (isInserting) {
      context.missing(_modelMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {inputHash};
  @override
  VesselReadingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VesselReadingRow(
      inputHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}input_hash'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      contentJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content_json'])!,
      model: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}model'])!,
    );
  }

  @override
  $VesselReadingsTable createAlias(String alias) {
    return $VesselReadingsTable(attachedDatabase, alias);
  }
}

class VesselReadingRow extends DataClass
    implements Insertable<VesselReadingRow> {
  final String inputHash;
  final DateTime createdAt;
  final String contentJson;
  final String model;
  const VesselReadingRow(
      {required this.inputHash,
      required this.createdAt,
      required this.contentJson,
      required this.model});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['input_hash'] = Variable<String>(inputHash);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['content_json'] = Variable<String>(contentJson);
    map['model'] = Variable<String>(model);
    return map;
  }

  VesselReadingsCompanion toCompanion(bool nullToAbsent) {
    return VesselReadingsCompanion(
      inputHash: Value(inputHash),
      createdAt: Value(createdAt),
      contentJson: Value(contentJson),
      model: Value(model),
    );
  }

  factory VesselReadingRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VesselReadingRow(
      inputHash: serializer.fromJson<String>(json['inputHash']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      contentJson: serializer.fromJson<String>(json['contentJson']),
      model: serializer.fromJson<String>(json['model']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'inputHash': serializer.toJson<String>(inputHash),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'contentJson': serializer.toJson<String>(contentJson),
      'model': serializer.toJson<String>(model),
    };
  }

  VesselReadingRow copyWith(
          {String? inputHash,
          DateTime? createdAt,
          String? contentJson,
          String? model}) =>
      VesselReadingRow(
        inputHash: inputHash ?? this.inputHash,
        createdAt: createdAt ?? this.createdAt,
        contentJson: contentJson ?? this.contentJson,
        model: model ?? this.model,
      );
  VesselReadingRow copyWithCompanion(VesselReadingsCompanion data) {
    return VesselReadingRow(
      inputHash: data.inputHash.present ? data.inputHash.value : this.inputHash,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      contentJson:
          data.contentJson.present ? data.contentJson.value : this.contentJson,
      model: data.model.present ? data.model.value : this.model,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VesselReadingRow(')
          ..write('inputHash: $inputHash, ')
          ..write('createdAt: $createdAt, ')
          ..write('contentJson: $contentJson, ')
          ..write('model: $model')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(inputHash, createdAt, contentJson, model);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VesselReadingRow &&
          other.inputHash == this.inputHash &&
          other.createdAt == this.createdAt &&
          other.contentJson == this.contentJson &&
          other.model == this.model);
}

class VesselReadingsCompanion extends UpdateCompanion<VesselReadingRow> {
  final Value<String> inputHash;
  final Value<DateTime> createdAt;
  final Value<String> contentJson;
  final Value<String> model;
  final Value<int> rowid;
  const VesselReadingsCompanion({
    this.inputHash = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.contentJson = const Value.absent(),
    this.model = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VesselReadingsCompanion.insert({
    required String inputHash,
    required DateTime createdAt,
    required String contentJson,
    required String model,
    this.rowid = const Value.absent(),
  })  : inputHash = Value(inputHash),
        createdAt = Value(createdAt),
        contentJson = Value(contentJson),
        model = Value(model);
  static Insertable<VesselReadingRow> custom({
    Expression<String>? inputHash,
    Expression<DateTime>? createdAt,
    Expression<String>? contentJson,
    Expression<String>? model,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (inputHash != null) 'input_hash': inputHash,
      if (createdAt != null) 'created_at': createdAt,
      if (contentJson != null) 'content_json': contentJson,
      if (model != null) 'model': model,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VesselReadingsCompanion copyWith(
      {Value<String>? inputHash,
      Value<DateTime>? createdAt,
      Value<String>? contentJson,
      Value<String>? model,
      Value<int>? rowid}) {
    return VesselReadingsCompanion(
      inputHash: inputHash ?? this.inputHash,
      createdAt: createdAt ?? this.createdAt,
      contentJson: contentJson ?? this.contentJson,
      model: model ?? this.model,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (inputHash.present) {
      map['input_hash'] = Variable<String>(inputHash.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (contentJson.present) {
      map['content_json'] = Variable<String>(contentJson.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VesselReadingsCompanion(')
          ..write('inputHash: $inputHash, ')
          ..write('createdAt: $createdAt, ')
          ..write('contentJson: $contentJson, ')
          ..write('model: $model, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProfilesTable profiles = $ProfilesTable(this);
  late final $DaySummariesTable daySummaries = $DaySummariesTable(this);
  late final $RawBucketsTable rawBuckets = $RawBucketsTable(this);
  late final $MinuteBucketsTable minuteBuckets = $MinuteBucketsTable(this);
  late final $IntegrationsTable integrations = $IntegrationsTable(this);
  late final $StrengthWorkoutsTable strengthWorkouts =
      $StrengthWorkoutsTable(this);
  late final $WeightEntriesTable weightEntries = $WeightEntriesTable(this);
  late final $NutritionEntriesTable nutritionEntries =
      $NutritionEntriesTable(this);
  late final $LiveSessionsTable liveSessions = $LiveSessionsTable(this);
  late final $RememberedSensorsTable rememberedSensors =
      $RememberedSensorsTable(this);
  late final $GuidanceCacheTable guidanceCache = $GuidanceCacheTable(this);
  late final $LifestyleEntriesTable lifestyleEntries =
      $LifestyleEntriesTable(this);
  late final $PatternCandidatesTable patternCandidates =
      $PatternCandidatesTable(this);
  late final $JournalEntriesTable journalEntries = $JournalEntriesTable(this);
  late final $VesselReadingsTable vesselReadings = $VesselReadingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        profiles,
        daySummaries,
        rawBuckets,
        minuteBuckets,
        integrations,
        strengthWorkouts,
        weightEntries,
        nutritionEntries,
        liveSessions,
        rememberedSensors,
        guidanceCache,
        lifestyleEntries,
        patternCandidates,
        journalEntries,
        vesselReadings
      ];
}

typedef $$ProfilesTableCreateCompanionBuilder = ProfilesCompanion Function({
  Value<int> id,
  required DateTime dob,
  required String sex,
  required double weightKg,
  Value<double?> heightCm,
  required String units,
  Value<bool> hapticsEnabled,
  Value<bool> flashEnabled,
  Value<bool> nutritionEnabled,
  Value<String> connectedSourcesJson,
  Value<String?> firstName,
  Value<String> guidanceMode,
  Value<int?> birthTimeMinutes,
  Value<int?> birthUtcOffsetMinutes,
  Value<String?> birthPlace,
  Value<double?> birthLatitude,
  Value<double?> birthLongitude,
});
typedef $$ProfilesTableUpdateCompanionBuilder = ProfilesCompanion Function({
  Value<int> id,
  Value<DateTime> dob,
  Value<String> sex,
  Value<double> weightKg,
  Value<double?> heightCm,
  Value<String> units,
  Value<bool> hapticsEnabled,
  Value<bool> flashEnabled,
  Value<bool> nutritionEnabled,
  Value<String> connectedSourcesJson,
  Value<String?> firstName,
  Value<String> guidanceMode,
  Value<int?> birthTimeMinutes,
  Value<int?> birthUtcOffsetMinutes,
  Value<String?> birthPlace,
  Value<double?> birthLatitude,
  Value<double?> birthLongitude,
});

class $$ProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dob => $composableBuilder(
      column: $table.dob, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sex => $composableBuilder(
      column: $table.sex, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get weightKg => $composableBuilder(
      column: $table.weightKg, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get heightCm => $composableBuilder(
      column: $table.heightCm, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get units => $composableBuilder(
      column: $table.units, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get hapticsEnabled => $composableBuilder(
      column: $table.hapticsEnabled,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get flashEnabled => $composableBuilder(
      column: $table.flashEnabled, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get nutritionEnabled => $composableBuilder(
      column: $table.nutritionEnabled,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get connectedSourcesJson => $composableBuilder(
      column: $table.connectedSourcesJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get firstName => $composableBuilder(
      column: $table.firstName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get guidanceMode => $composableBuilder(
      column: $table.guidanceMode, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get birthTimeMinutes => $composableBuilder(
      column: $table.birthTimeMinutes,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get birthUtcOffsetMinutes => $composableBuilder(
      column: $table.birthUtcOffsetMinutes,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get birthPlace => $composableBuilder(
      column: $table.birthPlace, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get birthLatitude => $composableBuilder(
      column: $table.birthLatitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get birthLongitude => $composableBuilder(
      column: $table.birthLongitude,
      builder: (column) => ColumnFilters(column));
}

class $$ProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dob => $composableBuilder(
      column: $table.dob, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sex => $composableBuilder(
      column: $table.sex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get weightKg => $composableBuilder(
      column: $table.weightKg, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get heightCm => $composableBuilder(
      column: $table.heightCm, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get units => $composableBuilder(
      column: $table.units, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get hapticsEnabled => $composableBuilder(
      column: $table.hapticsEnabled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get flashEnabled => $composableBuilder(
      column: $table.flashEnabled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get nutritionEnabled => $composableBuilder(
      column: $table.nutritionEnabled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get connectedSourcesJson => $composableBuilder(
      column: $table.connectedSourcesJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get firstName => $composableBuilder(
      column: $table.firstName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get guidanceMode => $composableBuilder(
      column: $table.guidanceMode,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get birthTimeMinutes => $composableBuilder(
      column: $table.birthTimeMinutes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get birthUtcOffsetMinutes => $composableBuilder(
      column: $table.birthUtcOffsetMinutes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get birthPlace => $composableBuilder(
      column: $table.birthPlace, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get birthLatitude => $composableBuilder(
      column: $table.birthLatitude,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get birthLongitude => $composableBuilder(
      column: $table.birthLongitude,
      builder: (column) => ColumnOrderings(column));
}

class $$ProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get dob =>
      $composableBuilder(column: $table.dob, builder: (column) => column);

  GeneratedColumn<String> get sex =>
      $composableBuilder(column: $table.sex, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<double> get heightCm =>
      $composableBuilder(column: $table.heightCm, builder: (column) => column);

  GeneratedColumn<String> get units =>
      $composableBuilder(column: $table.units, builder: (column) => column);

  GeneratedColumn<bool> get hapticsEnabled => $composableBuilder(
      column: $table.hapticsEnabled, builder: (column) => column);

  GeneratedColumn<bool> get flashEnabled => $composableBuilder(
      column: $table.flashEnabled, builder: (column) => column);

  GeneratedColumn<bool> get nutritionEnabled => $composableBuilder(
      column: $table.nutritionEnabled, builder: (column) => column);

  GeneratedColumn<String> get connectedSourcesJson => $composableBuilder(
      column: $table.connectedSourcesJson, builder: (column) => column);

  GeneratedColumn<String> get firstName =>
      $composableBuilder(column: $table.firstName, builder: (column) => column);

  GeneratedColumn<String> get guidanceMode => $composableBuilder(
      column: $table.guidanceMode, builder: (column) => column);

  GeneratedColumn<int> get birthTimeMinutes => $composableBuilder(
      column: $table.birthTimeMinutes, builder: (column) => column);

  GeneratedColumn<int> get birthUtcOffsetMinutes => $composableBuilder(
      column: $table.birthUtcOffsetMinutes, builder: (column) => column);

  GeneratedColumn<String> get birthPlace => $composableBuilder(
      column: $table.birthPlace, builder: (column) => column);

  GeneratedColumn<double> get birthLatitude => $composableBuilder(
      column: $table.birthLatitude, builder: (column) => column);

  GeneratedColumn<double> get birthLongitude => $composableBuilder(
      column: $table.birthLongitude, builder: (column) => column);
}

class $$ProfilesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProfilesTable,
    ProfileRow,
    $$ProfilesTableFilterComposer,
    $$ProfilesTableOrderingComposer,
    $$ProfilesTableAnnotationComposer,
    $$ProfilesTableCreateCompanionBuilder,
    $$ProfilesTableUpdateCompanionBuilder,
    (ProfileRow, BaseReferences<_$AppDatabase, $ProfilesTable, ProfileRow>),
    ProfileRow,
    PrefetchHooks Function()> {
  $$ProfilesTableTableManager(_$AppDatabase db, $ProfilesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> dob = const Value.absent(),
            Value<String> sex = const Value.absent(),
            Value<double> weightKg = const Value.absent(),
            Value<double?> heightCm = const Value.absent(),
            Value<String> units = const Value.absent(),
            Value<bool> hapticsEnabled = const Value.absent(),
            Value<bool> flashEnabled = const Value.absent(),
            Value<bool> nutritionEnabled = const Value.absent(),
            Value<String> connectedSourcesJson = const Value.absent(),
            Value<String?> firstName = const Value.absent(),
            Value<String> guidanceMode = const Value.absent(),
            Value<int?> birthTimeMinutes = const Value.absent(),
            Value<int?> birthUtcOffsetMinutes = const Value.absent(),
            Value<String?> birthPlace = const Value.absent(),
            Value<double?> birthLatitude = const Value.absent(),
            Value<double?> birthLongitude = const Value.absent(),
          }) =>
              ProfilesCompanion(
            id: id,
            dob: dob,
            sex: sex,
            weightKg: weightKg,
            heightCm: heightCm,
            units: units,
            hapticsEnabled: hapticsEnabled,
            flashEnabled: flashEnabled,
            nutritionEnabled: nutritionEnabled,
            connectedSourcesJson: connectedSourcesJson,
            firstName: firstName,
            guidanceMode: guidanceMode,
            birthTimeMinutes: birthTimeMinutes,
            birthUtcOffsetMinutes: birthUtcOffsetMinutes,
            birthPlace: birthPlace,
            birthLatitude: birthLatitude,
            birthLongitude: birthLongitude,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DateTime dob,
            required String sex,
            required double weightKg,
            Value<double?> heightCm = const Value.absent(),
            required String units,
            Value<bool> hapticsEnabled = const Value.absent(),
            Value<bool> flashEnabled = const Value.absent(),
            Value<bool> nutritionEnabled = const Value.absent(),
            Value<String> connectedSourcesJson = const Value.absent(),
            Value<String?> firstName = const Value.absent(),
            Value<String> guidanceMode = const Value.absent(),
            Value<int?> birthTimeMinutes = const Value.absent(),
            Value<int?> birthUtcOffsetMinutes = const Value.absent(),
            Value<String?> birthPlace = const Value.absent(),
            Value<double?> birthLatitude = const Value.absent(),
            Value<double?> birthLongitude = const Value.absent(),
          }) =>
              ProfilesCompanion.insert(
            id: id,
            dob: dob,
            sex: sex,
            weightKg: weightKg,
            heightCm: heightCm,
            units: units,
            hapticsEnabled: hapticsEnabled,
            flashEnabled: flashEnabled,
            nutritionEnabled: nutritionEnabled,
            connectedSourcesJson: connectedSourcesJson,
            firstName: firstName,
            guidanceMode: guidanceMode,
            birthTimeMinutes: birthTimeMinutes,
            birthUtcOffsetMinutes: birthUtcOffsetMinutes,
            birthPlace: birthPlace,
            birthLatitude: birthLatitude,
            birthLongitude: birthLongitude,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ProfilesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProfilesTable,
    ProfileRow,
    $$ProfilesTableFilterComposer,
    $$ProfilesTableOrderingComposer,
    $$ProfilesTableAnnotationComposer,
    $$ProfilesTableCreateCompanionBuilder,
    $$ProfilesTableUpdateCompanionBuilder,
    (ProfileRow, BaseReferences<_$AppDatabase, $ProfilesTable, ProfileRow>),
    ProfileRow,
    PrefetchHooks Function()>;
typedef $$DaySummariesTableCreateCompanionBuilder = DaySummariesCompanion
    Function({
  required String date,
  Value<double> activeKcal,
  Value<double> basalKcal,
  Value<double?> intakeKcal,
  Value<int> steps,
  Value<int> sessionsCount,
  Value<int> milestonesFired,
  Value<int> lastMilestoneIndex,
  Value<bool> recalibrated,
  Value<int> rowid,
});
typedef $$DaySummariesTableUpdateCompanionBuilder = DaySummariesCompanion
    Function({
  Value<String> date,
  Value<double> activeKcal,
  Value<double> basalKcal,
  Value<double?> intakeKcal,
  Value<int> steps,
  Value<int> sessionsCount,
  Value<int> milestonesFired,
  Value<int> lastMilestoneIndex,
  Value<bool> recalibrated,
  Value<int> rowid,
});

class $$DaySummariesTableFilterComposer
    extends Composer<_$AppDatabase, $DaySummariesTable> {
  $$DaySummariesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get activeKcal => $composableBuilder(
      column: $table.activeKcal, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get basalKcal => $composableBuilder(
      column: $table.basalKcal, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get intakeKcal => $composableBuilder(
      column: $table.intakeKcal, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get steps => $composableBuilder(
      column: $table.steps, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sessionsCount => $composableBuilder(
      column: $table.sessionsCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get milestonesFired => $composableBuilder(
      column: $table.milestonesFired,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastMilestoneIndex => $composableBuilder(
      column: $table.lastMilestoneIndex,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get recalibrated => $composableBuilder(
      column: $table.recalibrated, builder: (column) => ColumnFilters(column));
}

class $$DaySummariesTableOrderingComposer
    extends Composer<_$AppDatabase, $DaySummariesTable> {
  $$DaySummariesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get activeKcal => $composableBuilder(
      column: $table.activeKcal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get basalKcal => $composableBuilder(
      column: $table.basalKcal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get intakeKcal => $composableBuilder(
      column: $table.intakeKcal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get steps => $composableBuilder(
      column: $table.steps, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sessionsCount => $composableBuilder(
      column: $table.sessionsCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get milestonesFired => $composableBuilder(
      column: $table.milestonesFired,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastMilestoneIndex => $composableBuilder(
      column: $table.lastMilestoneIndex,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get recalibrated => $composableBuilder(
      column: $table.recalibrated,
      builder: (column) => ColumnOrderings(column));
}

class $$DaySummariesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DaySummariesTable> {
  $$DaySummariesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get activeKcal => $composableBuilder(
      column: $table.activeKcal, builder: (column) => column);

  GeneratedColumn<double> get basalKcal =>
      $composableBuilder(column: $table.basalKcal, builder: (column) => column);

  GeneratedColumn<double> get intakeKcal => $composableBuilder(
      column: $table.intakeKcal, builder: (column) => column);

  GeneratedColumn<int> get steps =>
      $composableBuilder(column: $table.steps, builder: (column) => column);

  GeneratedColumn<int> get sessionsCount => $composableBuilder(
      column: $table.sessionsCount, builder: (column) => column);

  GeneratedColumn<int> get milestonesFired => $composableBuilder(
      column: $table.milestonesFired, builder: (column) => column);

  GeneratedColumn<int> get lastMilestoneIndex => $composableBuilder(
      column: $table.lastMilestoneIndex, builder: (column) => column);

  GeneratedColumn<bool> get recalibrated => $composableBuilder(
      column: $table.recalibrated, builder: (column) => column);
}

class $$DaySummariesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DaySummariesTable,
    DaySummaryRow,
    $$DaySummariesTableFilterComposer,
    $$DaySummariesTableOrderingComposer,
    $$DaySummariesTableAnnotationComposer,
    $$DaySummariesTableCreateCompanionBuilder,
    $$DaySummariesTableUpdateCompanionBuilder,
    (
      DaySummaryRow,
      BaseReferences<_$AppDatabase, $DaySummariesTable, DaySummaryRow>
    ),
    DaySummaryRow,
    PrefetchHooks Function()> {
  $$DaySummariesTableTableManager(_$AppDatabase db, $DaySummariesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DaySummariesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DaySummariesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DaySummariesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> date = const Value.absent(),
            Value<double> activeKcal = const Value.absent(),
            Value<double> basalKcal = const Value.absent(),
            Value<double?> intakeKcal = const Value.absent(),
            Value<int> steps = const Value.absent(),
            Value<int> sessionsCount = const Value.absent(),
            Value<int> milestonesFired = const Value.absent(),
            Value<int> lastMilestoneIndex = const Value.absent(),
            Value<bool> recalibrated = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DaySummariesCompanion(
            date: date,
            activeKcal: activeKcal,
            basalKcal: basalKcal,
            intakeKcal: intakeKcal,
            steps: steps,
            sessionsCount: sessionsCount,
            milestonesFired: milestonesFired,
            lastMilestoneIndex: lastMilestoneIndex,
            recalibrated: recalibrated,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String date,
            Value<double> activeKcal = const Value.absent(),
            Value<double> basalKcal = const Value.absent(),
            Value<double?> intakeKcal = const Value.absent(),
            Value<int> steps = const Value.absent(),
            Value<int> sessionsCount = const Value.absent(),
            Value<int> milestonesFired = const Value.absent(),
            Value<int> lastMilestoneIndex = const Value.absent(),
            Value<bool> recalibrated = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DaySummariesCompanion.insert(
            date: date,
            activeKcal: activeKcal,
            basalKcal: basalKcal,
            intakeKcal: intakeKcal,
            steps: steps,
            sessionsCount: sessionsCount,
            milestonesFired: milestonesFired,
            lastMilestoneIndex: lastMilestoneIndex,
            recalibrated: recalibrated,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DaySummariesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DaySummariesTable,
    DaySummaryRow,
    $$DaySummariesTableFilterComposer,
    $$DaySummariesTableOrderingComposer,
    $$DaySummariesTableAnnotationComposer,
    $$DaySummariesTableCreateCompanionBuilder,
    $$DaySummariesTableUpdateCompanionBuilder,
    (
      DaySummaryRow,
      BaseReferences<_$AppDatabase, $DaySummariesTable, DaySummaryRow>
    ),
    DaySummaryRow,
    PrefetchHooks Function()>;
typedef $$RawBucketsTableCreateCompanionBuilder = RawBucketsCompanion Function({
  required DateTime minuteUtc,
  required String source,
  required double activeKcal,
  Value<int?> steps,
  Value<double?> avgHr,
  Value<int> hrSampleCount,
  required int priority,
  Value<String?> externalId,
  Value<int> rowid,
});
typedef $$RawBucketsTableUpdateCompanionBuilder = RawBucketsCompanion Function({
  Value<DateTime> minuteUtc,
  Value<String> source,
  Value<double> activeKcal,
  Value<int?> steps,
  Value<double?> avgHr,
  Value<int> hrSampleCount,
  Value<int> priority,
  Value<String?> externalId,
  Value<int> rowid,
});

class $$RawBucketsTableFilterComposer
    extends Composer<_$AppDatabase, $RawBucketsTable> {
  $$RawBucketsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get minuteUtc => $composableBuilder(
      column: $table.minuteUtc, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get activeKcal => $composableBuilder(
      column: $table.activeKcal, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get steps => $composableBuilder(
      column: $table.steps, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get avgHr => $composableBuilder(
      column: $table.avgHr, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get hrSampleCount => $composableBuilder(
      column: $table.hrSampleCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get externalId => $composableBuilder(
      column: $table.externalId, builder: (column) => ColumnFilters(column));
}

class $$RawBucketsTableOrderingComposer
    extends Composer<_$AppDatabase, $RawBucketsTable> {
  $$RawBucketsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get minuteUtc => $composableBuilder(
      column: $table.minuteUtc, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get activeKcal => $composableBuilder(
      column: $table.activeKcal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get steps => $composableBuilder(
      column: $table.steps, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get avgHr => $composableBuilder(
      column: $table.avgHr, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get hrSampleCount => $composableBuilder(
      column: $table.hrSampleCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get externalId => $composableBuilder(
      column: $table.externalId, builder: (column) => ColumnOrderings(column));
}

class $$RawBucketsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RawBucketsTable> {
  $$RawBucketsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get minuteUtc =>
      $composableBuilder(column: $table.minuteUtc, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<double> get activeKcal => $composableBuilder(
      column: $table.activeKcal, builder: (column) => column);

  GeneratedColumn<int> get steps =>
      $composableBuilder(column: $table.steps, builder: (column) => column);

  GeneratedColumn<double> get avgHr =>
      $composableBuilder(column: $table.avgHr, builder: (column) => column);

  GeneratedColumn<int> get hrSampleCount => $composableBuilder(
      column: $table.hrSampleCount, builder: (column) => column);

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<String> get externalId => $composableBuilder(
      column: $table.externalId, builder: (column) => column);
}

class $$RawBucketsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RawBucketsTable,
    RawBucketRow,
    $$RawBucketsTableFilterComposer,
    $$RawBucketsTableOrderingComposer,
    $$RawBucketsTableAnnotationComposer,
    $$RawBucketsTableCreateCompanionBuilder,
    $$RawBucketsTableUpdateCompanionBuilder,
    (
      RawBucketRow,
      BaseReferences<_$AppDatabase, $RawBucketsTable, RawBucketRow>
    ),
    RawBucketRow,
    PrefetchHooks Function()> {
  $$RawBucketsTableTableManager(_$AppDatabase db, $RawBucketsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RawBucketsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RawBucketsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RawBucketsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<DateTime> minuteUtc = const Value.absent(),
            Value<String> source = const Value.absent(),
            Value<double> activeKcal = const Value.absent(),
            Value<int?> steps = const Value.absent(),
            Value<double?> avgHr = const Value.absent(),
            Value<int> hrSampleCount = const Value.absent(),
            Value<int> priority = const Value.absent(),
            Value<String?> externalId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RawBucketsCompanion(
            minuteUtc: minuteUtc,
            source: source,
            activeKcal: activeKcal,
            steps: steps,
            avgHr: avgHr,
            hrSampleCount: hrSampleCount,
            priority: priority,
            externalId: externalId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required DateTime minuteUtc,
            required String source,
            required double activeKcal,
            Value<int?> steps = const Value.absent(),
            Value<double?> avgHr = const Value.absent(),
            Value<int> hrSampleCount = const Value.absent(),
            required int priority,
            Value<String?> externalId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RawBucketsCompanion.insert(
            minuteUtc: minuteUtc,
            source: source,
            activeKcal: activeKcal,
            steps: steps,
            avgHr: avgHr,
            hrSampleCount: hrSampleCount,
            priority: priority,
            externalId: externalId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RawBucketsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RawBucketsTable,
    RawBucketRow,
    $$RawBucketsTableFilterComposer,
    $$RawBucketsTableOrderingComposer,
    $$RawBucketsTableAnnotationComposer,
    $$RawBucketsTableCreateCompanionBuilder,
    $$RawBucketsTableUpdateCompanionBuilder,
    (
      RawBucketRow,
      BaseReferences<_$AppDatabase, $RawBucketsTable, RawBucketRow>
    ),
    RawBucketRow,
    PrefetchHooks Function()>;
typedef $$MinuteBucketsTableCreateCompanionBuilder = MinuteBucketsCompanion
    Function({
  required DateTime minuteUtc,
  required double activeKcal,
  Value<int?> steps,
  Value<double?> avgHr,
  required String winningSource,
  required String provenance,
  Value<int> rowid,
});
typedef $$MinuteBucketsTableUpdateCompanionBuilder = MinuteBucketsCompanion
    Function({
  Value<DateTime> minuteUtc,
  Value<double> activeKcal,
  Value<int?> steps,
  Value<double?> avgHr,
  Value<String> winningSource,
  Value<String> provenance,
  Value<int> rowid,
});

class $$MinuteBucketsTableFilterComposer
    extends Composer<_$AppDatabase, $MinuteBucketsTable> {
  $$MinuteBucketsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get minuteUtc => $composableBuilder(
      column: $table.minuteUtc, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get activeKcal => $composableBuilder(
      column: $table.activeKcal, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get steps => $composableBuilder(
      column: $table.steps, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get avgHr => $composableBuilder(
      column: $table.avgHr, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get winningSource => $composableBuilder(
      column: $table.winningSource, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get provenance => $composableBuilder(
      column: $table.provenance, builder: (column) => ColumnFilters(column));
}

class $$MinuteBucketsTableOrderingComposer
    extends Composer<_$AppDatabase, $MinuteBucketsTable> {
  $$MinuteBucketsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get minuteUtc => $composableBuilder(
      column: $table.minuteUtc, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get activeKcal => $composableBuilder(
      column: $table.activeKcal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get steps => $composableBuilder(
      column: $table.steps, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get avgHr => $composableBuilder(
      column: $table.avgHr, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get winningSource => $composableBuilder(
      column: $table.winningSource,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get provenance => $composableBuilder(
      column: $table.provenance, builder: (column) => ColumnOrderings(column));
}

class $$MinuteBucketsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MinuteBucketsTable> {
  $$MinuteBucketsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get minuteUtc =>
      $composableBuilder(column: $table.minuteUtc, builder: (column) => column);

  GeneratedColumn<double> get activeKcal => $composableBuilder(
      column: $table.activeKcal, builder: (column) => column);

  GeneratedColumn<int> get steps =>
      $composableBuilder(column: $table.steps, builder: (column) => column);

  GeneratedColumn<double> get avgHr =>
      $composableBuilder(column: $table.avgHr, builder: (column) => column);

  GeneratedColumn<String> get winningSource => $composableBuilder(
      column: $table.winningSource, builder: (column) => column);

  GeneratedColumn<String> get provenance => $composableBuilder(
      column: $table.provenance, builder: (column) => column);
}

class $$MinuteBucketsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MinuteBucketsTable,
    MinuteBucketRow,
    $$MinuteBucketsTableFilterComposer,
    $$MinuteBucketsTableOrderingComposer,
    $$MinuteBucketsTableAnnotationComposer,
    $$MinuteBucketsTableCreateCompanionBuilder,
    $$MinuteBucketsTableUpdateCompanionBuilder,
    (
      MinuteBucketRow,
      BaseReferences<_$AppDatabase, $MinuteBucketsTable, MinuteBucketRow>
    ),
    MinuteBucketRow,
    PrefetchHooks Function()> {
  $$MinuteBucketsTableTableManager(_$AppDatabase db, $MinuteBucketsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MinuteBucketsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MinuteBucketsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MinuteBucketsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<DateTime> minuteUtc = const Value.absent(),
            Value<double> activeKcal = const Value.absent(),
            Value<int?> steps = const Value.absent(),
            Value<double?> avgHr = const Value.absent(),
            Value<String> winningSource = const Value.absent(),
            Value<String> provenance = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MinuteBucketsCompanion(
            minuteUtc: minuteUtc,
            activeKcal: activeKcal,
            steps: steps,
            avgHr: avgHr,
            winningSource: winningSource,
            provenance: provenance,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required DateTime minuteUtc,
            required double activeKcal,
            Value<int?> steps = const Value.absent(),
            Value<double?> avgHr = const Value.absent(),
            required String winningSource,
            required String provenance,
            Value<int> rowid = const Value.absent(),
          }) =>
              MinuteBucketsCompanion.insert(
            minuteUtc: minuteUtc,
            activeKcal: activeKcal,
            steps: steps,
            avgHr: avgHr,
            winningSource: winningSource,
            provenance: provenance,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MinuteBucketsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MinuteBucketsTable,
    MinuteBucketRow,
    $$MinuteBucketsTableFilterComposer,
    $$MinuteBucketsTableOrderingComposer,
    $$MinuteBucketsTableAnnotationComposer,
    $$MinuteBucketsTableCreateCompanionBuilder,
    $$MinuteBucketsTableUpdateCompanionBuilder,
    (
      MinuteBucketRow,
      BaseReferences<_$AppDatabase, $MinuteBucketsTable, MinuteBucketRow>
    ),
    MinuteBucketRow,
    PrefetchHooks Function()>;
typedef $$IntegrationsTableCreateCompanionBuilder = IntegrationsCompanion
    Function({
  required String vendor,
  required String status,
  Value<DateTime?> lastAttempt,
  Value<DateTime?> lastSync,
  Value<String?> changesToken,
  Value<int> recordsToday,
  Value<String> diagnosticsJson,
  Value<String?> lastError,
  Value<int> rowid,
});
typedef $$IntegrationsTableUpdateCompanionBuilder = IntegrationsCompanion
    Function({
  Value<String> vendor,
  Value<String> status,
  Value<DateTime?> lastAttempt,
  Value<DateTime?> lastSync,
  Value<String?> changesToken,
  Value<int> recordsToday,
  Value<String> diagnosticsJson,
  Value<String?> lastError,
  Value<int> rowid,
});

class $$IntegrationsTableFilterComposer
    extends Composer<_$AppDatabase, $IntegrationsTable> {
  $$IntegrationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get vendor => $composableBuilder(
      column: $table.vendor, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastAttempt => $composableBuilder(
      column: $table.lastAttempt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastSync => $composableBuilder(
      column: $table.lastSync, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get changesToken => $composableBuilder(
      column: $table.changesToken, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get recordsToday => $composableBuilder(
      column: $table.recordsToday, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get diagnosticsJson => $composableBuilder(
      column: $table.diagnosticsJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastError => $composableBuilder(
      column: $table.lastError, builder: (column) => ColumnFilters(column));
}

class $$IntegrationsTableOrderingComposer
    extends Composer<_$AppDatabase, $IntegrationsTable> {
  $$IntegrationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get vendor => $composableBuilder(
      column: $table.vendor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastAttempt => $composableBuilder(
      column: $table.lastAttempt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastSync => $composableBuilder(
      column: $table.lastSync, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get changesToken => $composableBuilder(
      column: $table.changesToken,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get recordsToday => $composableBuilder(
      column: $table.recordsToday,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get diagnosticsJson => $composableBuilder(
      column: $table.diagnosticsJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastError => $composableBuilder(
      column: $table.lastError, builder: (column) => ColumnOrderings(column));
}

class $$IntegrationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $IntegrationsTable> {
  $$IntegrationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get vendor =>
      $composableBuilder(column: $table.vendor, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get lastAttempt => $composableBuilder(
      column: $table.lastAttempt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSync =>
      $composableBuilder(column: $table.lastSync, builder: (column) => column);

  GeneratedColumn<String> get changesToken => $composableBuilder(
      column: $table.changesToken, builder: (column) => column);

  GeneratedColumn<int> get recordsToday => $composableBuilder(
      column: $table.recordsToday, builder: (column) => column);

  GeneratedColumn<String> get diagnosticsJson => $composableBuilder(
      column: $table.diagnosticsJson, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);
}

class $$IntegrationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $IntegrationsTable,
    IntegrationRow,
    $$IntegrationsTableFilterComposer,
    $$IntegrationsTableOrderingComposer,
    $$IntegrationsTableAnnotationComposer,
    $$IntegrationsTableCreateCompanionBuilder,
    $$IntegrationsTableUpdateCompanionBuilder,
    (
      IntegrationRow,
      BaseReferences<_$AppDatabase, $IntegrationsTable, IntegrationRow>
    ),
    IntegrationRow,
    PrefetchHooks Function()> {
  $$IntegrationsTableTableManager(_$AppDatabase db, $IntegrationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IntegrationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IntegrationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IntegrationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> vendor = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime?> lastAttempt = const Value.absent(),
            Value<DateTime?> lastSync = const Value.absent(),
            Value<String?> changesToken = const Value.absent(),
            Value<int> recordsToday = const Value.absent(),
            Value<String> diagnosticsJson = const Value.absent(),
            Value<String?> lastError = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              IntegrationsCompanion(
            vendor: vendor,
            status: status,
            lastAttempt: lastAttempt,
            lastSync: lastSync,
            changesToken: changesToken,
            recordsToday: recordsToday,
            diagnosticsJson: diagnosticsJson,
            lastError: lastError,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String vendor,
            required String status,
            Value<DateTime?> lastAttempt = const Value.absent(),
            Value<DateTime?> lastSync = const Value.absent(),
            Value<String?> changesToken = const Value.absent(),
            Value<int> recordsToday = const Value.absent(),
            Value<String> diagnosticsJson = const Value.absent(),
            Value<String?> lastError = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              IntegrationsCompanion.insert(
            vendor: vendor,
            status: status,
            lastAttempt: lastAttempt,
            lastSync: lastSync,
            changesToken: changesToken,
            recordsToday: recordsToday,
            diagnosticsJson: diagnosticsJson,
            lastError: lastError,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$IntegrationsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $IntegrationsTable,
    IntegrationRow,
    $$IntegrationsTableFilterComposer,
    $$IntegrationsTableOrderingComposer,
    $$IntegrationsTableAnnotationComposer,
    $$IntegrationsTableCreateCompanionBuilder,
    $$IntegrationsTableUpdateCompanionBuilder,
    (
      IntegrationRow,
      BaseReferences<_$AppDatabase, $IntegrationsTable, IntegrationRow>
    ),
    IntegrationRow,
    PrefetchHooks Function()>;
typedef $$StrengthWorkoutsTableCreateCompanionBuilder
    = StrengthWorkoutsCompanion Function({
  required String id,
  required DateTime startedAt,
  required DateTime endedAt,
  required double bodyWeightKgAtTime,
  required String exercisesJson,
  required double fallbackKcal,
  required double finalKcal,
  Value<String> method,
  Value<int> rowid,
});
typedef $$StrengthWorkoutsTableUpdateCompanionBuilder
    = StrengthWorkoutsCompanion Function({
  Value<String> id,
  Value<DateTime> startedAt,
  Value<DateTime> endedAt,
  Value<double> bodyWeightKgAtTime,
  Value<String> exercisesJson,
  Value<double> fallbackKcal,
  Value<double> finalKcal,
  Value<String> method,
  Value<int> rowid,
});

class $$StrengthWorkoutsTableFilterComposer
    extends Composer<_$AppDatabase, $StrengthWorkoutsTable> {
  $$StrengthWorkoutsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
      column: $table.endedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get bodyWeightKgAtTime => $composableBuilder(
      column: $table.bodyWeightKgAtTime,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get exercisesJson => $composableBuilder(
      column: $table.exercisesJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get fallbackKcal => $composableBuilder(
      column: $table.fallbackKcal, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get finalKcal => $composableBuilder(
      column: $table.finalKcal, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get method => $composableBuilder(
      column: $table.method, builder: (column) => ColumnFilters(column));
}

class $$StrengthWorkoutsTableOrderingComposer
    extends Composer<_$AppDatabase, $StrengthWorkoutsTable> {
  $$StrengthWorkoutsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
      column: $table.endedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get bodyWeightKgAtTime => $composableBuilder(
      column: $table.bodyWeightKgAtTime,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get exercisesJson => $composableBuilder(
      column: $table.exercisesJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get fallbackKcal => $composableBuilder(
      column: $table.fallbackKcal,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get finalKcal => $composableBuilder(
      column: $table.finalKcal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get method => $composableBuilder(
      column: $table.method, builder: (column) => ColumnOrderings(column));
}

class $$StrengthWorkoutsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StrengthWorkoutsTable> {
  $$StrengthWorkoutsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<double> get bodyWeightKgAtTime => $composableBuilder(
      column: $table.bodyWeightKgAtTime, builder: (column) => column);

  GeneratedColumn<String> get exercisesJson => $composableBuilder(
      column: $table.exercisesJson, builder: (column) => column);

  GeneratedColumn<double> get fallbackKcal => $composableBuilder(
      column: $table.fallbackKcal, builder: (column) => column);

  GeneratedColumn<double> get finalKcal =>
      $composableBuilder(column: $table.finalKcal, builder: (column) => column);

  GeneratedColumn<String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);
}

class $$StrengthWorkoutsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $StrengthWorkoutsTable,
    StrengthWorkoutRow,
    $$StrengthWorkoutsTableFilterComposer,
    $$StrengthWorkoutsTableOrderingComposer,
    $$StrengthWorkoutsTableAnnotationComposer,
    $$StrengthWorkoutsTableCreateCompanionBuilder,
    $$StrengthWorkoutsTableUpdateCompanionBuilder,
    (
      StrengthWorkoutRow,
      BaseReferences<_$AppDatabase, $StrengthWorkoutsTable, StrengthWorkoutRow>
    ),
    StrengthWorkoutRow,
    PrefetchHooks Function()> {
  $$StrengthWorkoutsTableTableManager(
      _$AppDatabase db, $StrengthWorkoutsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StrengthWorkoutsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StrengthWorkoutsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StrengthWorkoutsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<DateTime> startedAt = const Value.absent(),
            Value<DateTime> endedAt = const Value.absent(),
            Value<double> bodyWeightKgAtTime = const Value.absent(),
            Value<String> exercisesJson = const Value.absent(),
            Value<double> fallbackKcal = const Value.absent(),
            Value<double> finalKcal = const Value.absent(),
            Value<String> method = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StrengthWorkoutsCompanion(
            id: id,
            startedAt: startedAt,
            endedAt: endedAt,
            bodyWeightKgAtTime: bodyWeightKgAtTime,
            exercisesJson: exercisesJson,
            fallbackKcal: fallbackKcal,
            finalKcal: finalKcal,
            method: method,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required DateTime startedAt,
            required DateTime endedAt,
            required double bodyWeightKgAtTime,
            required String exercisesJson,
            required double fallbackKcal,
            required double finalKcal,
            Value<String> method = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StrengthWorkoutsCompanion.insert(
            id: id,
            startedAt: startedAt,
            endedAt: endedAt,
            bodyWeightKgAtTime: bodyWeightKgAtTime,
            exercisesJson: exercisesJson,
            fallbackKcal: fallbackKcal,
            finalKcal: finalKcal,
            method: method,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$StrengthWorkoutsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $StrengthWorkoutsTable,
    StrengthWorkoutRow,
    $$StrengthWorkoutsTableFilterComposer,
    $$StrengthWorkoutsTableOrderingComposer,
    $$StrengthWorkoutsTableAnnotationComposer,
    $$StrengthWorkoutsTableCreateCompanionBuilder,
    $$StrengthWorkoutsTableUpdateCompanionBuilder,
    (
      StrengthWorkoutRow,
      BaseReferences<_$AppDatabase, $StrengthWorkoutsTable, StrengthWorkoutRow>
    ),
    StrengthWorkoutRow,
    PrefetchHooks Function()>;
typedef $$WeightEntriesTableCreateCompanionBuilder = WeightEntriesCompanion
    Function({
  Value<int> id,
  required DateTime recordedAt,
  required double kg,
  Value<String> source,
});
typedef $$WeightEntriesTableUpdateCompanionBuilder = WeightEntriesCompanion
    Function({
  Value<int> id,
  Value<DateTime> recordedAt,
  Value<double> kg,
  Value<String> source,
});

class $$WeightEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $WeightEntriesTable> {
  $$WeightEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get recordedAt => $composableBuilder(
      column: $table.recordedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get kg => $composableBuilder(
      column: $table.kg, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnFilters(column));
}

class $$WeightEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $WeightEntriesTable> {
  $$WeightEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get recordedAt => $composableBuilder(
      column: $table.recordedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get kg => $composableBuilder(
      column: $table.kg, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnOrderings(column));
}

class $$WeightEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeightEntriesTable> {
  $$WeightEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get recordedAt => $composableBuilder(
      column: $table.recordedAt, builder: (column) => column);

  GeneratedColumn<double> get kg =>
      $composableBuilder(column: $table.kg, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);
}

class $$WeightEntriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WeightEntriesTable,
    WeightEntryRow,
    $$WeightEntriesTableFilterComposer,
    $$WeightEntriesTableOrderingComposer,
    $$WeightEntriesTableAnnotationComposer,
    $$WeightEntriesTableCreateCompanionBuilder,
    $$WeightEntriesTableUpdateCompanionBuilder,
    (
      WeightEntryRow,
      BaseReferences<_$AppDatabase, $WeightEntriesTable, WeightEntryRow>
    ),
    WeightEntryRow,
    PrefetchHooks Function()> {
  $$WeightEntriesTableTableManager(_$AppDatabase db, $WeightEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeightEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeightEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeightEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> recordedAt = const Value.absent(),
            Value<double> kg = const Value.absent(),
            Value<String> source = const Value.absent(),
          }) =>
              WeightEntriesCompanion(
            id: id,
            recordedAt: recordedAt,
            kg: kg,
            source: source,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DateTime recordedAt,
            required double kg,
            Value<String> source = const Value.absent(),
          }) =>
              WeightEntriesCompanion.insert(
            id: id,
            recordedAt: recordedAt,
            kg: kg,
            source: source,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$WeightEntriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $WeightEntriesTable,
    WeightEntryRow,
    $$WeightEntriesTableFilterComposer,
    $$WeightEntriesTableOrderingComposer,
    $$WeightEntriesTableAnnotationComposer,
    $$WeightEntriesTableCreateCompanionBuilder,
    $$WeightEntriesTableUpdateCompanionBuilder,
    (
      WeightEntryRow,
      BaseReferences<_$AppDatabase, $WeightEntriesTable, WeightEntryRow>
    ),
    WeightEntryRow,
    PrefetchHooks Function()>;
typedef $$NutritionEntriesTableCreateCompanionBuilder
    = NutritionEntriesCompanion Function({
  Value<int> id,
  required DateTime recordedAt,
  required double kcal,
  Value<double?> proteinG,
  Value<double?> carbsG,
  Value<double?> fatG,
  required String meal,
  Value<String> source,
  Value<String> metadataJson,
});
typedef $$NutritionEntriesTableUpdateCompanionBuilder
    = NutritionEntriesCompanion Function({
  Value<int> id,
  Value<DateTime> recordedAt,
  Value<double> kcal,
  Value<double?> proteinG,
  Value<double?> carbsG,
  Value<double?> fatG,
  Value<String> meal,
  Value<String> source,
  Value<String> metadataJson,
});

class $$NutritionEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $NutritionEntriesTable> {
  $$NutritionEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get recordedAt => $composableBuilder(
      column: $table.recordedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get kcal => $composableBuilder(
      column: $table.kcal, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get proteinG => $composableBuilder(
      column: $table.proteinG, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get carbsG => $composableBuilder(
      column: $table.carbsG, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get fatG => $composableBuilder(
      column: $table.fatG, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get meal => $composableBuilder(
      column: $table.meal, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get metadataJson => $composableBuilder(
      column: $table.metadataJson, builder: (column) => ColumnFilters(column));
}

class $$NutritionEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $NutritionEntriesTable> {
  $$NutritionEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get recordedAt => $composableBuilder(
      column: $table.recordedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get kcal => $composableBuilder(
      column: $table.kcal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get proteinG => $composableBuilder(
      column: $table.proteinG, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get carbsG => $composableBuilder(
      column: $table.carbsG, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get fatG => $composableBuilder(
      column: $table.fatG, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get meal => $composableBuilder(
      column: $table.meal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get metadataJson => $composableBuilder(
      column: $table.metadataJson,
      builder: (column) => ColumnOrderings(column));
}

class $$NutritionEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NutritionEntriesTable> {
  $$NutritionEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get recordedAt => $composableBuilder(
      column: $table.recordedAt, builder: (column) => column);

  GeneratedColumn<double> get kcal =>
      $composableBuilder(column: $table.kcal, builder: (column) => column);

  GeneratedColumn<double> get proteinG =>
      $composableBuilder(column: $table.proteinG, builder: (column) => column);

  GeneratedColumn<double> get carbsG =>
      $composableBuilder(column: $table.carbsG, builder: (column) => column);

  GeneratedColumn<double> get fatG =>
      $composableBuilder(column: $table.fatG, builder: (column) => column);

  GeneratedColumn<String> get meal =>
      $composableBuilder(column: $table.meal, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get metadataJson => $composableBuilder(
      column: $table.metadataJson, builder: (column) => column);
}

class $$NutritionEntriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $NutritionEntriesTable,
    NutritionEntryRow,
    $$NutritionEntriesTableFilterComposer,
    $$NutritionEntriesTableOrderingComposer,
    $$NutritionEntriesTableAnnotationComposer,
    $$NutritionEntriesTableCreateCompanionBuilder,
    $$NutritionEntriesTableUpdateCompanionBuilder,
    (
      NutritionEntryRow,
      BaseReferences<_$AppDatabase, $NutritionEntriesTable, NutritionEntryRow>
    ),
    NutritionEntryRow,
    PrefetchHooks Function()> {
  $$NutritionEntriesTableTableManager(
      _$AppDatabase db, $NutritionEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NutritionEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NutritionEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NutritionEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> recordedAt = const Value.absent(),
            Value<double> kcal = const Value.absent(),
            Value<double?> proteinG = const Value.absent(),
            Value<double?> carbsG = const Value.absent(),
            Value<double?> fatG = const Value.absent(),
            Value<String> meal = const Value.absent(),
            Value<String> source = const Value.absent(),
            Value<String> metadataJson = const Value.absent(),
          }) =>
              NutritionEntriesCompanion(
            id: id,
            recordedAt: recordedAt,
            kcal: kcal,
            proteinG: proteinG,
            carbsG: carbsG,
            fatG: fatG,
            meal: meal,
            source: source,
            metadataJson: metadataJson,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DateTime recordedAt,
            required double kcal,
            Value<double?> proteinG = const Value.absent(),
            Value<double?> carbsG = const Value.absent(),
            Value<double?> fatG = const Value.absent(),
            required String meal,
            Value<String> source = const Value.absent(),
            Value<String> metadataJson = const Value.absent(),
          }) =>
              NutritionEntriesCompanion.insert(
            id: id,
            recordedAt: recordedAt,
            kcal: kcal,
            proteinG: proteinG,
            carbsG: carbsG,
            fatG: fatG,
            meal: meal,
            source: source,
            metadataJson: metadataJson,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$NutritionEntriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $NutritionEntriesTable,
    NutritionEntryRow,
    $$NutritionEntriesTableFilterComposer,
    $$NutritionEntriesTableOrderingComposer,
    $$NutritionEntriesTableAnnotationComposer,
    $$NutritionEntriesTableCreateCompanionBuilder,
    $$NutritionEntriesTableUpdateCompanionBuilder,
    (
      NutritionEntryRow,
      BaseReferences<_$AppDatabase, $NutritionEntriesTable, NutritionEntryRow>
    ),
    NutritionEntryRow,
    PrefetchHooks Function()>;
typedef $$LiveSessionsTableCreateCompanionBuilder = LiveSessionsCompanion
    Function({
  required String id,
  required DateTime startedAt,
  required DateTime endedAt,
  required String sourceId,
  required String hrSeriesJson,
  required double finalKcal,
  Value<int> rowid,
});
typedef $$LiveSessionsTableUpdateCompanionBuilder = LiveSessionsCompanion
    Function({
  Value<String> id,
  Value<DateTime> startedAt,
  Value<DateTime> endedAt,
  Value<String> sourceId,
  Value<String> hrSeriesJson,
  Value<double> finalKcal,
  Value<int> rowid,
});

class $$LiveSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $LiveSessionsTable> {
  $$LiveSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
      column: $table.endedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sourceId => $composableBuilder(
      column: $table.sourceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get hrSeriesJson => $composableBuilder(
      column: $table.hrSeriesJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get finalKcal => $composableBuilder(
      column: $table.finalKcal, builder: (column) => ColumnFilters(column));
}

class $$LiveSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $LiveSessionsTable> {
  $$LiveSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
      column: $table.endedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sourceId => $composableBuilder(
      column: $table.sourceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get hrSeriesJson => $composableBuilder(
      column: $table.hrSeriesJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get finalKcal => $composableBuilder(
      column: $table.finalKcal, builder: (column) => ColumnOrderings(column));
}

class $$LiveSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LiveSessionsTable> {
  $$LiveSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<String> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => column);

  GeneratedColumn<String> get hrSeriesJson => $composableBuilder(
      column: $table.hrSeriesJson, builder: (column) => column);

  GeneratedColumn<double> get finalKcal =>
      $composableBuilder(column: $table.finalKcal, builder: (column) => column);
}

class $$LiveSessionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LiveSessionsTable,
    LiveSessionRow,
    $$LiveSessionsTableFilterComposer,
    $$LiveSessionsTableOrderingComposer,
    $$LiveSessionsTableAnnotationComposer,
    $$LiveSessionsTableCreateCompanionBuilder,
    $$LiveSessionsTableUpdateCompanionBuilder,
    (
      LiveSessionRow,
      BaseReferences<_$AppDatabase, $LiveSessionsTable, LiveSessionRow>
    ),
    LiveSessionRow,
    PrefetchHooks Function()> {
  $$LiveSessionsTableTableManager(_$AppDatabase db, $LiveSessionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LiveSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LiveSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LiveSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<DateTime> startedAt = const Value.absent(),
            Value<DateTime> endedAt = const Value.absent(),
            Value<String> sourceId = const Value.absent(),
            Value<String> hrSeriesJson = const Value.absent(),
            Value<double> finalKcal = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LiveSessionsCompanion(
            id: id,
            startedAt: startedAt,
            endedAt: endedAt,
            sourceId: sourceId,
            hrSeriesJson: hrSeriesJson,
            finalKcal: finalKcal,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required DateTime startedAt,
            required DateTime endedAt,
            required String sourceId,
            required String hrSeriesJson,
            required double finalKcal,
            Value<int> rowid = const Value.absent(),
          }) =>
              LiveSessionsCompanion.insert(
            id: id,
            startedAt: startedAt,
            endedAt: endedAt,
            sourceId: sourceId,
            hrSeriesJson: hrSeriesJson,
            finalKcal: finalKcal,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LiveSessionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LiveSessionsTable,
    LiveSessionRow,
    $$LiveSessionsTableFilterComposer,
    $$LiveSessionsTableOrderingComposer,
    $$LiveSessionsTableAnnotationComposer,
    $$LiveSessionsTableCreateCompanionBuilder,
    $$LiveSessionsTableUpdateCompanionBuilder,
    (
      LiveSessionRow,
      BaseReferences<_$AppDatabase, $LiveSessionsTable, LiveSessionRow>
    ),
    LiveSessionRow,
    PrefetchHooks Function()>;
typedef $$RememberedSensorsTableCreateCompanionBuilder
    = RememberedSensorsCompanion Function({
  required String deviceId,
  required String name,
  Value<bool> paired,
  Value<DateTime?> lastConnected,
  Value<int> rowid,
});
typedef $$RememberedSensorsTableUpdateCompanionBuilder
    = RememberedSensorsCompanion Function({
  Value<String> deviceId,
  Value<String> name,
  Value<bool> paired,
  Value<DateTime?> lastConnected,
  Value<int> rowid,
});

class $$RememberedSensorsTableFilterComposer
    extends Composer<_$AppDatabase, $RememberedSensorsTable> {
  $$RememberedSensorsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get paired => $composableBuilder(
      column: $table.paired, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastConnected => $composableBuilder(
      column: $table.lastConnected, builder: (column) => ColumnFilters(column));
}

class $$RememberedSensorsTableOrderingComposer
    extends Composer<_$AppDatabase, $RememberedSensorsTable> {
  $$RememberedSensorsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get paired => $composableBuilder(
      column: $table.paired, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastConnected => $composableBuilder(
      column: $table.lastConnected,
      builder: (column) => ColumnOrderings(column));
}

class $$RememberedSensorsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RememberedSensorsTable> {
  $$RememberedSensorsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get paired =>
      $composableBuilder(column: $table.paired, builder: (column) => column);

  GeneratedColumn<DateTime> get lastConnected => $composableBuilder(
      column: $table.lastConnected, builder: (column) => column);
}

class $$RememberedSensorsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RememberedSensorsTable,
    RememberedSensorRow,
    $$RememberedSensorsTableFilterComposer,
    $$RememberedSensorsTableOrderingComposer,
    $$RememberedSensorsTableAnnotationComposer,
    $$RememberedSensorsTableCreateCompanionBuilder,
    $$RememberedSensorsTableUpdateCompanionBuilder,
    (
      RememberedSensorRow,
      BaseReferences<_$AppDatabase, $RememberedSensorsTable,
          RememberedSensorRow>
    ),
    RememberedSensorRow,
    PrefetchHooks Function()> {
  $$RememberedSensorsTableTableManager(
      _$AppDatabase db, $RememberedSensorsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RememberedSensorsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RememberedSensorsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RememberedSensorsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> deviceId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<bool> paired = const Value.absent(),
            Value<DateTime?> lastConnected = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RememberedSensorsCompanion(
            deviceId: deviceId,
            name: name,
            paired: paired,
            lastConnected: lastConnected,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String deviceId,
            required String name,
            Value<bool> paired = const Value.absent(),
            Value<DateTime?> lastConnected = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RememberedSensorsCompanion.insert(
            deviceId: deviceId,
            name: name,
            paired: paired,
            lastConnected: lastConnected,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RememberedSensorsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RememberedSensorsTable,
    RememberedSensorRow,
    $$RememberedSensorsTableFilterComposer,
    $$RememberedSensorsTableOrderingComposer,
    $$RememberedSensorsTableAnnotationComposer,
    $$RememberedSensorsTableCreateCompanionBuilder,
    $$RememberedSensorsTableUpdateCompanionBuilder,
    (
      RememberedSensorRow,
      BaseReferences<_$AppDatabase, $RememberedSensorsTable,
          RememberedSensorRow>
    ),
    RememberedSensorRow,
    PrefetchHooks Function()>;
typedef $$GuidanceCacheTableCreateCompanionBuilder = GuidanceCacheCompanion
    Function({
  Value<int> id,
  required DateTime generatedAt,
  required String contextFingerprint,
  required String contentJson,
  required String source,
});
typedef $$GuidanceCacheTableUpdateCompanionBuilder = GuidanceCacheCompanion
    Function({
  Value<int> id,
  Value<DateTime> generatedAt,
  Value<String> contextFingerprint,
  Value<String> contentJson,
  Value<String> source,
});

class $$GuidanceCacheTableFilterComposer
    extends Composer<_$AppDatabase, $GuidanceCacheTable> {
  $$GuidanceCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get generatedAt => $composableBuilder(
      column: $table.generatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get contextFingerprint => $composableBuilder(
      column: $table.contextFingerprint,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get contentJson => $composableBuilder(
      column: $table.contentJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnFilters(column));
}

class $$GuidanceCacheTableOrderingComposer
    extends Composer<_$AppDatabase, $GuidanceCacheTable> {
  $$GuidanceCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get generatedAt => $composableBuilder(
      column: $table.generatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get contextFingerprint => $composableBuilder(
      column: $table.contextFingerprint,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get contentJson => $composableBuilder(
      column: $table.contentJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnOrderings(column));
}

class $$GuidanceCacheTableAnnotationComposer
    extends Composer<_$AppDatabase, $GuidanceCacheTable> {
  $$GuidanceCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get generatedAt => $composableBuilder(
      column: $table.generatedAt, builder: (column) => column);

  GeneratedColumn<String> get contextFingerprint => $composableBuilder(
      column: $table.contextFingerprint, builder: (column) => column);

  GeneratedColumn<String> get contentJson => $composableBuilder(
      column: $table.contentJson, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);
}

class $$GuidanceCacheTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GuidanceCacheTable,
    GuidanceCacheRow,
    $$GuidanceCacheTableFilterComposer,
    $$GuidanceCacheTableOrderingComposer,
    $$GuidanceCacheTableAnnotationComposer,
    $$GuidanceCacheTableCreateCompanionBuilder,
    $$GuidanceCacheTableUpdateCompanionBuilder,
    (
      GuidanceCacheRow,
      BaseReferences<_$AppDatabase, $GuidanceCacheTable, GuidanceCacheRow>
    ),
    GuidanceCacheRow,
    PrefetchHooks Function()> {
  $$GuidanceCacheTableTableManager(_$AppDatabase db, $GuidanceCacheTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GuidanceCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GuidanceCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GuidanceCacheTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> generatedAt = const Value.absent(),
            Value<String> contextFingerprint = const Value.absent(),
            Value<String> contentJson = const Value.absent(),
            Value<String> source = const Value.absent(),
          }) =>
              GuidanceCacheCompanion(
            id: id,
            generatedAt: generatedAt,
            contextFingerprint: contextFingerprint,
            contentJson: contentJson,
            source: source,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DateTime generatedAt,
            required String contextFingerprint,
            required String contentJson,
            required String source,
          }) =>
              GuidanceCacheCompanion.insert(
            id: id,
            generatedAt: generatedAt,
            contextFingerprint: contextFingerprint,
            contentJson: contentJson,
            source: source,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$GuidanceCacheTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GuidanceCacheTable,
    GuidanceCacheRow,
    $$GuidanceCacheTableFilterComposer,
    $$GuidanceCacheTableOrderingComposer,
    $$GuidanceCacheTableAnnotationComposer,
    $$GuidanceCacheTableCreateCompanionBuilder,
    $$GuidanceCacheTableUpdateCompanionBuilder,
    (
      GuidanceCacheRow,
      BaseReferences<_$AppDatabase, $GuidanceCacheTable, GuidanceCacheRow>
    ),
    GuidanceCacheRow,
    PrefetchHooks Function()>;
typedef $$LifestyleEntriesTableCreateCompanionBuilder
    = LifestyleEntriesCompanion Function({
  Value<int> id,
  required DateTime recordedAt,
  required String kind,
  Value<double?> value,
  Value<double?> durationMinutes,
  Value<String?> note,
  Value<String> source,
});
typedef $$LifestyleEntriesTableUpdateCompanionBuilder
    = LifestyleEntriesCompanion Function({
  Value<int> id,
  Value<DateTime> recordedAt,
  Value<String> kind,
  Value<double?> value,
  Value<double?> durationMinutes,
  Value<String?> note,
  Value<String> source,
});

class $$LifestyleEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $LifestyleEntriesTable> {
  $$LifestyleEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get recordedAt => $composableBuilder(
      column: $table.recordedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get kind => $composableBuilder(
      column: $table.kind, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get durationMinutes => $composableBuilder(
      column: $table.durationMinutes,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnFilters(column));
}

class $$LifestyleEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $LifestyleEntriesTable> {
  $$LifestyleEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get recordedAt => $composableBuilder(
      column: $table.recordedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get kind => $composableBuilder(
      column: $table.kind, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get durationMinutes => $composableBuilder(
      column: $table.durationMinutes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnOrderings(column));
}

class $$LifestyleEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LifestyleEntriesTable> {
  $$LifestyleEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get recordedAt => $composableBuilder(
      column: $table.recordedAt, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<double> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<double> get durationMinutes => $composableBuilder(
      column: $table.durationMinutes, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);
}

class $$LifestyleEntriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LifestyleEntriesTable,
    LifestyleEntryRow,
    $$LifestyleEntriesTableFilterComposer,
    $$LifestyleEntriesTableOrderingComposer,
    $$LifestyleEntriesTableAnnotationComposer,
    $$LifestyleEntriesTableCreateCompanionBuilder,
    $$LifestyleEntriesTableUpdateCompanionBuilder,
    (
      LifestyleEntryRow,
      BaseReferences<_$AppDatabase, $LifestyleEntriesTable, LifestyleEntryRow>
    ),
    LifestyleEntryRow,
    PrefetchHooks Function()> {
  $$LifestyleEntriesTableTableManager(
      _$AppDatabase db, $LifestyleEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LifestyleEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LifestyleEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LifestyleEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> recordedAt = const Value.absent(),
            Value<String> kind = const Value.absent(),
            Value<double?> value = const Value.absent(),
            Value<double?> durationMinutes = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<String> source = const Value.absent(),
          }) =>
              LifestyleEntriesCompanion(
            id: id,
            recordedAt: recordedAt,
            kind: kind,
            value: value,
            durationMinutes: durationMinutes,
            note: note,
            source: source,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DateTime recordedAt,
            required String kind,
            Value<double?> value = const Value.absent(),
            Value<double?> durationMinutes = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<String> source = const Value.absent(),
          }) =>
              LifestyleEntriesCompanion.insert(
            id: id,
            recordedAt: recordedAt,
            kind: kind,
            value: value,
            durationMinutes: durationMinutes,
            note: note,
            source: source,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LifestyleEntriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LifestyleEntriesTable,
    LifestyleEntryRow,
    $$LifestyleEntriesTableFilterComposer,
    $$LifestyleEntriesTableOrderingComposer,
    $$LifestyleEntriesTableAnnotationComposer,
    $$LifestyleEntriesTableCreateCompanionBuilder,
    $$LifestyleEntriesTableUpdateCompanionBuilder,
    (
      LifestyleEntryRow,
      BaseReferences<_$AppDatabase, $LifestyleEntriesTable, LifestyleEntryRow>
    ),
    LifestyleEntryRow,
    PrefetchHooks Function()>;
typedef $$PatternCandidatesTableCreateCompanionBuilder
    = PatternCandidatesCompanion Function({
  required String key,
  required DateTime computedAt,
  required String summary,
  required String evidenceJson,
  required double confidence,
  Value<String> status,
  Value<int> rowid,
});
typedef $$PatternCandidatesTableUpdateCompanionBuilder
    = PatternCandidatesCompanion Function({
  Value<String> key,
  Value<DateTime> computedAt,
  Value<String> summary,
  Value<String> evidenceJson,
  Value<double> confidence,
  Value<String> status,
  Value<int> rowid,
});

class $$PatternCandidatesTableFilterComposer
    extends Composer<_$AppDatabase, $PatternCandidatesTable> {
  $$PatternCandidatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get computedAt => $composableBuilder(
      column: $table.computedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get summary => $composableBuilder(
      column: $table.summary, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get evidenceJson => $composableBuilder(
      column: $table.evidenceJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get confidence => $composableBuilder(
      column: $table.confidence, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));
}

class $$PatternCandidatesTableOrderingComposer
    extends Composer<_$AppDatabase, $PatternCandidatesTable> {
  $$PatternCandidatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get computedAt => $composableBuilder(
      column: $table.computedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get summary => $composableBuilder(
      column: $table.summary, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get evidenceJson => $composableBuilder(
      column: $table.evidenceJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get confidence => $composableBuilder(
      column: $table.confidence, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));
}

class $$PatternCandidatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PatternCandidatesTable> {
  $$PatternCandidatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<DateTime> get computedAt => $composableBuilder(
      column: $table.computedAt, builder: (column) => column);

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<String> get evidenceJson => $composableBuilder(
      column: $table.evidenceJson, builder: (column) => column);

  GeneratedColumn<double> get confidence => $composableBuilder(
      column: $table.confidence, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$PatternCandidatesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PatternCandidatesTable,
    PatternCandidateRow,
    $$PatternCandidatesTableFilterComposer,
    $$PatternCandidatesTableOrderingComposer,
    $$PatternCandidatesTableAnnotationComposer,
    $$PatternCandidatesTableCreateCompanionBuilder,
    $$PatternCandidatesTableUpdateCompanionBuilder,
    (
      PatternCandidateRow,
      BaseReferences<_$AppDatabase, $PatternCandidatesTable,
          PatternCandidateRow>
    ),
    PatternCandidateRow,
    PrefetchHooks Function()> {
  $$PatternCandidatesTableTableManager(
      _$AppDatabase db, $PatternCandidatesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PatternCandidatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PatternCandidatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PatternCandidatesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<DateTime> computedAt = const Value.absent(),
            Value<String> summary = const Value.absent(),
            Value<String> evidenceJson = const Value.absent(),
            Value<double> confidence = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PatternCandidatesCompanion(
            key: key,
            computedAt: computedAt,
            summary: summary,
            evidenceJson: evidenceJson,
            confidence: confidence,
            status: status,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String key,
            required DateTime computedAt,
            required String summary,
            required String evidenceJson,
            required double confidence,
            Value<String> status = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PatternCandidatesCompanion.insert(
            key: key,
            computedAt: computedAt,
            summary: summary,
            evidenceJson: evidenceJson,
            confidence: confidence,
            status: status,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PatternCandidatesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PatternCandidatesTable,
    PatternCandidateRow,
    $$PatternCandidatesTableFilterComposer,
    $$PatternCandidatesTableOrderingComposer,
    $$PatternCandidatesTableAnnotationComposer,
    $$PatternCandidatesTableCreateCompanionBuilder,
    $$PatternCandidatesTableUpdateCompanionBuilder,
    (
      PatternCandidateRow,
      BaseReferences<_$AppDatabase, $PatternCandidatesTable,
          PatternCandidateRow>
    ),
    PatternCandidateRow,
    PrefetchHooks Function()>;
typedef $$JournalEntriesTableCreateCompanionBuilder = JournalEntriesCompanion
    Function({
  Value<int> id,
  required DateTime createdAt,
  required String entryText,
  Value<String> source,
  Value<String> status,
  Value<String?> extractionJson,
  Value<String?> model,
  Value<DateTime?> appliedAt,
});
typedef $$JournalEntriesTableUpdateCompanionBuilder = JournalEntriesCompanion
    Function({
  Value<int> id,
  Value<DateTime> createdAt,
  Value<String> entryText,
  Value<String> source,
  Value<String> status,
  Value<String?> extractionJson,
  Value<String?> model,
  Value<DateTime?> appliedAt,
});

class $$JournalEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $JournalEntriesTable> {
  $$JournalEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entryText => $composableBuilder(
      column: $table.entryText, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get extractionJson => $composableBuilder(
      column: $table.extractionJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get model => $composableBuilder(
      column: $table.model, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get appliedAt => $composableBuilder(
      column: $table.appliedAt, builder: (column) => ColumnFilters(column));
}

class $$JournalEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $JournalEntriesTable> {
  $$JournalEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entryText => $composableBuilder(
      column: $table.entryText, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get extractionJson => $composableBuilder(
      column: $table.extractionJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get model => $composableBuilder(
      column: $table.model, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get appliedAt => $composableBuilder(
      column: $table.appliedAt, builder: (column) => ColumnOrderings(column));
}

class $$JournalEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $JournalEntriesTable> {
  $$JournalEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get entryText =>
      $composableBuilder(column: $table.entryText, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get extractionJson => $composableBuilder(
      column: $table.extractionJson, builder: (column) => column);

  GeneratedColumn<String> get model =>
      $composableBuilder(column: $table.model, builder: (column) => column);

  GeneratedColumn<DateTime> get appliedAt =>
      $composableBuilder(column: $table.appliedAt, builder: (column) => column);
}

class $$JournalEntriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $JournalEntriesTable,
    JournalEntryRow,
    $$JournalEntriesTableFilterComposer,
    $$JournalEntriesTableOrderingComposer,
    $$JournalEntriesTableAnnotationComposer,
    $$JournalEntriesTableCreateCompanionBuilder,
    $$JournalEntriesTableUpdateCompanionBuilder,
    (
      JournalEntryRow,
      BaseReferences<_$AppDatabase, $JournalEntriesTable, JournalEntryRow>
    ),
    JournalEntryRow,
    PrefetchHooks Function()> {
  $$JournalEntriesTableTableManager(
      _$AppDatabase db, $JournalEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JournalEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$JournalEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$JournalEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<String> entryText = const Value.absent(),
            Value<String> source = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> extractionJson = const Value.absent(),
            Value<String?> model = const Value.absent(),
            Value<DateTime?> appliedAt = const Value.absent(),
          }) =>
              JournalEntriesCompanion(
            id: id,
            createdAt: createdAt,
            entryText: entryText,
            source: source,
            status: status,
            extractionJson: extractionJson,
            model: model,
            appliedAt: appliedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DateTime createdAt,
            required String entryText,
            Value<String> source = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> extractionJson = const Value.absent(),
            Value<String?> model = const Value.absent(),
            Value<DateTime?> appliedAt = const Value.absent(),
          }) =>
              JournalEntriesCompanion.insert(
            id: id,
            createdAt: createdAt,
            entryText: entryText,
            source: source,
            status: status,
            extractionJson: extractionJson,
            model: model,
            appliedAt: appliedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$JournalEntriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $JournalEntriesTable,
    JournalEntryRow,
    $$JournalEntriesTableFilterComposer,
    $$JournalEntriesTableOrderingComposer,
    $$JournalEntriesTableAnnotationComposer,
    $$JournalEntriesTableCreateCompanionBuilder,
    $$JournalEntriesTableUpdateCompanionBuilder,
    (
      JournalEntryRow,
      BaseReferences<_$AppDatabase, $JournalEntriesTable, JournalEntryRow>
    ),
    JournalEntryRow,
    PrefetchHooks Function()>;
typedef $$VesselReadingsTableCreateCompanionBuilder = VesselReadingsCompanion
    Function({
  required String inputHash,
  required DateTime createdAt,
  required String contentJson,
  required String model,
  Value<int> rowid,
});
typedef $$VesselReadingsTableUpdateCompanionBuilder = VesselReadingsCompanion
    Function({
  Value<String> inputHash,
  Value<DateTime> createdAt,
  Value<String> contentJson,
  Value<String> model,
  Value<int> rowid,
});

class $$VesselReadingsTableFilterComposer
    extends Composer<_$AppDatabase, $VesselReadingsTable> {
  $$VesselReadingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get inputHash => $composableBuilder(
      column: $table.inputHash, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get contentJson => $composableBuilder(
      column: $table.contentJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get model => $composableBuilder(
      column: $table.model, builder: (column) => ColumnFilters(column));
}

class $$VesselReadingsTableOrderingComposer
    extends Composer<_$AppDatabase, $VesselReadingsTable> {
  $$VesselReadingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get inputHash => $composableBuilder(
      column: $table.inputHash, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get contentJson => $composableBuilder(
      column: $table.contentJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get model => $composableBuilder(
      column: $table.model, builder: (column) => ColumnOrderings(column));
}

class $$VesselReadingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $VesselReadingsTable> {
  $$VesselReadingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get inputHash =>
      $composableBuilder(column: $table.inputHash, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get contentJson => $composableBuilder(
      column: $table.contentJson, builder: (column) => column);

  GeneratedColumn<String> get model =>
      $composableBuilder(column: $table.model, builder: (column) => column);
}

class $$VesselReadingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $VesselReadingsTable,
    VesselReadingRow,
    $$VesselReadingsTableFilterComposer,
    $$VesselReadingsTableOrderingComposer,
    $$VesselReadingsTableAnnotationComposer,
    $$VesselReadingsTableCreateCompanionBuilder,
    $$VesselReadingsTableUpdateCompanionBuilder,
    (
      VesselReadingRow,
      BaseReferences<_$AppDatabase, $VesselReadingsTable, VesselReadingRow>
    ),
    VesselReadingRow,
    PrefetchHooks Function()> {
  $$VesselReadingsTableTableManager(
      _$AppDatabase db, $VesselReadingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VesselReadingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VesselReadingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VesselReadingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> inputHash = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<String> contentJson = const Value.absent(),
            Value<String> model = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              VesselReadingsCompanion(
            inputHash: inputHash,
            createdAt: createdAt,
            contentJson: contentJson,
            model: model,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String inputHash,
            required DateTime createdAt,
            required String contentJson,
            required String model,
            Value<int> rowid = const Value.absent(),
          }) =>
              VesselReadingsCompanion.insert(
            inputHash: inputHash,
            createdAt: createdAt,
            contentJson: contentJson,
            model: model,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$VesselReadingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $VesselReadingsTable,
    VesselReadingRow,
    $$VesselReadingsTableFilterComposer,
    $$VesselReadingsTableOrderingComposer,
    $$VesselReadingsTableAnnotationComposer,
    $$VesselReadingsTableCreateCompanionBuilder,
    $$VesselReadingsTableUpdateCompanionBuilder,
    (
      VesselReadingRow,
      BaseReferences<_$AppDatabase, $VesselReadingsTable, VesselReadingRow>
    ),
    VesselReadingRow,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProfilesTableTableManager get profiles =>
      $$ProfilesTableTableManager(_db, _db.profiles);
  $$DaySummariesTableTableManager get daySummaries =>
      $$DaySummariesTableTableManager(_db, _db.daySummaries);
  $$RawBucketsTableTableManager get rawBuckets =>
      $$RawBucketsTableTableManager(_db, _db.rawBuckets);
  $$MinuteBucketsTableTableManager get minuteBuckets =>
      $$MinuteBucketsTableTableManager(_db, _db.minuteBuckets);
  $$IntegrationsTableTableManager get integrations =>
      $$IntegrationsTableTableManager(_db, _db.integrations);
  $$StrengthWorkoutsTableTableManager get strengthWorkouts =>
      $$StrengthWorkoutsTableTableManager(_db, _db.strengthWorkouts);
  $$WeightEntriesTableTableManager get weightEntries =>
      $$WeightEntriesTableTableManager(_db, _db.weightEntries);
  $$NutritionEntriesTableTableManager get nutritionEntries =>
      $$NutritionEntriesTableTableManager(_db, _db.nutritionEntries);
  $$LiveSessionsTableTableManager get liveSessions =>
      $$LiveSessionsTableTableManager(_db, _db.liveSessions);
  $$RememberedSensorsTableTableManager get rememberedSensors =>
      $$RememberedSensorsTableTableManager(_db, _db.rememberedSensors);
  $$GuidanceCacheTableTableManager get guidanceCache =>
      $$GuidanceCacheTableTableManager(_db, _db.guidanceCache);
  $$LifestyleEntriesTableTableManager get lifestyleEntries =>
      $$LifestyleEntriesTableTableManager(_db, _db.lifestyleEntries);
  $$PatternCandidatesTableTableManager get patternCandidates =>
      $$PatternCandidatesTableTableManager(_db, _db.patternCandidates);
  $$JournalEntriesTableTableManager get journalEntries =>
      $$JournalEntriesTableTableManager(_db, _db.journalEntries);
  $$VesselReadingsTableTableManager get vesselReadings =>
      $$VesselReadingsTableTableManager(_db, _db.vesselReadings);
}
