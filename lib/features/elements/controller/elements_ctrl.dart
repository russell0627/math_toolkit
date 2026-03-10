import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/elements_data.dart';
import '../models/element_model.dart';

part 'elements_ctrl.g.dart';

class ElementsState {
  final List<BureauElement> allElements;
  final List<BureauElement> filteredElements;
  final BureauElement? selectedElement;
  final String searchQuery;
  final String? selectedCategory;

  const ElementsState({
    this.allElements = const [],
    this.filteredElements = const [],
    this.selectedElement,
    this.searchQuery = "",
    this.selectedCategory,
  });

  ElementsState copyWith({
    List<BureauElement>? allElements,
    List<BureauElement>? filteredElements,
    BureauElement? selectedElement,
    String? searchQuery,
    String? selectedCategory,
    bool clearSelection = false,
  }) {
    return ElementsState(
      allElements: allElements ?? this.allElements,
      filteredElements: filteredElements ?? this.filteredElements,
      selectedElement: clearSelection ? null : (selectedElement ?? this.selectedElement),
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

@riverpod
class ElementsCtrl extends _$ElementsCtrl {
  @override
  ElementsState build() {
    return const ElementsState(
      allElements: ElementRegistryData.elements,
      filteredElements: ElementRegistryData.elements,
    );
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    _applyFilters();
  }

  void setCategory(String? category) {
    state = state.copyWith(selectedCategory: category);
    _applyFilters();
  }

  void selectElement(BureauElement? element) {
    state = state.copyWith(selectedElement: element, clearSelection: element == null);
  }

  void _applyFilters() {
    var filtered = state.allElements;

    if (state.searchQuery.isNotEmpty) {
      final q = state.searchQuery.toLowerCase();
      filtered = filtered
          .where(
            (e) =>
                e.name.toLowerCase().contains(q) ||
                e.symbol.toLowerCase().contains(q) ||
                e.atomicNumber.toString() == q,
          )
          .toList();
    }

    if (state.selectedCategory != null) {
      filtered = filtered.where((e) => e.category == state.selectedCategory).toList();
    }

    state = state.copyWith(filteredElements: filtered);
  }
}
