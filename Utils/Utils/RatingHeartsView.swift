//
//  RatingHeartsView.swift
//  Utils
//
//  Created by Israel Manzo on 12/30/23.
//

import SwiftUI

/// Sample usage for `RatingHeartsView`.
///
/// This view demonstrates how to bind a numeric value (0…5) to the component
/// using a `Stepper`, which is a common pattern in real apps (forms/settings).
struct RatingHeartsSampleView: View {
    @State private var rating: Double = 3.5
    private let maxRating: Int = 5
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Rating")
                    .font(.headline)
                
                RatingHeartsView(rating: CGFloat(rating), maxRating: maxRating)
                    .frame(height: 28)
                
                RatingHeartsView(
                    rating: CGFloat(rating),
                    maxRating: maxRating,
                    color: .orange,
                    backgroundColor: Color(.systemGray3)
                )
                .frame(height: 28)
                
                Text("\(rating, specifier: "%.1f") / \(maxRating)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Stepper(value: $rating, in: 0...Double(maxRating), step: 0.5) {
                Text("Adjust rating")
            }
        }
        .padding()
    }
}

/// A partial-fill rating view based on SF Symbols hearts.
///
/// **Implementation details**
/// - Draws a row of gray hearts.
/// - Overlays a colored rectangle whose width is proportional to the rating.
/// - Masks that rectangle with the heart shapes so only the heart area is filled.
///
/// **Usage**
/// - Pass a `rating` between `0` and `maxRating`.
/// - Control sizing using standard SwiftUI layout (e.g. set a fixed height).
///
/// Example:
/// `RatingHeartsView(rating: 3.5, maxRating: 5).frame(height: 28)`
public struct RatingHeartsView: View {
    /// Current rating value. Values outside `0...maxRating` are clamped for rendering.
    private let rating: CGFloat
    /// Maximum number of hearts to display (commonly 5).
    private let maxRating: Int
    
    /// SF Symbol used to draw each heart.
    /// - Note: Defaults to `"heart.fill"`. Keep it as a filled symbol so masking looks correct.
    private var heartIcon: String = "heart.fill"
    
    /// Foreground fill color for the “filled” portion of the rating.
    private var heartColor: Color = .red
    
    /// Color used for the unfilled hearts behind the overlay.
    private var backgroundColor: Color = .gray
    
    /// Creates a heart rating view.
    /// - Parameters:
    ///   - rating: The current rating (typically \(0...maxRating\)).
    ///   - maxRating: Total number of hearts to draw.
    ///   - color: Fill color for the rated portion of the hearts.
    ///   - backgroundColor: Color of the unfilled hearts.
    public init(
        rating: CGFloat,
        maxRating: Int,
        color: Color = .red,
        backgroundColor: Color = .gray
    ) {
        self.rating = rating
        self.maxRating = maxRating
        self.heartColor = color
        self.backgroundColor = backgroundColor
    }

    /// Non-negative number of hearts to draw.
    ///
    /// `maxRating` is expected to be positive, but we defensively handle unexpected values.
    var heartCount: Int {
        max(0, maxRating)
    }
    
    static func clampedRating(_ rating: CGFloat, maxRating: Int) -> CGFloat {
        let upper = CGFloat(max(0, maxRating))
        return min(max(rating, 0), upper)
    }
    
    static func fillWidth(rating: CGFloat, maxRating: Int, totalWidth: CGFloat) -> CGFloat {
        guard maxRating > 0, totalWidth > 0 else { return 0 }
        let clamped = clampedRating(rating, maxRating: maxRating)
        return clamped / CGFloat(maxRating) * totalWidth
    }
    
    public var body: some View {
        hearts
            .overlay(
            GeometryReader {
                // Convert the rating (0...maxRating) into a width fraction of the heart row.
                let width = Self.fillWidth(rating: rating, maxRating: maxRating, totalWidth: $0.size.width)
                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(width: width)
                        .foregroundColor(heartColor)
                }
            }
            .mask(hearts)
        )
        .foregroundColor(backgroundColor)
    }
    
    /// Heart silhouettes used both for drawing and masking.
    private var hearts: some View {
        HStack(spacing: 0) {
           ForEach(0..<heartCount, id: \.self) { _ in
               Image(systemName: heartIcon)
                   .resizable()
                   .aspectRatio(contentMode: .fit)
           }
       }
    }
}

#if DEBUG
struct RatingHeartsView_Previews: PreviewProvider {
    static var previews: some View {
        RatingHeartsSampleView()
    }
}
#endif
