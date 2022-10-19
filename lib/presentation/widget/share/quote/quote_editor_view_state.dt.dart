import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/share/quote/quote_variant_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'quote_editor_view_state.dt.freezed.dart';

@Freezed(toJson: false)
class QuoteEditorViewState with _$QuoteEditorViewState {
  @Implements<BuildState>()
  factory QuoteEditorViewState(
    List<QuoteVariantData> variants,
    int selectedIndex,
    bool isInstagramAvailable,
  ) = _QuoteEditorViewState;

  factory QuoteEditorViewState.initial() => QuoteEditorViewState(quoteVariantDataList, 0, false);
}
