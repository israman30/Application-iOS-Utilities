//
//  GridView.swift
//  Utils
//
//  Created by Israel Manzo on 12/30/23.
//

import SwiftUI

public enum GridOrientation: Hashable {
    case vertical
    case horizontal
}

public struct GridView<Content: View>: View {
    
    private let orientation: GridOrientation
    private let columns: Int?
    private let rows: Int?
    private let spacing: CGFloat
    private let showsIndicators: Bool
    private let content: () -> Content
    
    private var axis: Axis.Set {
        orientation == .vertical ? .vertical : .horizontal
    }
    
    private var adaptiveColumns: [GridItem] {
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

struct GridViewSampleView: View {
    private let items = Array(1...30)
    private let cellSize: CGFloat = 72
    
    @State private var orientation: GridOrientation = .vertical
    @State private var columns: Int = 3
    @State private var rows: Int = 2
    @State private var spacing: CGFloat = 8
    @State private var showsIndicators: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("GridView")
                .font(.title2.weight(.semibold))
            
            VStack(alignment: .leading, spacing: 12) {
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
            
            GridView(
                orientation,
                columns: orientation == .vertical ? columns : nil,
                rows: orientation == .horizontal ? rows : nil,
                spacing: spacing,
                showsIndicators: showsIndicators
            ) {
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
    
    private var previewHeight: CGFloat {
        if orientation == .vertical {
            return 320
        }
        return CGFloat(rows) * cellSize + CGFloat(max(rows - 1, 0)) * spacing + 24
    }
    
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
struct GridViewSampleView_Previews: PreviewProvider {
    static var previews: some View {
        GridViewSampleView()
    }
}
#endif
