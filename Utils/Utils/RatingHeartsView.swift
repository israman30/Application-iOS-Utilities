//
//  RatingHeartsView.swift
//  Utils
//
//  Created by Israel Manzo on 12/30/23.
//

import SwiftUI

struct RatingHeartsView: View {
    var rating: CGFloat
    var maxRating: Int

    var body: some View {
        hearts
            .overlay(
            GeometryReader {
                let width = rating / CGFloat(maxRating) * $0.size.width
                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(width: width)
                        .foregroundColor(.red)
                }
            }
            .mask(hearts)
        )
        .foregroundColor(.gray)
    }
    
    var hearts: some View {
        HStack(spacing: 0) {
           ForEach(0..<maxRating, id: \.self) { _ in
               Image(systemName: "heart.fill")
                   .resizable()
                   .aspectRatio(contentMode: .fit)
           }
       }
    }
}

#Preview {
    RatingHeartsView(rating: 1.5, maxRating: 5)
}
