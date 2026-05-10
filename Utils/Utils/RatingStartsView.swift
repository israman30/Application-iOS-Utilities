//
//  RatingStartsView.swift
//  Utils
//
//  Created by Israel Manzo on 12/30/23.
//

import SwiftUI

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

public struct RatingStarsView: View {
    private let rating: CGFloat
    private let maxRating: Int

    public init(rating: CGFloat, maxRating: Int) {
        self.rating = rating
        self.maxRating = maxRating
    }

    public var body: some View {
        stars
            .overlay(
            GeometryReader {
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
