// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FilterModelImpl _$$FilterModelImplFromJson(Map<String, dynamic> json) =>
    _$FilterModelImpl(
      categoryId: json['categoryId'] as String?,
      brand: json['brand'] as String?,
      minPrice: (json['minPrice'] as num?)?.toDouble(),
      maxPrice: (json['maxPrice'] as num?)?.toDouble(),
      sortBy:
          $enumDecodeNullable(_$SortByEnumMap, json['sortBy']) ?? SortBy.newest,
      searchQuery: json['searchQuery'] as String?,
    );

Map<String, dynamic> _$$FilterModelImplToJson(_$FilterModelImpl instance) =>
    <String, dynamic>{
      'categoryId': instance.categoryId,
      'brand': instance.brand,
      'minPrice': instance.minPrice,
      'maxPrice': instance.maxPrice,
      'sortBy': _$SortByEnumMap[instance.sortBy]!,
      'searchQuery': instance.searchQuery,
    };

const _$SortByEnumMap = {
  SortBy.newest: 'newest',
  SortBy.cheapest: 'cheapest',
  SortBy.mostExpensive: 'mostExpensive',
  SortBy.bestRating: 'bestRating',
};
