//
//  SquareGridView.swift
//  Utils
//
//  Created by Israel Manzo on 4/5/25.
//

import SwiftUI

struct SquareGridView<Content: View, Item: Hashable>: View {
    var items: [Item]
    var columns: Int = 3
    var columnSpacing: CGFloat = 2
    var rowSpacing: CGFloat = 2
    
    let buildItem: (Item) -> Content
    
    var body: some View {
        GeometryReader { proxy in
            let cellSize: CGFloat = proxy.size.width / CGFloat(columns)
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: .init(repeating:  GridItem(.fixed(cellSize), spacing: columnSpacing), count: columns), spacing: rowSpacing) {
                    ForEach(items, id: \.self) { item in
                        buildItem(item)
                            .frame(height: cellSize)
                    }
                }
            }
        }
    }
}
