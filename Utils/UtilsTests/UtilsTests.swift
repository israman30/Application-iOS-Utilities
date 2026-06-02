//
//  UtilsTests.swift
//  UtilsTests
//
//  Created by Israel Manzo on 12/30/23.
//

import XCTest
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
}
