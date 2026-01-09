// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'browsing_history.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBrowsingHistoryCollection on Isar {
  IsarCollection<BrowsingHistory> get browsingHistorys => this.collection();
}

const BrowsingHistorySchema = CollectionSchema(
  name: r'BrowsingHistory',
  id: -3715106235610282709,
  properties: {
    r'title': PropertySchema(
      id: 0,
      name: r'title',
      type: IsarType.string,
    ),
    r'url': PropertySchema(
      id: 1,
      name: r'url',
      type: IsarType.string,
    ),
    r'visitTime': PropertySchema(
      id: 2,
      name: r'visitTime',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _browsingHistoryEstimateSize,
  serialize: _browsingHistorySerialize,
  deserialize: _browsingHistoryDeserialize,
  deserializeProp: _browsingHistoryDeserializeProp,
  idName: r'id',
  indexes: {
    r'url': IndexSchema(
      id: -5756857009679432345,
      name: r'url',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'url',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'visitTime': IndexSchema(
      id: -4141626137083872244,
      name: r'visitTime',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'visitTime',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _browsingHistoryGetId,
  getLinks: _browsingHistoryGetLinks,
  attach: _browsingHistoryAttach,
  version: '3.1.0+1',
);

int _browsingHistoryEstimateSize(
  BrowsingHistory object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.title.length * 3;
  bytesCount += 3 + object.url.length * 3;
  return bytesCount;
}

void _browsingHistorySerialize(
  BrowsingHistory object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.title);
  writer.writeString(offsets[1], object.url);
  writer.writeDateTime(offsets[2], object.visitTime);
}

BrowsingHistory _browsingHistoryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BrowsingHistory();
  object.id = id;
  object.title = reader.readString(offsets[0]);
  object.url = reader.readString(offsets[1]);
  object.visitTime = reader.readDateTime(offsets[2]);
  return object;
}

P _browsingHistoryDeserializeProp<P>(
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
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _browsingHistoryGetId(BrowsingHistory object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _browsingHistoryGetLinks(BrowsingHistory object) {
  return [];
}

void _browsingHistoryAttach(
    IsarCollection<dynamic> col, Id id, BrowsingHistory object) {
  object.id = id;
}

extension BrowsingHistoryQueryWhereSort
    on QueryBuilder<BrowsingHistory, BrowsingHistory, QWhere> {
  QueryBuilder<BrowsingHistory, BrowsingHistory, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<BrowsingHistory, BrowsingHistory, QAfterWhere> anyVisitTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'visitTime'),
      );
    });
  }
}

extension BrowsingHistoryQueryWhere
    on QueryBuilder<BrowsingHistory, BrowsingHistory, QWhereClause> {
  QueryBuilder<BrowsingHistory, BrowsingHistory, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<BrowsingHistory, BrowsingHistory, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<BrowsingHistory, BrowsingHistory, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<BrowsingHistory, BrowsingHistory, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<BrowsingHistory, BrowsingHistory, QAfterWhereClause> idBetween(
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

  QueryBuilder<BrowsingHistory, BrowsingHistory, QAfterWhereClause> urlEqualTo(
      String url) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'url',
        value: [url],
      ));
    });
  }

  QueryBuilder<BrowsingHistory, BrowsingHistory, QAfterWhereClause>
      urlNotEqualTo(String url) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'url',
              lower: [],
              upper: [url],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'url',
              lower: [url],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'url',
              lower: [url],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'url',
              lower: [],
              upper: [url],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<BrowsingHistory, BrowsingHistory, QAfterWhereClause>
      visitTimeEqualTo(DateTime visitTime) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'visitTime',
        value: [visitTime],
      ));
    });
  }

  QueryBuilder<BrowsingHistory, BrowsingHistory, QAfterWhereClause>
      visitTimeNotEqualTo(DateTime visitTime) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'visitTime',
              lower: [],
              upper: [visitTime],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'visitTime',
              lower: [visitTime],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'visitTime',
              lower: [visitTime],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'visitTime',
              lower: [],
              upper: [visitTime],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<BrowsingHistory, BrowsingHistory, QAfterWhereClause>
      visitTimeGreaterThan(
    DateTime visitTime, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'visitTime',
        lower: [visitTime],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<BrowsingHistory, BrowsingHistory, QAfterWhereClause>
      visitTimeLessThan(
    DateTime visitTime, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'visitTime',
        lower: [],
        upper: [visitTime],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<BrowsingHistory, BrowsingHistory, QAfterWhereClause>
      visitTimeBetween(
    DateTime lowerVisitTime,
    DateTime upperVisitTime, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'visitTime',
        lower: [lowerVisitTime],
        includeLower: includeLower,
        upper: [upperVisitTime],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension BrowsingHistoryQueryFilter
    on QueryBuilder<BrowsingHistory, BrowsingHistory, QFilterCondition> {
  QueryBuilder<BrowsingHistory, BrowsingHistory, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BrowsingHistory, BrowsingHistory, QAfterFilterCondition>
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

  QueryBuilder<BrowsingHistory, BrowsingHistory, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<BrowsingHistory, BrowsingHistory, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<BrowsingHistory, BrowsingHistory, QAfterFilterCondition>
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

  QueryBuilder<BrowsingHistory, BrowsingHistory, QAfterFilterCondition>
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

  QueryBuilder<BrowsingHistory, BrowsingHistory, QAfterFilterCondition>
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

  QueryBuilder<BrowsingHistory, BrowsingHistory, QAfterFilterCondition>
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

  QueryBuilder<BrowsingHistory, BrowsingHistory, QAfterFilterCondition>
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

  QueryBuilder<BrowsingHistory, BrowsingHistory, QAfterFilterCondition>
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

  QueryBuilder<BrowsingHistory, BrowsingHistory, QAfterFilterCondition>
      titleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BrowsingHistory, BrowsingHistory, QAfterFilterCondition>
      titleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BrowsingHistory, BrowsingHistory, QAfterFilterCondition>
      titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<BrowsingHistory, BrowsingHistory, QAfterFilterCondition>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<BrowsingHistory, BrowsingHistory, QAfterFilterCondition>
      urlEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BrowsingHistory, BrowsingHistory, QAfterFilterCondition>
      urlGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BrowsingHistory, BrowsingHistory, QAfterFilterCondition>
      urlLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BrowsingHistory, BrowsingHistory, QAfterFilterCondition>
      urlBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'url',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BrowsingHistory, BrowsingHistory, QAfterFilterCondition>
      urlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BrowsingHistory, BrowsingHistory, QAfterFilterCondition>
      urlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BrowsingHistory, BrowsingHistory, QAfterFilterCondition>
      urlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BrowsingHistory, BrowsingHistory, QAfterFilterCondition>
      urlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'url',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BrowsingHistory, BrowsingHistory, QAfterFilterCondition>
      urlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'url',
        value: '',
      ));
    });
  }

  QueryBuilder<BrowsingHistory, BrowsingHistory, QAfterFilterCondition>
      urlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'url',
        value: '',
      ));
    });
  }

  QueryBuilder<BrowsingHistory, BrowsingHistory, QAfterFilterCondition>
      visitTimeEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'visitTime',
        value: value,
      ));
    });
  }

  QueryBuilder<BrowsingHistory, BrowsingHistory, QAfterFilterCondition>
      visitTimeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'visitTime',
        value: value,
      ));
    });
  }

  QueryBuilder<BrowsingHistory, BrowsingHistory, QAfterFilterCondition>
      visitTimeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'visitTime',
        value: value,
      ));
    });
  }

  QueryBuilder<BrowsingHistory, BrowsingHistory, QAfterFilterCondition>
      visitTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'visitTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension BrowsingHistoryQueryObject
    on QueryBuilder<BrowsingHistory, BrowsingHistory, QFilterCondition> {}

extension BrowsingHistoryQueryLinks
    on QueryBuilder<BrowsingHistory, BrowsingHistory, QFilterCondition> {}

extension BrowsingHistoryQuerySortBy
    on QueryBuilder<BrowsingHistory, BrowsingHistory, QSortBy> {
  QueryBuilder<BrowsingHistory, BrowsingHistory, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<BrowsingHistory, BrowsingHistory, QAfterSortBy>
      sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<BrowsingHistory, BrowsingHistory, QAfterSortBy> sortByUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.asc);
    });
  }

  QueryBuilder<BrowsingHistory, BrowsingHistory, QAfterSortBy> sortByUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.desc);
    });
  }

  QueryBuilder<BrowsingHistory, BrowsingHistory, QAfterSortBy>
      sortByVisitTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'visitTime', Sort.asc);
    });
  }

  QueryBuilder<BrowsingHistory, BrowsingHistory, QAfterSortBy>
      sortByVisitTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'visitTime', Sort.desc);
    });
  }
}

extension BrowsingHistoryQuerySortThenBy
    on QueryBuilder<BrowsingHistory, BrowsingHistory, QSortThenBy> {
  QueryBuilder<BrowsingHistory, BrowsingHistory, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<BrowsingHistory, BrowsingHistory, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<BrowsingHistory, BrowsingHistory, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<BrowsingHistory, BrowsingHistory, QAfterSortBy>
      thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<BrowsingHistory, BrowsingHistory, QAfterSortBy> thenByUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.asc);
    });
  }

  QueryBuilder<BrowsingHistory, BrowsingHistory, QAfterSortBy> thenByUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.desc);
    });
  }

  QueryBuilder<BrowsingHistory, BrowsingHistory, QAfterSortBy>
      thenByVisitTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'visitTime', Sort.asc);
    });
  }

  QueryBuilder<BrowsingHistory, BrowsingHistory, QAfterSortBy>
      thenByVisitTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'visitTime', Sort.desc);
    });
  }
}

extension BrowsingHistoryQueryWhereDistinct
    on QueryBuilder<BrowsingHistory, BrowsingHistory, QDistinct> {
  QueryBuilder<BrowsingHistory, BrowsingHistory, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BrowsingHistory, BrowsingHistory, QDistinct> distinctByUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'url', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BrowsingHistory, BrowsingHistory, QDistinct>
      distinctByVisitTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'visitTime');
    });
  }
}

extension BrowsingHistoryQueryProperty
    on QueryBuilder<BrowsingHistory, BrowsingHistory, QQueryProperty> {
  QueryBuilder<BrowsingHistory, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<BrowsingHistory, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<BrowsingHistory, String, QQueryOperations> urlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'url');
    });
  }

  QueryBuilder<BrowsingHistory, DateTime, QQueryOperations>
      visitTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'visitTime');
    });
  }
}
