//
//  HeartLikeView.swift
//  Utils
//
//  Created by Israel Manzo on 12/30/23.
//

import SwiftUI

/// Sample usage for `HeartLikeView`.
///
/// This is a small, copy/paste-friendly example that demonstrates how to:
/// - Keep `isLiked` as local state
/// - Bind it into `HeartLikeView`
/// - React to changes in the binding (e.g. show “Liked” / “Not liked”)
struct HeartLikeSampleView: View {
    @State private var isLiked = false
    
    var body: some View {
        VStack(spacing: 16) {
            HeartLikeView(isLiked: $isLiked)
            
            Text(isLiked ? "Liked" : "Not liked")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

/// A tappable “like” heart that animates both **shape** and **color** when toggled.
///
/// ## Usage
/// Provide a binding that represents the current liked state.
///
/// Example:
/// ```swift
/// @State private var isLiked = false
///
/// var body: some View {
///     HeartLikeView(isLiked: $isLiked)
/// }
/// ```
///
/// ## Implementation notes
/// - Uses SF Symbols `"heart"` / `"heart.fill"` and switches between them based on `isLiked`.
/// - The `isLiked` toggle is performed inside `withAnimation(...)` so the foreground color
///   transition (gray ↔︎ red) animates rather than snapping.
/// - A brief scale “pulse” is driven by `isAnimating` and then reset after `animationDuration`.
public struct HeartLikeView: View {
    
    @Binding var isLiked: Bool
    
    private let animationDuration: Double = 0.12
    
    static func animationScale(isLiked: Bool) -> CGFloat {
        isLiked ? 1.3 : 0.7
    }
    
    static func symbolName(isLiked: Bool) -> String {
        isLiked ? "heart.fill" : "heart"
    }
    
    @State private var isAnimating = false
    
    public var body: some View {
        Button {
            self.executeButtonAnimation()
        } label: {
            VStack {
                Image(systemName: Self.symbolName(isLiked: isLiked))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .foregroundStyle(isLiked ? .red : .gray)
                    .contentTransition(.symbolEffect(.replace))
            }
            .scaleEffect(isAnimating ? Self.animationScale(isLiked: isLiked) : 1)
        }
        .buttonStyle(.plain)
    }
    
    private func executeButtonAnimation() {
        withAnimation(.easeInOut(duration: animationDuration)) {
            isLiked.toggle()
            isAnimating = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
            withAnimation(.easeInOut(duration: animationDuration)) {
                isAnimating = false
            }
        }
    }
}

#if DEBUG
struct HeartLikeView_Previews: PreviewProvider {
    static var previews: some View {
        HeartLikeSampleView()
    }
}
#endif
