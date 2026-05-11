//
//  SquareGridView.swift
//  Utils
//
//  Created by Israel Manzo on 4/5/25.
//

import SwiftUI

@available(*, deprecated, renamed: "GridView")
public typealias SquareGridView<Content: View, Item: Hashable> = GridView<Content, Item>

/// A vertically scrolling grid where each cell is sized to be a square.
///
/// This view calculates the cell size from the available width and the provided
/// number of `columns`, then uses a `LazyVGrid` with fixed-size columns so
/// each item renders in a square.
public struct GridView<Content: View, Item: Hashable>: View {
    // MARK: - Configuration
    private let items: [Item]
    private let totalCount: Int
    private let columns: Int
    private let columnSpacing: CGFloat
    private let rowSpacing: CGFloat
    private let showsIndicators: Bool
    private let buildItem: (Item) -> Content
    
    public init(
        items: [Item],
        totalCount: Int,
        columns: Int = 3,
        columnSpacing: CGFloat = 2,
        rowSpacing: CGFloat = 2,
        showsIndicators: Bool = false,
        @ViewBuilder content: @escaping (Item) -> Content
    ) {
        self.items = items
        self.totalCount = totalCount
        self.columns = max(columns, 1)
        self.columnSpacing = columnSpacing
        self.rowSpacing = rowSpacing
        self.showsIndicators = showsIndicators
        self.buildItem = content
    }
    
    private func fixedColumns(cellSize: CGFloat) -> [GridItem] {
        Array(
            repeating: GridItem(.fixed(cellSize), spacing: columnSpacing),
            count: columns
        )
    }
    
    public var body: some View {
        GeometryReader { proxy in
            let totalSpacing = CGFloat(max(columns - 1, 0)) * columnSpacing
            let cellSize = (proxy.size.width - totalSpacing) / CGFloat(columns)
            
            ScrollView(.vertical, showsIndicators: showsIndicators) {
                LazyVGrid(columns: fixedColumns(cellSize: cellSize), spacing: rowSpacing) {
                    ForEach(items.prefix(totalCount), id: \.self) { item in
                        buildItem(item)
                            .frame(width: cellSize, height: cellSize)
                    }
                }
            }
        }
    }
}

#if DEBUG
// MARK: - Sample usage
struct GridViewSampleView: View {
    private let items = Array(0..<120)
    
    @State private var columns: Int = 3
    @State private var columnSpacing: CGFloat = 2
    @State private var rowSpacing: CGFloat = 2
    @State private var showsIndicators: Bool = false
    @State private var totalCount: Int = 30
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("GridView (square cells)")
                .font(.title3.weight(.semibold))
            
            VStack(alignment: .leading, spacing: 10) {
                Stepper("Columns: \(columns)", value: $columns, in: 1...8)
                Stepper("Items: \(totalCount)", value: $totalCount, in: 0...items.count)
                
                HStack {
                    Text("Column spacing")
                    Slider(value: $columnSpacing, in: 0...16, step: 1)
                    Text("\(Int(columnSpacing))")
                        .monospacedDigit()
                        .frame(width: 28, alignment: .trailing)
                }
                
                HStack {
                    Text("Row spacing")
                    Slider(value: $rowSpacing, in: 0...16, step: 1)
                    Text("\(Int(rowSpacing))")
                        .monospacedDigit()
                        .frame(width: 28, alignment: .trailing)
                }
                
                Toggle("Show scroll indicators", isOn: $showsIndicators)
            }
            
            Divider()
            
            GridView(
                items: items,
                totalCount: totalCount,
                columns: columns,
                columnSpacing: columnSpacing,
                rowSpacing: rowSpacing,
                showsIndicators: showsIndicators
            ) { item in
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(hue: Double(item % 12) / 12.0, saturation: 0.25, brightness: 0.95))
                    .overlay {
                        Text("\(item)")
                            .font(.headline)
                            .foregroundStyle(.primary)
                    }
            }
            .background(Color.secondary.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding()
    }
}

struct GridViewSampleView_Previews: PreviewProvider {
    static var previews: some View {
        GridViewSampleView()
    }
}
#endif
