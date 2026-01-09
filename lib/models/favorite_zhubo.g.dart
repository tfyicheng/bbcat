// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_zhubo.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetFavoriteZhuboCollection on Isar {
  IsarCollection<FavoriteZhubo> get favoriteZhubos => this.collection();
}

const FavoriteZhuboSchema = CollectionSchema(
  name: r'FavoriteZhubo',
  id: 7203904250582373163,
  properties: {
    r'address': PropertySchema(
      id: 0,
      name: r'address',
      type: IsarType.string,
    ),
    r'img': PropertySchema(
      id: 1,
      name: r'img',
      type: IsarType.string,
    ),
    r'title': PropertySchema(
      id: 2,
      name: r'title',
      type: IsarType.string,
    ),
    r'updateTime': PropertySchema(
      id: 3,
      name: r'updateTime',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _favoriteZhuboEstimateSize,
  serialize: _favoriteZhuboSerialize,
  deserialize: _favoriteZhuboDeserialize,
  deserializeProp: _favoriteZhuboDeserializeProp,
  idName: r'id',
  indexes: {
    r'title': IndexSchema(
      id: -7636685945352118059,
      name: r'title',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'title',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _favoriteZhuboGetId,
  getLinks: _favoriteZhuboGetLinks,
  attach: _favoriteZhuboAttach,
  version: '3.1.0+1',
);

int _favoriteZhuboEstimateSize(
  FavoriteZhubo object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.address.length * 3;
  bytesCount += 3 + object.img.length * 3;
  bytesCount += 3 + object.title.length * 3;
  return bytesCount;
}

void _favoriteZhuboSerialize(
  FavoriteZhubo object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.address);
  writer.writeString(offsets[1], object.img);
  writer.writeString(offsets[2], object.title);
  writer.writeDateTime(offsets[3], object.updateTime);
}

FavoriteZhubo _favoriteZhuboDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FavoriteZhubo();
  object.address = reader.readString(offsets[0]);
  object.id = id;
  object.img = reader.readString(offsets[1]);
  object.title = reader.readString(offsets[2]);
  object.updateTime = reader.readDateTime(offsets[3]);
  return object;
}

P _favoriteZhuboDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _favoriteZhuboGetId(FavoriteZhubo object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _favoriteZhuboGetLinks(FavoriteZhubo object) {
  return [];
}

void _favoriteZhuboAttach(
    IsarCollection<dynamic> col, Id id, FavoriteZhubo object) {
  object.id = id;
}

extension FavoriteZhuboByIndex on IsarCollection<FavoriteZhubo> {
  Future<FavoriteZhubo?> getByTitle(String title) {
    return getByIndex(r'title', [title]);
  }

  FavoriteZhubo? getByTitleSync(String title) {
    return getByIndexSync(r'title', [title]);
  }

  Future<bool> deleteByTitle(String title) {
    return deleteByIndex(r'title', [title]);
  }

  bool deleteByTitleSync(String title) {
    return deleteByIndexSync(r'title', [title]);
  }

  Future<List<FavoriteZhubo?>> getAllByTitle(List<String> titleValues) {
    final values = titleValues.map((e) => [e]).toList();
    return getAllByIndex(r'title', values);
  }

  List<FavoriteZhubo?> getAllByTitleSync(List<String> titleValues) {
    final values = titleValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'title', values);
  }

  Future<int> deleteAllByTitle(List<String> titleValues) {
    final values = titleValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'title', values);
  }

  int deleteAllByTitleSync(List<String> titleValues) {
    final values = titleValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'title', values);
  }

  Future<Id> putByTitle(FavoriteZhubo object) {
    return putByIndex(r'title', object);
  }

  Id putByTitleSync(FavoriteZhubo object, {bool saveLinks = true}) {
    return putByIndexSync(r'title', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByTitle(List<FavoriteZhubo> objects) {
    return putAllByIndex(r'title', objects);
  }

  List<Id> putAllByTitleSync(List<FavoriteZhubo> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'title', objects, saveLinks: saveLinks);
  }
}

extension FavoriteZhuboQueryWhereSort
    on QueryBuilder<FavoriteZhubo, FavoriteZhubo, QWhere> {
  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension FavoriteZhuboQueryWhere
    on QueryBuilder<FavoriteZhubo, FavoriteZhubo, QWhereClause> {
  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QAfterWhereClause> titleEqualTo(
      String title) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'title',
        value: [title],
      ));
    });
  }

  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QAfterWhereClause> titleNotEqualTo(
      String title) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'title',
              lower: [],
              upper: [title],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'title',
              lower: [title],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'title',
              lower: [title],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'title',
              lower: [],
              upper: [title],
              includeUpper: false,
            ));
      }
    });
  }
}

extension FavoriteZhuboQueryFilter
    on QueryBuilder<FavoriteZhubo, FavoriteZhubo, QFilterCondition> {
  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QAfterFilterCondition>
      addressEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QAfterFilterCondition>
      addressGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QAfterFilterCondition>
      addressLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QAfterFilterCondition>
      addressBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'address',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QAfterFilterCondition>
      addressStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QAfterFilterCondition>
      addressEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QAfterFilterCondition>
      addressContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QAfterFilterCondition>
      addressMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'address',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QAfterFilterCondition>
      addressIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'address',
        value: '',
      ));
    });
  }

  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QAfterFilterCondition>
      addressIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'address',
        value: '',
      ));
    });
  }

  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QAfterFilterCondition> imgEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'img',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QAfterFilterCondition>
      imgGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'img',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QAfterFilterCondition> imgLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'img',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QAfterFilterCondition> imgBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'img',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QAfterFilterCondition>
      imgStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'img',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QAfterFilterCondition> imgEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'img',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QAfterFilterCondition> imgContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'img',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QAfterFilterCondition> imgMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'img',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QAfterFilterCondition>
      imgIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'img',
        value: '',
      ));
    });
  }

  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QAfterFilterCondition>
      imgIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'img',
        value: '',
      ));
    });
  }

  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QAfterFilterCondition>
      titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QAfterFilterCondition>
      titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QAfterFilterCondition>
      titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QAfterFilterCondition>
      titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QAfterFilterCondition>
      titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QAfterFilterCondition>
      titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QAfterFilterCondition>
      titleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QAfterFilterCondition>
      titleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QAfterFilterCondition>
      titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QAfterFilterCondition>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QAfterFilterCondition>
      updateTimeEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updateTime',
        value: value,
      ));
    });
  }

  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QAfterFilterCondition>
      updateTimeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updateTime',
        value: value,
      ));
    });
  }

  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QAfterFilterCondition>
      updateTimeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updateTime',
        value: value,
      ));
    });
  }

  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QAfterFilterCondition>
      updateTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updateTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension FavoriteZhuboQueryObject
    on QueryBuilder<FavoriteZhubo, FavoriteZhubo, QFilterCondition> {}

extension FavoriteZhuboQueryLinks
    on QueryBuilder<FavoriteZhubo, FavoriteZhubo, QFilterCondition> {}

extension FavoriteZhuboQuerySortBy
    on QueryBuilder<FavoriteZhubo, FavoriteZhubo, QSortBy> {
  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QAfterSortBy> sortByAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.asc);
    });
  }

  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QAfterSortBy> sortByAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.desc);
    });
  }

  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QAfterSortBy> sortByImg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'img', Sort.asc);
    });
  }

  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QAfterSortBy> sortByImgDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'img', Sort.desc);
    });
  }

  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QAfterSortBy> sortByUpdateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updateTime', Sort.asc);
    });
  }

  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QAfterSortBy>
      sortByUpdateTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updateTime', Sort.desc);
    });
  }
}

extension FavoriteZhuboQuerySortThenBy
    on QueryBuilder<FavoriteZhubo, FavoriteZhubo, QSortThenBy> {
  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QAfterSortBy> thenByAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.asc);
    });
  }

  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QAfterSortBy> thenByAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.desc);
    });
  }

  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QAfterSortBy> thenByImg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'img', Sort.asc);
    });
  }

  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QAfterSortBy> thenByImgDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'img', Sort.desc);
    });
  }

  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QAfterSortBy> thenByUpdateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updateTime', Sort.asc);
    });
  }

  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QAfterSortBy>
      thenByUpdateTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updateTime', Sort.desc);
    });
  }
}

extension FavoriteZhuboQueryWhereDistinct
    on QueryBuilder<FavoriteZhubo, FavoriteZhubo, QDistinct> {
  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QDistinct> distinctByAddress(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'address', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QDistinct> distinctByImg(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'img', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FavoriteZhubo, FavoriteZhubo, QDistinct> distinctByUpdateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updateTime');
    });
  }
}

extension FavoriteZhuboQueryProperty
    on QueryBuilder<FavoriteZhubo, FavoriteZhubo, QQueryProperty> {
  QueryBuilder<FavoriteZhubo, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<FavoriteZhubo, String, QQueryOperations> addressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'address');
    });
  }

  QueryBuilder<FavoriteZhubo, String, QQueryOperations> imgProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'img');
    });
  }

  QueryBuilder<FavoriteZhubo, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<FavoriteZhubo, DateTime, QQueryOperations> updateTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updateTime');
    });
  }
}
