//
//  RatingStartsView.swift
//  Utils
//
//  Created by Israel Manzo on 12/30/23.
//

import SwiftUI

/// Sample usage for `RatingStarsView`.
///
/// This view demonstrates how to bind a numeric value (0…5) to the component
/// using a `Stepper`, which is a common pattern in real apps (forms/settings).
struct RatingStarsSampleView: View {
    @State private var rating: Double = 3.5
    private let maxRating: Int = 5
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Rating")
                    .font(.headline)
                
                RatingStarsView(rating: CGFloat(rating), maxRating: maxRating)
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

/// A partial-fill rating view based on SF Symbols stars.
///
/// **Implementation details**
/// - Draws a row of gray stars.
/// - Overlays a colored rectangle whose width is proportional to the rating.
/// - Masks that rectangle with the star shapes so only the star area is filled.
///
/// **Usage**
/// - Pass a `rating` between `0` and `maxRating`.
/// - Control sizing using standard SwiftUI layout (e.g. set a fixed height).
///
/// Example:
/// `RatingStarsView(rating: 3.5, maxRating: 5).frame(height: 28)`
public struct RatingStarsView: View {
    /// Current rating value. Values outside `0...maxRating` will still render,
    /// but for predictable results you should clamp the input before passing it.
    private let rating: CGFloat
    /// Maximum number of stars to display (commonly 5).
    private let maxRating: Int

    /// Creates a star rating view.
    /// - Parameters:
    ///   - rating: The current rating (typically \(0...maxRating\)).
    ///   - maxRating: Total number of stars to draw.
    public init(rating: CGFloat, maxRating: Int) {
        self.rating = rating
        self.maxRating = maxRating
    }

    public var body: some View {
        stars
            .overlay(
            GeometryReader {
                // Convert the rating (0...maxRating) into a width fraction of the star row.
                let width = rating / CGFloat(maxRating) * $0.size.width
                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(width: width)
                        .foregroundColor(.yellow)
                }
            }
            .mask(stars)
        )
        .foregroundColor(.gray)
    }
    
    /// Star silhouettes used both for drawing and masking.
    var stars: some View {
        HStack(spacing: 0) {
           ForEach(0..<maxRating, id: \.self) { _ in
               Image(systemName: "star.fill")
                   .resizable()
                   .aspectRatio(contentMode: .fit)
           }
       }
    }
}

#if DEBUG
struct RatingStarsView_Previews: PreviewProvider {
    static var previews: some View {
        RatingStarsSampleView()
    }
}
#endif
