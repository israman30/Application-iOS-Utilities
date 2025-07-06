//
//  SquareGridView.swift
//  Utils
//
//  Created by Israel Manzo on 4/5/25.
//

import SwiftUI

public struct SquareGridView<Content: View, Item: Hashable>: View {
    var items: [Item]
    var totalCount: Int
    var columns: Int = 3
    var columnSpacing: CGFloat = 2
    var rowSpacing: CGFloat = 2
    var showsIndicators: Bool = false
    
    let buildItem: (Item) -> Content
    
    func adaptiveColumns(_ cellSize: CGFloat) -> [GridItem] {
        .init(repeating:  GridItem(.fixed(cellSize), spacing: columnSpacing), count: columns)
    }
    
    public var body: some View {
        GeometryReader { proxy in
            let cellSize: CGFloat = proxy.size.width / CGFloat(columns)
            ScrollView(.vertical, showsIndicators: showsIndicators) {
                LazyVGrid(
                    columns: adaptiveColumns(cellSize),
                    spacing: rowSpacing
                ) {
                    ForEach(items, id: \.self) { item in
                        buildItem(item)
                            .frame(height: cellSize)
                    }
                }
            }
        }
    }
}

@MainActor
class SomeModel: ObservableObject {
    @Published var characters: [Character] = []
    @Published var totalCount: Int = 50
    
    func loadMoreCharacters() {
        let newCharacters = Array("ABCDEFGHIJKLMOPQRSTUVWXYZ")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.characters = newCharacters
            self.totalCount += newCharacters.count
        }
    }
}

// MARK: - Usage View
struct GridTextView: View {
    @StateObject var model = SomeModel()
    var body: some View {
        SquareGridView(items: model.characters, totalCount: model.totalCount, columns: 3, columnSpacing: 2, rowSpacing: 2) { item in
                Text("Item: \(item)")
            }
            .onAppear {
                model.loadMoreCharacters()
            }
    }
}

#Preview(body: {
    GridTextView()
})
