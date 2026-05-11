//
//  GridView.swift
//  Utils
//
//  Created by Israel Manzo on 12/30/23.
//

import SwiftUI

/// Controls which axis the grid scrolls on and which lazy grid type is used.
///
/// - **vertical**: Uses `LazyVGrid` inside a vertical `ScrollView`. Configure `columns`.
/// - **horizontal**: Uses `LazyHGrid` inside a horizontal `ScrollView`. Configure `rows`.
public enum GridOrientation: Hashable {
    case vertical
    case horizontal
}

/// A lightweight wrapper around `LazyVGrid` / `LazyHGrid` that provides a consistent API
/// and embeds the grid in the appropriate `ScrollView`.
///
/// This component is best when you want:
/// - A scrollable grid (vertical or horizontal)
/// - Simple configuration via a fixed number of columns/rows
/// - Lazy rendering for large datasets
///
/// Prefer this component over `GridView` when you **don’t** need square cells and you want:
/// - `.flexible()` grid items that naturally size to their content
/// - Horizontal grids (`LazyHGrid`)
public struct ScrollGridView<Content: View>: View {
    
    // MARK: - Configuration
    private let orientation: GridOrientation
    private let columns: Int?
    private let rows: Int?
    private let spacing: CGFloat
    private let showsIndicators: Bool
    private let content: () -> Content
    
    // MARK: - Internal
    private var axis: Axis.Set {
        orientation == .vertical ? .vertical : .horizontal
    }
    
    private var adaptiveColumns: [GridItem] {
        // Using `.flexible()` keeps this layout generic: cell size is driven by available space
        // and the content itself, rather than enforcing a square aspect ratio.
        Array(
            repeating: GridItem(.flexible(), spacing: spacing),
            count: max(columns ?? 1, 1)
        )
    }
    
    private var adaptiveRows: [GridItem] {
        Array(
            repeating: GridItem(.flexible(), spacing: spacing),
            count: max(rows ?? 1, 1)
        )
    }
    
    @ViewBuilder
    public var body: some View {
        ScrollView(axis, showsIndicators: showsIndicators) {
            if orientation == .vertical {
                LazyVGrid(columns: adaptiveColumns, spacing: spacing) {
                    content()
                }
            } else {
                LazyHGrid(rows: adaptiveRows, spacing: spacing) {
                    content()
                }
            }
        }
    }
    
    /// Creates a scrollable grid with a fixed number of columns (vertical) or rows (horizontal).
    ///
    /// - Parameters:
    ///   - orientation: Whether the grid scrolls vertically (`LazyVGrid`) or horizontally (`LazyHGrid`).
    ///   - columns: Number of columns for a **vertical** grid. If `nil`, defaults to 1.
    ///   - rows: Number of rows for a **horizontal** grid. If `nil`, defaults to 1.
    ///   - spacing: Spacing between items in the grid.
    ///   - showsIndicators: Whether the enclosing `ScrollView` shows scroll indicators.
    ///   - content: The grid content. Typically a `ForEach` of your data, returning cells.
    ///
    /// Notes:
    /// - If `columns`/`rows` are less than 1, the grid falls back to 1 to avoid invalid layouts.
    /// - If you pass both `columns` and `rows`, only the one matching `orientation` is used.
    public init(
        _ orientation: GridOrientation = .vertical,
        columns: Int? = nil,
        rows: Int? = nil,
        spacing: CGFloat = 8,
        showsIndicators: Bool = false,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.orientation = orientation
        self.columns = columns
        self.rows = rows
        self.spacing = spacing
        self.showsIndicators = showsIndicators
        self.content = content
    }
}

// MARK: - Usage
/// A small, interactive view that demonstrates how to use `ScrollGridView`.
///
/// This is meant for previews / manual QA:
/// - Switch orientation to see `LazyVGrid` vs `LazyHGrid`
/// - Adjust `columns`/`rows`, `spacing`, and scroll indicators
/// - Uses simple colored cells to make layout behavior obvious at a glance
struct ScrollGridViewSampleView: View {
    private let items = Array(1...30)
    private let cellSize: CGFloat = 72
    
    @State private var orientation: GridOrientation = .vertical
    @State private var columns: Int = 3
    @State private var rows: Int = 2
    @State private var spacing: CGFloat = 8
    @State private var showsIndicators: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("ScrollGridView")
                .font(.title2.weight(.semibold))
            
            VStack(alignment: .leading, spacing: 12) {
                // The sample exposes the knobs you typically tweak when tuning a grid layout.
                Picker("Orientation", selection: $orientation) {
                    Text("Vertical").tag(GridOrientation.vertical)
                    Text("Horizontal").tag(GridOrientation.horizontal)
                }
                .pickerStyle(.segmented)
                
                HStack(spacing: 12) {
                    Stepper("Columns: \(columns)", value: $columns, in: 1...6)
                        .opacity(orientation == .vertical ? 1 : 0.4)
                        .disabled(orientation != .vertical)
                    
                    Stepper("Rows: \(rows)", value: $rows, in: 1...6)
                        .opacity(orientation == .horizontal ? 1 : 0.4)
                        .disabled(orientation != .horizontal)
                }
                
                HStack {
                    Text("Spacing")
                    Slider(value: $spacing, in: 0...24, step: 1)
                    Text("\(Int(spacing))")
                        .monospacedDigit()
                        .frame(width: 32, alignment: .trailing)
                }
                
                Toggle("Show scroll indicators", isOn: $showsIndicators)
            }
            
            Divider()
            
            ScrollGridView(
                orientation,
                columns: orientation == .vertical ? columns : nil,
                rows: orientation == .horizontal ? rows : nil,
                spacing: spacing,
                showsIndicators: showsIndicators
            ) {
                // Typical usage: drive the grid with a `ForEach` over your data source.
                ForEach(items, id: \.self) { item in
                    gridCell(item)
                }
            }
            .frame(height: previewHeight)
            .background(Color.secondary.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding()
    }
    
    /// Gives the demo a stable height so it behaves like a "component preview"
    /// rather than expanding to fill all available space.
    private var previewHeight: CGFloat {
        if orientation == .vertical {
            return 320
        }
        return CGFloat(rows) * cellSize + CGFloat(max(rows - 1, 0)) * spacing + 24
    }
    
    /// A simple square cell used by the sample view.
    private func gridCell(_ item: Int) -> some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color(hue: Double(item % 12) / 12.0, saturation: 0.35, brightness: 0.95))
            .overlay {
                VStack(spacing: 6) {
                    Text("#\(item)")
                        .font(.headline)
                    Text("Tap target")
                        .font(.caption)
                        .opacity(0.75)
                }
                .foregroundStyle(.primary)
            }
            .frame(width: orientation == .horizontal ? cellSize : nil, height: cellSize)
    }
}

#if DEBUG
struct ScrollGridViewSampleView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollGridViewSampleView()
    }
}
#endif
