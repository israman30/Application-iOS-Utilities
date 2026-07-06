//
//  SwiftUIView.swift
//  Utils
//
//  Created by Israel Manzo on 7/2/26.
//

import SwiftUI

// MARK: - Toolbar Item Placement
enum ToolbarPlacement {
    case navigationBarLeading
    case navigationBarTrailing
    case bottomBar
    case keyboard
    case status
}

// MARK: - Toolbar Button Style
enum ToolbarButtonStyle {
    case icon
    case text
    case iconAndText
    case custom
}
/// `ToolbarView Sample Usage`
struct ListUsage: View {
    @State var isEditing = false
    @State var searchText = ""
    var body: some View {
        NavigationStack {
            List(0..<10) {
                Text("\($0)")
            }
            .navigationTitle("List")
            .toolbar {
                ToolbarItems.addButton {
                    print("Add")
                }
                
                ToolbarEditToggle(placemnet: .navigationBarLeading, isEditing: $isEditing)
                ToolbarSearchField(.navigationBarTrailing, searchText: $searchText)
            }
        }
    }
}
/// `Detail View`
struct DetailView: View {
    @State var isFavorite = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("John Doe")
                    .font(.title)
                Text("The coolest man I know in the city..")
                    .font(.body)
            }
            .navigationTitle("Detail View")
            .toolbar {
                ToolbarItems.backButton {
                    dismiss()
                }
                
                ToolbarItems.moreMenu {
                    Button("Share") {  }
                    Button("Link") {  }
                    Button("Copy") {  }
                    Divider()
                    Button("Dimiss", role: .destructive) { }
                }
            }
        }
    }
}

struct EditorView: View {
    @State var text = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            TextEditor(text: $text)
                .navigationTitle("Editor")
                .toolbar {
                    ToolbarButton(.navigationBarLeading, icon: "", label: "Cancel") {
                        dismiss()
                    }
                    
                    ToolbarItems.saveButton(isEnabled: !text.isEmpty) {
                        print("Saved")
                        dismiss()
                    }
                }
        }
    }
}

struct ListViewLoading: View {
    @State var list = ["GMC", "Chevy", "Hummer", "Jeep", "Mustang"]
    @State var searcgText = ""
    @State var isLoading = false
    
    var filteredList: [String] {
        searcgText.isEmpty ? list : list.filter {
            $0.localizedCaseInsensitiveContains(searcgText)
        }
    }
    
    var body: some View {
        NavigationStack {
            List(filteredList, id: \.self) {
                Text($0)
            }
            .navigationTitle("Cars")
            .toolbar {
                ToolbarItems.refreshButton(isLoading: isLoading) {
                    Task {
                        self.isLoading = true
                        try? await Task.sleep(nanoseconds: 2_000_000_000)
                        self.isLoading = false
                    }
                }
                ToolbarSearchField(searchText: $searcgText)
            }
        }
    }
}

struct InboxView: View {
    @State var message = 12
    var body: some View {
        NavigationStack {
            List(1..<5) {
                Text("\($0)")
            }
            .navigationTitle("Messages")
            .toolbar {
                ToolbarItems.notificationsBadge(count: message) {
                    print("Clear notifications")
                    self.message = 0
                }
            }
        }
    }
}

struct ToolbarView: View {
    var body: some View {
        NavigationStack {
            Text("Sample View")
                .navigationTitle("Sample View")
                .toolbar {
                    ToolbarButton(.navigationBarTrailing, icon: "magnifyingglass", label: "Search") {
                        // action
                    }
                    
                    ToolbarItemBuilder(.navigationBarTrailing) {
                        Button("Tap") { }
                    }
                    
                    ToolbarMenu(.navigationBarLeading, icon: "") {
                        ForEach(0...3, id: \.self) {
                            Text("\($0)")
                        }
                    }
                }
        }
    }
}

#Preview {
    ToolbarView()
}
#Preview {
    ListUsage()
}
#Preview {
    DetailView()
}
#Preview {
    EditorView()
}
#Preview {
    ListViewLoading()
}
#Preview {
    InboxView()
}

// MARK: - Reusable Toolbar Item
public struct ToolbarItemBuilder<Content: View>: ToolbarContent {
    let placement: ToolbarItemPlacement
    let content: () -> Content
    
    public init(_ placement: ToolbarItemPlacement, @ViewBuilder content: @escaping () -> Content) {
        self.placement = placement
        self.content = content
    }
    
    public var body: some ToolbarContent {
        ToolbarItem(placement: placement, content: content)
    }
}

// MARK: - Convenience Builders
public struct ToolbarButton: ToolbarContent {
    let placement: ToolbarItemPlacement
    let icon: String?
    let label: String?
    let action: () -> Void
    
    public init(_ placement: ToolbarItemPlacement, icon: String?, label: String?, action: @escaping () -> Void) {
        self.placement = placement
        self.icon = icon
        self.label = label
        self.action = action
    }
    
    public var body: some ToolbarContent {
        ToolbarItem(placement: placement) {
            Button(action: action) {
                if let icon = icon, let label = label {
                    Label(label, systemImage: icon)
                } else if let icon = icon {
                    Image(systemName: icon)
                } else if let label = label {
                    Text(label)
                }
            }
        }
    }
}

// MARK: - Menu Toolbar Item
public struct ToolbarMenu<Content: View>: ToolbarContent {
    let placement: ToolbarItemPlacement
    let icon: String
    let label: String
    let menuContent: () -> Content
    
    public init(_ placement: ToolbarItemPlacement, icon: String, label: String = "More", menuContent: @escaping () -> Content) {
        self.placement = placement
        self.icon = icon
        self.label = label
        self.menuContent = menuContent
    }
    
    public var body: some ToolbarContent {
        ToolbarItem(placement: placement) {
            Menu {
                menuContent()
            } label: {
                Label(label, systemImage: icon)
            }
        }
    }
}

// MARK: - Search Toolbar Item
public struct ToolbarSearchField: ToolbarContent {
    let placement: ToolbarItemPlacement
    @Binding var searchText: String
    let placeholder: String = ""
    
    public init(_ placement: ToolbarItemPlacement = .navigationBarTrailing, searchText: Binding<String>) {
        self.placement = placement
        self._searchText = searchText
    }
    
    public var body: some ToolbarContent {
        ToolbarItem(placement: placement) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                TextField(placeholder, text: $searchText)
                
                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(8)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}

// MARK: - Loading Indicator Toolbar Item
public struct ToolbarActivityIndicator: ToolbarContent {
    let placement: ToolbarItemPlacement
    let isLoading: Bool
    
    public init(placement: ToolbarItemPlacement = .navigationBarTrailing, isLoading: Bool) {
        self.placement = placement
        self.isLoading = isLoading
    }
    
    public var body: some ToolbarContent {
        ToolbarItem(placement: placement) {
            if isLoading {
                ProgressView()
                    .scaleEffect(0.8)
            }
        }
    }
}

// MARK: - Edit/Done Toggle Toolbar Item
public struct ToolbarEditToggle: ToolbarContent {
    let placemnet: ToolbarItemPlacement
    @Binding var isEditing: Bool
    
    public init(placemnet: ToolbarItemPlacement = .navigationBarTrailing, isEditing: Binding<Bool>) {
        self.placemnet = placemnet
        self._isEditing = isEditing
    }
    
    public var body: some ToolbarContent {
        ToolbarItem(placement: placemnet) {
            Button(isEditing ? "Done" : "Edit") {
                withAnimation {
                    self.isEditing.toggle()
                }
            }
        }
    }
}

// MARK: - Badge Toolbar Item
public struct ToolbarBadge: ToolbarContent {
    let placement: ToolbarItemPlacement
    let icon: String
    let badgeCount: Int
    let action: () -> Void
    
    public init(_ placement: ToolbarItemPlacement, icon: String, badgeCount: Int, action: @escaping () -> Void) {
        self.placement = placement
        self.icon = icon
        self.badgeCount = badgeCount
        self.action = action
    }
    
    public var body: some ToolbarContent {
        ToolbarItem(placement: placement) {
            Button(action: action) {
                ZStack(alignment: .topTrailing) {
                    Image(systemName: icon)
                    
                    if badgeCount > 0 {
                        Text("\(badgeCount)")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .frame(width: 18, height: 18)
                            .background(Color.red)
                            .clipShape(Circle())
                            .offset(x: 8, y: -8)
                    }
                }
            }
        }
    }
}

// MARK: - Common Toolbar Items
@MainActor
public struct ToolbarItems {
    
    // MARK: - Back Button
    public static func backButton(action: @escaping () -> Void) -> some ToolbarContent {
        ToolbarButton(.navigationBarLeading, icon: "chevron.left", label: "Back", action: action)
    }
    
    // MARK: - Close Button
    public static func closeButton(action: @escaping () -> Void) -> some ToolbarContent {
        ToolbarButton(.navigationBarTrailing, icon: "xmark", label: "", action: action)
    }
    
    // MARK: - Add Button
    public static func addButton(action: @escaping () -> Void) -> some ToolbarContent {
        ToolbarButton(.navigationBarTrailing, icon: "plus", label: "", action: action)
    }
    
    // MARK: - Share Button
    public static func shareButton(action: @escaping () -> Void) -> some ToolbarContent {
        ToolbarButton(.navigationBarTrailing, icon: "square.and.arrow.up", label: "Share", action: action)
    }
    
    // MARK: - Settings Button
    public static func settingsButton(action: @escaping () -> Void) -> some ToolbarContent {
        ToolbarButton(.navigationBarTrailing, icon: "gearshape.fill", label: "", action: action)
    }
    
    // MARK: - Save Button
    public static func saveButton(isEnabled: Bool = true, action: @escaping () -> Void) -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button("Save", action: action)
                .disabled(!isEnabled)
        }
    }
    
    // MARK: - Delete Button
    public static func deleteButton(action: @escaping () -> Void) -> some ToolbarContent {
        ToolbarButton(.navigationBarTrailing, icon: "trash", label: "", action: action)
    }
    
    // MARK: - More Menu
    public static func moreMenu(@ViewBuilder content: @escaping () -> some View) -> some ToolbarContent {
        ToolbarMenu(.navigationBarTrailing, icon: "ellipsis.circle") {
            content()
        }
    }
    
    // MARK: - Help Button
    public static func helpButton(action: @escaping () -> Void) -> some ToolbarContent {
        ToolbarButton(.navigationBarTrailing, icon: "questionmark.circle", label: "", action: action)
    }
    
    // MARK: - Refresh Button
    public static func refreshButton(isLoading: Bool = false,action: @escaping () -> Void) -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            if isLoading {
                ProgressView()
                    .scaleEffect(0.8)
            } else {
                Button {
                    action()
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
            }
        }
    }
    
    // MARK: - Filter Button
    public static func filterButton(isActive: Bool = false, action: @escaping () -> Void) -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                action()
            } label: {
                Image(systemName: isActive ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
            }
        }
    }
    
    // MARK: - Sort Button
    public static func sortButton(action: @escaping () -> Void) -> some ToolbarContent {
        ToolbarButton(
            .navigationBarTrailing,
            icon: "arrow.up.arrow.down.circle", label: "",
            action: action
        )
    }
    
    // MARK: - Notifications Badge
    public static func notificationsBadge(count: Int, action: @escaping () -> Void) -> some ToolbarContent {
        ToolbarBadge(.navigationBarTrailing, icon: "bell.fill", badgeCount: count, action: action)
    }
}

