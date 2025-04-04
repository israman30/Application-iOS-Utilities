//
//  GridView.swift
//  Utils
//
//  Created by Israel Manzo on 12/30/23.
//

import SwiftUI

enum GridOrientation {
    case vertical
    case horizontal
}

public struct GridView<Content: View>: View {
    
    var orientation: GridOrientation = .vertical
    let columns: Int?
    let rows: Int?
    let content: () -> Content
    
    var adaptiveColumns: [GridItem] {
        Array(repeating: GridItem(.flexible()), count: columns ?? 1)
    }
    
    var adaptiveRows: [GridItem] {
        Array(repeating: GridItem(.flexible()), count: rows ?? 1)
    }
    
    public var body: some View {
        if orientation == .vertical {
            ScrollView(.vertical) {
                LazyVGrid(columns: adaptiveColumns) {
                    content()
                }
            }
        } else {
            ScrollView(.horizontal) {
                LazyHGrid(rows: adaptiveRows) {
                    content()
                }
            }
        }
    }
    
    init(_ orientation: GridOrientation = .vertical,
        columns: Int? = nil,
        rows: Int? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.orientation = orientation
        self.columns = columns
        self.content = content
        self.rows = rows
    }
}

struct GridViewDisplay: View {
    var body: some View {
        GridView(columns: 2) {
            ForEach(0..<10) { index in
                Text("View: \(index)")
            }
        }
        
        GridView(.horizontal, rows: 3) {
            HStack {
                Text("View")
                Text("View")
                Text("View")
            }
        }
    }
}

#Preview {
    GridViewDisplay()
}
