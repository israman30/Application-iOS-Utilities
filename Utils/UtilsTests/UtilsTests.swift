//
//  UtilsTests.swift
//  UtilsTests
//
//  Created by Israel Manzo on 12/30/23.
//

import XCTest
import SwiftUI
@testable import Utils

final class UtilsTests: XCTestCase {
    
    func testRatingStarsView_starCount_isNonNegative() {
        XCTAssertEqual(RatingStarsView(rating: 0, maxRating: 5).starCount, 5)
        XCTAssertEqual(RatingStarsView(rating: 0, maxRating: 0).starCount, 0)
        XCTAssertEqual(RatingStarsView(rating: 0, maxRating: -3).starCount, 0)
    }
    
    func testRatingStarsView_clampedRating_clampsToZeroAndMax() {
        XCTAssertEqual(RatingStarsView.clampedRating(-1, maxRating: 5), 0)
        XCTAssertEqual(RatingStarsView.clampedRating(0, maxRating: 5), 0)
        XCTAssertEqual(RatingStarsView.clampedRating(2.5, maxRating: 5), 2.5)
        XCTAssertEqual(RatingStarsView.clampedRating(5, maxRating: 5), 5)
        XCTAssertEqual(RatingStarsView.clampedRating(7, maxRating: 5), 5)
    }
    
    func testRatingStarsView_fillWidth_returnsZeroForInvalidInputs() {
        XCTAssertEqual(RatingStarsView.fillWidth(rating: 3, maxRating: 0, totalWidth: 100), 0)
        XCTAssertEqual(RatingStarsView.fillWidth(rating: 3, maxRating: -1, totalWidth: 100), 0)
        XCTAssertEqual(RatingStarsView.fillWidth(rating: 3, maxRating: 5, totalWidth: 0), 0)
        XCTAssertEqual(RatingStarsView.fillWidth(rating: 3, maxRating: 5, totalWidth: -10), 0)
    }
    
    func testRatingStarsView_fillWidth_scalesLinearlyAndClamps() {
        XCTAssertEqual(RatingStarsView.fillWidth(rating: 0, maxRating: 5, totalWidth: 200), 0)
        XCTAssertEqual(RatingStarsView.fillWidth(rating: 2.5, maxRating: 5, totalWidth: 200), 100)
        XCTAssertEqual(RatingStarsView.fillWidth(rating: 5, maxRating: 5, totalWidth: 200), 200)
        
        // Clamping behavior
        XCTAssertEqual(RatingStarsView.fillWidth(rating: -1, maxRating: 5, totalWidth: 200), 0)
        XCTAssertEqual(RatingStarsView.fillWidth(rating: 999, maxRating: 5, totalWidth: 200), 200)
    }
    
    func testRatingHeartsView_heartCount_isNonNegative() {
        XCTAssertEqual(RatingHeartsView(rating: 0, maxRating: 5).heartCount, 5)
        XCTAssertEqual(RatingHeartsView(rating: 0, maxRating: 0).heartCount, 0)
        XCTAssertEqual(RatingHeartsView(rating: 0, maxRating: -3).heartCount, 0)
    }
    
    func testRatingHeartsView_clampedRating_clampsToZeroAndMax() {
        XCTAssertEqual(RatingHeartsView.clampedRating(-1, maxRating: 5), 0)
        XCTAssertEqual(RatingHeartsView.clampedRating(0, maxRating: 5), 0)
        XCTAssertEqual(RatingHeartsView.clampedRating(2.5, maxRating: 5), 2.5)
        XCTAssertEqual(RatingHeartsView.clampedRating(5, maxRating: 5), 5)
        XCTAssertEqual(RatingHeartsView.clampedRating(7, maxRating: 5), 5)
    }
    
    func testRatingHeartsView_fillWidth_returnsZeroForInvalidInputs() {
        XCTAssertEqual(RatingHeartsView.fillWidth(rating: 3, maxRating: 0, totalWidth: 100), 0)
        XCTAssertEqual(RatingHeartsView.fillWidth(rating: 3, maxRating: -1, totalWidth: 100), 0)
        XCTAssertEqual(RatingHeartsView.fillWidth(rating: 3, maxRating: 5, totalWidth: 0), 0)
        XCTAssertEqual(RatingHeartsView.fillWidth(rating: 3, maxRating: 5, totalWidth: -10), 0)
    }
    
    func testRatingHeartsView_fillWidth_scalesLinearlyAndClamps() {
        XCTAssertEqual(RatingHeartsView.fillWidth(rating: 0, maxRating: 5, totalWidth: 200), 0)
        XCTAssertEqual(RatingHeartsView.fillWidth(rating: 2.5, maxRating: 5, totalWidth: 200), 100)
        XCTAssertEqual(RatingHeartsView.fillWidth(rating: 5, maxRating: 5, totalWidth: 200), 200)
        
        // Clamping behavior
        XCTAssertEqual(RatingHeartsView.fillWidth(rating: -1, maxRating: 5, totalWidth: 200), 0)
        XCTAssertEqual(RatingHeartsView.fillWidth(rating: 999, maxRating: 5, totalWidth: 200), 200)
    }
    
    func testHeartLikeView_symbolName_matchesLikedState() {
        XCTAssertEqual(HeartLikeView.symbolName(isLiked: false), "heart")
        XCTAssertEqual(HeartLikeView.symbolName(isLiked: true), "heart.fill")
    }
    
    func testHeartLikeView_animationScale_matchesLikedState() {
        XCTAssertEqual(HeartLikeView.animationScale(isLiked: false), 0.7)
        XCTAssertEqual(HeartLikeView.animationScale(isLiked: true), 1.3)
    }
    
    func testGridView_clampedColumns_clampsToAtLeastOne() {
        XCTAssertEqual(GridView<EmptyView, Int>.clampedColumns(3), 3)
        XCTAssertEqual(GridView<EmptyView, Int>.clampedColumns(1), 1)
        XCTAssertEqual(GridView<EmptyView, Int>.clampedColumns(0), 1)
        XCTAssertEqual(GridView<EmptyView, Int>.clampedColumns(-10), 1)
    }
    
    func testGridView_clampedTotalCount_clampsToArrayBounds() {
        XCTAssertEqual(GridView<EmptyView, Int>.clampedTotalCount(3, itemsCount: 10), 3)
        XCTAssertEqual(GridView<EmptyView, Int>.clampedTotalCount(0, itemsCount: 10), 0)
        XCTAssertEqual(GridView<EmptyView, Int>.clampedTotalCount(-1, itemsCount: 10), 0)
        XCTAssertEqual(GridView<EmptyView, Int>.clampedTotalCount(999, itemsCount: 10), 10)
    }
    
    func testGridView_cellSize_calculatesSquareCellWidth() {
        let size = GridView<EmptyView, Int>.cellSize(totalWidth: 300, columns: 3, columnSpacing: 2)
        XCTAssertEqual(size, (300 - 4) / 3, accuracy: 0.0001)
    }
    
    func testGridView_cellSize_returnsZeroForInvalidOrOverconstrainedInputs() {
        XCTAssertEqual(GridView<EmptyView, Int>.cellSize(totalWidth: 0, columns: 3, columnSpacing: 2), 0)
        XCTAssertEqual(GridView<EmptyView, Int>.cellSize(totalWidth: -10, columns: 3, columnSpacing: 2), 0)
        
        // Spacing larger than width should not produce negative sizes.
        XCTAssertEqual(GridView<EmptyView, Int>.cellSize(totalWidth: 10, columns: 3, columnSpacing: 10), 0)
    }
    
    func testScrollGridView_axis_matchesOrientation() {
        XCTAssertEqual(ScrollGridView<EmptyView>.axis(for: .vertical), .vertical)
        XCTAssertEqual(ScrollGridView<EmptyView>.axis(for: .horizontal), .horizontal)
    }
    
    func testScrollGridView_clampedCount_defaultsAndClampsToAtLeastOne() {
        XCTAssertEqual(ScrollGridView<EmptyView>.clampedCount(nil), 1)
        XCTAssertEqual(ScrollGridView<EmptyView>.clampedCount(1), 1)
        XCTAssertEqual(ScrollGridView<EmptyView>.clampedCount(3), 3)
        XCTAssertEqual(ScrollGridView<EmptyView>.clampedCount(0), 1)
        XCTAssertEqual(ScrollGridView<EmptyView>.clampedCount(-10), 1)
    }
    
    func testScrollGridView_gridItemCount_usesColumnsForVerticalRowsForHorizontal() {
        XCTAssertEqual(
            ScrollGridView<EmptyView>.gridItemCount(orientation: .vertical, columns: 4, rows: 99),
            4
        )
        XCTAssertEqual(
            ScrollGridView<EmptyView>.gridItemCount(orientation: .horizontal, columns: 99, rows: 2),
            2
        )
    }
    
    func testScrollGridView_gridItemCount_fallsBackToOneForNilOrInvalidValues() {
        XCTAssertEqual(
            ScrollGridView<EmptyView>.gridItemCount(orientation: .vertical, columns: nil, rows: 5),
            1
        )
        XCTAssertEqual(
            ScrollGridView<EmptyView>.gridItemCount(orientation: .vertical, columns: 0, rows: 5),
            1
        )
        XCTAssertEqual(
            ScrollGridView<EmptyView>.gridItemCount(orientation: .horizontal, columns: 5, rows: nil),
            1
        )
        XCTAssertEqual(
            ScrollGridView<EmptyView>.gridItemCount(orientation: .horizontal, columns: 5, rows: -2),
            1
        )
    }
    
    func testScrollGridView_flexibleGridItems_returnsAtLeastOneItem() {
        XCTAssertEqual(ScrollGridView<EmptyView>.flexibleGridItems(count: 3, spacing: 8).count, 3)
        XCTAssertEqual(ScrollGridView<EmptyView>.flexibleGridItems(count: 1, spacing: 8).count, 1)
        XCTAssertEqual(ScrollGridView<EmptyView>.flexibleGridItems(count: 0, spacing: 8).count, 1)
        XCTAssertEqual(ScrollGridView<EmptyView>.flexibleGridItems(count: -10, spacing: 8).count, 1)
    }
    
    func testTextFieldViewUtil_isErrored_trimsWhitespace() {
        XCTAssertFalse(TextFieldViewUtil<EmptyView>.isErrored(errorText: nil))
        XCTAssertFalse(TextFieldViewUtil<EmptyView>.isErrored(errorText: ""))
        XCTAssertFalse(TextFieldViewUtil<EmptyView>.isErrored(errorText: "   \n\t  "))
        XCTAssertTrue(TextFieldViewUtil<EmptyView>.isErrored(errorText: "Required"))
    }
    
    func testTextFieldViewUtil_messageText_errorTakesPrecedence() {
        XCTAssertEqual(
            TextFieldViewUtil<EmptyView>.messageText(supportingText: "Helper", errorText: nil),
            "Helper"
        )
        XCTAssertEqual(
            TextFieldViewUtil<EmptyView>.messageText(supportingText: "Helper", errorText: "Invalid"),
            "Invalid"
        )
        XCTAssertEqual(
            TextFieldViewUtil<EmptyView>.messageText(supportingText: nil, errorText: nil),
            nil
        )
    }
    
    func testTextFieldViewUtil_borderStyle_priorityOrder() {
        XCTAssertEqual(TextFieldViewUtil<EmptyView>.borderStyle(isErrored: false, isFocused: false), .normal)
        XCTAssertEqual(TextFieldViewUtil<EmptyView>.borderStyle(isErrored: false, isFocused: true), .focused)
        XCTAssertEqual(TextFieldViewUtil<EmptyView>.borderStyle(isErrored: true, isFocused: false), .error)
        XCTAssertEqual(TextFieldViewUtil<EmptyView>.borderStyle(isErrored: true, isFocused: true), .error)
    }
    
    func testTextFieldViewUtil_normalizedIconName_trimsAndNilsEmpty() {
        XCTAssertEqual(TextFieldViewUtil<EmptyView>.normalizedIconName("envelope"), "envelope")
        XCTAssertEqual(TextFieldViewUtil<EmptyView>.normalizedIconName("  lock  "), "lock")
        XCTAssertNil(TextFieldViewUtil<EmptyView>.normalizedIconName(""))
        XCTAssertNil(TextFieldViewUtil<EmptyView>.normalizedIconName("   \n\t  "))
    }
    
    func testButtonViewUtils_accessibilityTitle_isNilForNilOrEmpty() {
        XCTAssertNil(ButtonViewUtils.accessibilityTitle(nil))
        XCTAssertNil(ButtonViewUtils.accessibilityTitle(""))
        XCTAssertEqual(ButtonViewUtils.accessibilityTitle("Save"), "Save")
        
        // Current behavior: whitespace-only titles are considered non-empty.
        XCTAssertEqual(ButtonViewUtils.accessibilityTitle("  "), "  ")
    }
    
    func testButtonViewUtils_shouldInvokeAction_isFalseWhenLoading() {
        XCTAssertTrue(ButtonViewUtils.shouldInvokeAction(isLoading: false))
        XCTAssertFalse(ButtonViewUtils.shouldInvokeAction(isLoading: true))
    }
    
    func testFloatingButtonUtilsView_clampedSize_enforcesMinimumTapTarget() {
        XCTAssertEqual(FloatingButtonUtilsView.clampedSize(56), 56)
        XCTAssertEqual(FloatingButtonUtilsView.clampedSize(44), 44)
        XCTAssertEqual(FloatingButtonUtilsView.clampedSize(10), 44)
        XCTAssertEqual(FloatingButtonUtilsView.clampedSize(-1), 44)
    }
    
    func testFloatingButtonUtilsView_shouldInvokeAction_isFalseWhenLoading() {
        XCTAssertTrue(FloatingButtonUtilsView.shouldInvokeAction(isLoading: false))
        XCTAssertFalse(FloatingButtonUtilsView.shouldInvokeAction(isLoading: true))
    }
    
    func testFloatingButtonUtilsView_contrastForeground_usesLuminanceThreshold() {
        // Bright background -> black foreground
        XCTAssertEqual(FloatingButtonUtilsView.contrastForeground(red: 1, green: 1, blue: 1), .black)
        XCTAssertEqual(FloatingButtonUtilsView.contrastForeground(red: 1, green: 1, blue: 0), .black) // yellow-ish
        
        // Dark background -> white foreground
        XCTAssertEqual(FloatingButtonUtilsView.contrastForeground(red: 0, green: 0, blue: 0), .white)
        XCTAssertEqual(FloatingButtonUtilsView.contrastForeground(red: 0, green: 0, blue: 1), .white) // blue-ish
    }
    
    func testActivityItemUtils_primaryActionKind_prefersTapOverLongPress() {
        XCTAssertEqual(ActivityItemUtils<EmptyView>.primaryActionKind(hasTap: false, hasLongPress: false), .none)
        XCTAssertEqual(ActivityItemUtils<EmptyView>.primaryActionKind(hasTap: true, hasLongPress: false), .tap)
        XCTAssertEqual(ActivityItemUtils<EmptyView>.primaryActionKind(hasTap: false, hasLongPress: true), .longPress)
        XCTAssertEqual(ActivityItemUtils<EmptyView>.primaryActionKind(hasTap: true, hasLongPress: true), .tap)
    }
    
    func testActivityItemUtils_shouldExposeMoreOptions_requiresBothActions() {
        XCTAssertFalse(ActivityItemUtils<EmptyView>.shouldExposeMoreOptions(hasTap: false, hasLongPress: false))
        XCTAssertFalse(ActivityItemUtils<EmptyView>.shouldExposeMoreOptions(hasTap: true, hasLongPress: false))
        XCTAssertFalse(ActivityItemUtils<EmptyView>.shouldExposeMoreOptions(hasTap: false, hasLongPress: true))
        XCTAssertTrue(ActivityItemUtils<EmptyView>.shouldExposeMoreOptions(hasTap: true, hasLongPress: true))
    }
    
    func testActivityItemUtils_arrowRotationDegrees_matchesDirection() {
        XCTAssertEqual(ActivityItemUtils<EmptyView>.arrowRotationDegrees(for: .top), 0)
        XCTAssertEqual(ActivityItemUtils<EmptyView>.arrowRotationDegrees(for: .left), -90)
        XCTAssertEqual(ActivityItemUtils<EmptyView>.arrowRotationDegrees(for: .right), 90)
        XCTAssertEqual(ActivityItemUtils<EmptyView>.arrowRotationDegrees(for: .bottom), 180)
    }
    
    func testActivityItemUtils_arrowOffset_matchesDirection() {
        XCTAssertEqual(ActivityItemUtils<EmptyView>.arrowOffset(for: .top), CGSize(width: 0, height: -8))
        XCTAssertEqual(ActivityItemUtils<EmptyView>.arrowOffset(for: .left), CGSize(width: -10, height: 0))
        XCTAssertEqual(ActivityItemUtils<EmptyView>.arrowOffset(for: .right), CGSize(width: 10, height: 0))
        XCTAssertEqual(ActivityItemUtils<EmptyView>.arrowOffset(for: .bottom), CGSize(width: 0, height: 8))
    }
    
    func testActivityItemUtils_borderWidth_usesIncreasedContrast() {
        XCTAssertEqual(ActivityItemUtils<EmptyView>.borderWidth(increasedContrast: false), 1.0)
        XCTAssertEqual(ActivityItemUtils<EmptyView>.borderWidth(increasedContrast: true), 2.0)
    }
    
    func testSliderControlViewUtils_normalizedBounds_ordersMinAndMax() {
        let bounds1 = SliderControlViewUtils.normalizedBounds(min: 0, max: 10)
        XCTAssertEqual(bounds1.min, 0)
        XCTAssertEqual(bounds1.max, 10)
        
        let bounds2 = SliderControlViewUtils.normalizedBounds(min: 10, max: 0)
        XCTAssertEqual(bounds2.min, 0)
        XCTAssertEqual(bounds2.max, 10)
    }
    
    func testSliderControlViewUtils_clampedValue_clampsToBounds() {
        XCTAssertEqual(SliderControlViewUtils.clampedValue(-1, min: 0, max: 10), 0)
        XCTAssertEqual(SliderControlViewUtils.clampedValue(0, min: 0, max: 10), 0)
        XCTAssertEqual(SliderControlViewUtils.clampedValue(4.5, min: 0, max: 10), 4.5)
        XCTAssertEqual(SliderControlViewUtils.clampedValue(10, min: 0, max: 10), 10)
        XCTAssertEqual(SliderControlViewUtils.clampedValue(999, min: 0, max: 10), 10)
    }
    
    func testSliderControlViewUtils_defaultValueText_formatsIntegersAndDecimals() {
        XCTAssertEqual(SliderControlViewUtils.defaultValueText(5.0), "5")
        XCTAssertEqual(SliderControlViewUtils.defaultValueText(-3.0), "-3")
        XCTAssertEqual(SliderControlViewUtils.defaultValueText(5.125), "5.12")
        XCTAssertEqual(SliderControlViewUtils.defaultValueText(5.129), "5.13")
    }
    
    func testSliderControlViewUtils_incrementDecrementValues_respectBounds() {
        XCTAssertEqual(SliderControlViewUtils.decrementValue(current: 0, min: 0, max: 10, step: 1), 0)
        XCTAssertEqual(SliderControlViewUtils.decrementValue(current: 5, min: 0, max: 10, step: 1), 4)
        XCTAssertEqual(SliderControlViewUtils.incrementValue(current: 10, min: 0, max: 10, step: 1), 10)
        XCTAssertEqual(SliderControlViewUtils.incrementValue(current: 9.5, min: 0, max: 10, step: 1), 10)
    }
    
    func testStepperViewUtils_normalizedBounds_ordersMinAndMax() {
        let bounds1 = StepperViewUtils.normalizedBounds(min: 0, max: 10)
        XCTAssertEqual(bounds1.min, 0)
        XCTAssertEqual(bounds1.max, 10)
        
        let bounds2 = StepperViewUtils.normalizedBounds(min: 10, max: 0)
        XCTAssertEqual(bounds2.min, 0)
        XCTAssertEqual(bounds2.max, 10)
    }
    
    func testStepperViewUtils_normalizedStep_clampsToAtLeastOne() {
        XCTAssertEqual(StepperViewUtils.normalizedStep(3), 3)
        XCTAssertEqual(StepperViewUtils.normalizedStep(1), 1)
        XCTAssertEqual(StepperViewUtils.normalizedStep(0), 1)
        XCTAssertEqual(StepperViewUtils.normalizedStep(-10), 1)
    }
    
    func testStepperViewUtils_clampedValue_clampsToBounds() {
        XCTAssertEqual(StepperViewUtils.clampedValue(-1, min: 0, max: 10), 0)
        XCTAssertEqual(StepperViewUtils.clampedValue(0, min: 0, max: 10), 0)
        XCTAssertEqual(StepperViewUtils.clampedValue(5, min: 0, max: 10), 5)
        XCTAssertEqual(StepperViewUtils.clampedValue(10, min: 0, max: 10), 10)
        XCTAssertEqual(StepperViewUtils.clampedValue(999, min: 0, max: 10), 10)
    }
    
    func testStepperViewUtils_incrementDecrementValues_respectBoundsAndStepNormalization() {
        XCTAssertEqual(StepperViewUtils.decrementValue(current: 0, min: 0, max: 10, step: 1), 0)
        XCTAssertEqual(StepperViewUtils.decrementValue(current: 5, min: 0, max: 10, step: 1), 4)
        XCTAssertEqual(StepperViewUtils.incrementValue(current: 10, min: 0, max: 10, step: 1), 10)
        XCTAssertEqual(StepperViewUtils.incrementValue(current: 9, min: 0, max: 10, step: 2), 10)
        
        // Step normalization: non-positive step behaves like 1
        XCTAssertEqual(StepperViewUtils.incrementValue(current: 0, min: 0, max: 10, step: 0), 1)
        XCTAssertEqual(StepperViewUtils.decrementValue(current: 5, min: 0, max: 10, step: -1), 4)
    }
    
    func testPickerViewUtils_normalizedTitleKey_isNilWhenEmpty() {
        XCTAssertNil(PickerViewUtils<String>.normalizedTitleKey(""))
        XCTAssertNotNil(PickerViewUtils<String>.normalizedTitleKey("Transport"))
    }
    
    func testDatePickerViewUtils_valueLineText_formatsPrefixAndValue() {
        XCTAssertEqual(DatePickerViewUtils.valueLineText(valuePrefix: nil, valueText: "June 1, 2026"), "June 1, 2026")
        XCTAssertEqual(DatePickerViewUtils.valueLineText(valuePrefix: "Selected:", valueText: "June 1, 2026"), "Selected: June 1, 2026")
        XCTAssertEqual(DatePickerViewUtils.valueLineText(valuePrefix: "", valueText: "June 1, 2026"), " June 1, 2026")
    }
}
