import 'package:freezed_annotation/freezed_annotation.dart';

part 'filter_model.freezed.dart';
part 'filter_model.g.dart';

enum SortBy { newest, cheapest, mostExpensive, bestRating }

@freezed
class FilterModel with _$FilterModel {
  const FilterModel._();
  
  const factory FilterModel({
    String? categoryId,
    String? brand,
    double? minPrice,
    double? maxPrice,
    @Default(SortBy.newest) SortBy sortBy,
    String? searchQuery,
  }) = _FilterModel;
  
  factory FilterModel.fromJson(Map<String, dynamic> json) => _$FilterModelFromJson(json);
  
  // Check if any filter is applied
  bool get hasActiveFilters {
    return categoryId != null ||
           brand != null ||
           minPrice != null ||
           maxPrice != null ||
           (searchQuery != null && searchQuery!.isNotEmpty);
  }
  
  // Clear all filters
  FilterModel clearFilters() {
    return const FilterModel();
  }
}

