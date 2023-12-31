//
//  GridView.swift
//  Utils
//
//  Created by Israel Manzo on 12/30/23.
//

import SwiftUI

public struct GridView<Content: View>: View {
    
    let columns: Int
    let content: () -> Content
    
    var adaptiveColumns: [GridItem] {
        Array(repeating: GridItem(.flexible()), count: columns)
    }
    
    public var body: some View {
        ScrollView {
            LazyVGrid(columns: adaptiveColumns) {
                content()
            }
        }
    }
    
    init(columns: Int, @ViewBuilder content: @escaping () -> Content) {
        self.columns = columns
        self.content = content
    }
}

struct GridViewDisplay: View {
    var body: some View {
        GridView(columns: 2) {
            ForEach(0..<10) { index in
                Text("View: \(index)")
            }
        }
    }
}

#Preview {
    GridViewDisplay()
}
