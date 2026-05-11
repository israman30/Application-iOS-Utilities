//
//  SquareGridView.swift
//  Utils
//
//  Created by Israel Manzo on 4/5/25.
//

import SwiftUI

/// Backwards-compatible alias for the old name.
///
/// Prefer using `GridView` directly.
@available(*, deprecated, renamed: "GridView")
public typealias SquareGridView<Content: View, Item: Hashable> = GridView<Content, Item>

/// A vertically scrolling grid where each cell is sized to be a square.
///
/// This view calculates the cell size from the available width and the provided
/// number of `columns`, then uses a `LazyVGrid` with fixed-size columns so
/// each item renders in a square.
///
/// Use this component when:
/// - Your grid scrolls vertically
/// - Cells should be square (e.g. photo thumbnails, icon pickers)
/// - You want simple "N columns" configuration
public struct GridView<Content: View, Item: Hashable>: View {
    // MARK: - Configuration
    private let items: [Item]
    private let totalCount: Int
    private let columns: Int
    private let columnSpacing: CGFloat
    private let rowSpacing: CGFloat
    private let showsIndicators: Bool
    private let buildItem: (Item) -> Content
    
    /// Creates a square-celled vertical grid.
    ///
    /// - Parameters:
    ///   - items: The backing data source.
    ///   - totalCount: Limits how many items render from `items`. This is useful when you’re
    ///     incrementally revealing items (pagination / “load more”), without reallocating arrays.
    ///   - columns: Number of columns to display. Values < 1 are clamped to 1.
    ///   - columnSpacing: Horizontal spacing between columns.
    ///   - rowSpacing: Vertical spacing between rows.
    ///   - showsIndicators: Whether the `ScrollView` shows scroll indicators.
    ///   - content: A view builder that produces a cell for an item.
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
            // `LazyVGrid` spacing is separate from the column widths.
            // To keep cells square, we subtract the total *inter-column* spacing before dividing.
            let totalSpacing = CGFloat(max(columns - 1, 0)) * columnSpacing
            let cellSize = (proxy.size.width - totalSpacing) / CGFloat(columns)
            
            ScrollView(.vertical, showsIndicators: showsIndicators) {
                LazyVGrid(columns: fixedColumns(cellSize: cellSize), spacing: rowSpacing) {
                    // Render only the first `totalCount` items (useful for progressive loading).
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
/// A small, interactive view that demonstrates how to use `GridView`.
///
/// This is meant for previews / manual QA:
/// - Adjust the number of columns and see cells stay perfectly square
/// - Adjust spacing and see how it affects cell size
/// - Adjust `totalCount` to simulate incremental rendering (“load more”)
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
                // These controls just tweak the grid configuration live.
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
