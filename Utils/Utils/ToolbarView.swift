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
// MARK: - ToolbarView Sample Usage
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
                
                ToolbarEditToggle(placement: .navigationBarLeading, isEditing: $isEditing)
                ToolbarSearchField(searchText: $searchText, placeholder: "Search list")
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
                    Button("Dismiss", role: .destructive) { }
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
                    ToolbarButton(.navigationBarLeading, label: "Cancel") {
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
    @State var searchText = ""
    @State var isLoading = false
    
    var filteredList: [String] {
        searchText.isEmpty ? list : list.filter {
            $0.localizedCaseInsensitiveContains(searchText)
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
                ToolbarSearchField(searchText: $searchText, placeholder: "Search cars")
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

struct ComplexTabbar: View {
    @State var searchText = ""
    @State var isEditing = false
    @State var isLoading = false
    @State var isFilterActive = false
    
    var body: some View {
        NavigationStack {
            List(1..<10, id: \.self) {
                Text("Item: \($0)")
            }
            .navigationTitle("Complex Tab")
            .toolbar {
                ToolbarItems.backButton {
                    print("Back")
                }
                
                if !isEditing {
                    ToolbarItems.filterButton(isActive: isFilterActive) {
                        isFilterActive.toggle()
                    }
                    
                    ToolbarItems.moreMenu {
                        Button("Refresh") { print("Refresh") }
                        Button("Share") { print("Share") }
                        Button("Settings") { print("Settings") }
                    }
                }
                
                ToolbarEditToggle(isEditing: $isEditing)
            }
        }
    }
}

// MARK: - Showcase Catalog

private struct ToolbarExample: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let systemImage: String
}

struct ToolbarView: View {
    private let examples: [ToolbarExample] = [
        ToolbarExample(title: "List with Search", subtitle: "Add, edit, and search in a list", systemImage: "list.bullet"),
        ToolbarExample(title: "Detail View", subtitle: "Back navigation and overflow menu", systemImage: "doc.text"),
        ToolbarExample(title: "Editor", subtitle: "Cancel and save actions", systemImage: "square.and.pencil"),
        ToolbarExample(title: "Loading List", subtitle: "Refresh control and filtered search", systemImage: "arrow.clockwise"),
        ToolbarExample(title: "Inbox", subtitle: "Notification badge in the toolbar", systemImage: "bell.badge"),
        ToolbarExample(title: "Complex Toolbar", subtitle: "Filter, menu, and edit toggle", systemImage: "slider.horizontal.3")
    ]
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(examples.indices, id: \.self) { index in
                        NavigationLink {
                            destination(for: index)
                        } label: {
                            Label {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(examples[index].title)
                                        .font(.body)
                                    Text(examples[index].subtitle)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            } icon: {
                                Image(systemName: examples[index].systemImage)
                                    .foregroundStyle(.tint)
                                    .frame(width: 28)
                            }
                        }
                        .accessibilityHint("Opens the \(examples[index].title) toolbar example")
                    }
                } header: {
                    Text("Examples")
                } footer: {
                    Text("Each example demonstrates reusable toolbar components with accessibility labels and modern styling.")
                }
            }
            .navigationTitle("Toolbar Components")
            .toolbar {
                ToolbarItems.helpButton {
                    print("Help")
                }
            }
        }
    }
    
    @ViewBuilder
    private func destination(for index: Int) -> some View {
        switch index {
        case 0: ListUsage()
        case 1: DetailView()
        case 2: EditorView()
        case 3: ListViewLoading()
        case 4: InboxView()
        default: ComplexTabbar()
        }
    }
}

#Preview("Catalog") {
    ToolbarView()
}

#Preview("Catalog – Dark") {
    ToolbarView()
        .preferredColorScheme(.dark)
}

#Preview("List Usage") {
    ListUsage()
}

#Preview("Detail View") {
    DetailView()
}

#Preview("Editor") {
    EditorView()
}

#Preview("Loading List") {
    ListViewLoading()
}

#Preview("Inbox") {
    InboxView()
}

#Preview("Complex Toolbar") {
    ComplexTabbar()
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
    let accessibilityLabel: String?
    let action: () -> Void
    
    public init(
        _ placement: ToolbarItemPlacement,
        icon: String? = nil,
        label: String? = nil,
        accessibilityLabel: String? = nil,
        action: @escaping () -> Void
    ) {
        self.placement = placement
        self.icon = icon
        self.label = label
        self.accessibilityLabel = accessibilityLabel
        self.action = action
    }
    
    private var resolvedAccessibilityLabel: String {
        accessibilityLabel ?? label ?? "Button"
    }
    
    public var body: some ToolbarContent {
        ToolbarItem(placement: placement) {
            Button(action: action) {
                if let icon, let label {
                    Label(label, systemImage: icon)
                } else if let icon {
                    Image(systemName: icon)
                } else if let label {
                    Text(label)
                }
            }
            .buttonStyle(.borderless)
            .accessibilityLabel(resolvedAccessibilityLabel)
        }
    }
}

// MARK: - Menu Toolbar Item
public struct ToolbarMenu<Content: View>: ToolbarContent {
    let placement: ToolbarItemPlacement
    let icon: String
    let label: String
    let menuContent: () -> Content
    
    public init(
        _ placement: ToolbarItemPlacement,
        icon: String = "ellipsis.circle",
        label: String = "More",
        menuContent: @escaping () -> Content
    ) {
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
            .accessibilityLabel(label)
            .accessibilityHint("Shows additional actions")
        }
    }
}

// MARK: - Search Toolbar Item
public struct ToolbarSearchField: ToolbarContent {
    let placement: ToolbarItemPlacement
    @Binding var searchText: String
    let placeholder: String
    
    public init(
        _ placement: ToolbarItemPlacement = .navigationBarTrailing,
        searchText: Binding<String>,
        placeholder: String = "Search"
    ) {
        self.placement = placement
        self._searchText = searchText
        self.placeholder = placeholder
    }
    
    public var body: some ToolbarContent {
        ToolbarItem(placement: placement) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                    .accessibilityHidden(true)
                
                TextField(placeholder, text: $searchText)
                    .textFieldStyle(.plain)
                    .submitLabel(.search)
                    .accessibilityLabel(placeholder)
                
                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.borderless)
                    .accessibilityLabel("Clear search")
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(.quaternary, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
            .frame(minWidth: 160, maxWidth: 240)
        }
    }
}

// MARK: - Loading Indicator Toolbar Item
public struct ToolbarActivityIndicator: ToolbarContent {
    let placement: ToolbarItemPlacement
    let isLoading: Bool
    let accessibilityLabel: String
    
    public init(
        placement: ToolbarItemPlacement = .navigationBarTrailing,
        isLoading: Bool,
        accessibilityLabel: String = "Loading"
    ) {
        self.placement = placement
        self.isLoading = isLoading
        self.accessibilityLabel = accessibilityLabel
    }
    
    public var body: some ToolbarContent {
        ToolbarItem(placement: placement) {
            if isLoading {
                ProgressView()
                    .controlSize(.small)
                    .accessibilityLabel(accessibilityLabel)
            }
        }
    }
}

// MARK: - Edit/Done Toggle Toolbar Item
public struct ToolbarEditToggle: ToolbarContent {
    let placement: ToolbarItemPlacement
    @Binding var isEditing: Bool
    
    public init(placement: ToolbarItemPlacement = .navigationBarTrailing, isEditing: Binding<Bool>) {
        self.placement = placement
        self._isEditing = isEditing
    }
    
    public var body: some ToolbarContent {
        ToolbarItem(placement: placement) {
            Button(isEditing ? "Done" : "Edit") {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isEditing.toggle()
                }
            }
            .fontWeight(isEditing ? .semibold : .regular)
            .accessibilityLabel(isEditing ? "Done editing" : "Edit")
            .accessibilityHint(isEditing ? "Exits edit mode" : "Enters edit mode")
        }
    }
}

// MARK: - Badge Toolbar Item
public struct ToolbarBadge: ToolbarContent {
    let placement: ToolbarItemPlacement
    let icon: String
    let badgeCount: Int
    let accessibilityLabel: String
    let action: () -> Void
    
    public init(
        _ placement: ToolbarItemPlacement,
        icon: String,
        badgeCount: Int,
        accessibilityLabel: String = "Notifications",
        action: @escaping () -> Void
    ) {
        self.placement = placement
        self.icon = icon
        self.badgeCount = badgeCount
        self.accessibilityLabel = accessibilityLabel
        self.action = action
    }
    
    private var badgeText: String {
        badgeCount > 99 ? "99+" : "\(badgeCount)"
    }
    
    private var resolvedAccessibilityLabel: String {
        badgeCount > 0
            ? "\(accessibilityLabel), \(badgeCount) unread"
            : accessibilityLabel
    }
    
    public var body: some ToolbarContent {
        ToolbarItem(placement: placement) {
            Button(action: action) {
                ZStack(alignment: .topTrailing) {
                    Image(systemName: icon)
                        .symbolRenderingMode(.hierarchical)
                    
                    if badgeCount > 0 {
                        Text(badgeText)
                            .font(.caption2.weight(.bold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, badgeCount > 9 ? 4 : 0)
                            .frame(minWidth: 18, minHeight: 18)
                            .background(Color.red, in: Capsule())
                            .offset(x: 8, y: -8)
                            .accessibilityHidden(true)
                    }
                }
            }
            .buttonStyle(.borderless)
            .accessibilityLabel(resolvedAccessibilityLabel)
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
        ToolbarButton(.navigationBarTrailing, icon: "xmark", accessibilityLabel: "Close", action: action)
    }
    
    // MARK: - Add Button
    public static func addButton(action: @escaping () -> Void) -> some ToolbarContent {
        ToolbarButton(.navigationBarTrailing, icon: "plus", accessibilityLabel: "Add", action: action)
    }
    
    // MARK: - Share Button
    public static func shareButton(action: @escaping () -> Void) -> some ToolbarContent {
        ToolbarButton(.navigationBarTrailing, icon: "square.and.arrow.up", label: "Share", action: action)
    }
    
    // MARK: - Settings Button
    public static func settingsButton(action: @escaping () -> Void) -> some ToolbarContent {
        ToolbarButton(.navigationBarTrailing, icon: "gearshape.fill", accessibilityLabel: "Settings", action: action)
    }
    
    // MARK: - Save Button
    public static func saveButton(isEnabled: Bool = true, action: @escaping () -> Void) -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button("Save", action: action)
                .fontWeight(.semibold)
                .disabled(!isEnabled)
                .accessibilityLabel("Save")
                .accessibilityHint(isEnabled ? "Saves your changes" : "Enter content to enable saving")
        }
    }
    
    // MARK: - Delete Button
    public static func deleteButton(action: @escaping () -> Void) -> some ToolbarContent {
        ToolbarButton(.navigationBarTrailing, icon: "trash", accessibilityLabel: "Delete", action: action)
    }
    
    // MARK: - More Menu
    public static func moreMenu(@ViewBuilder content: @escaping () -> some View) -> some ToolbarContent {
        ToolbarMenu(.navigationBarTrailing, icon: "ellipsis.circle") {
            content()
        }
    }
    
    // MARK: - Help Button
    public static func helpButton(action: @escaping () -> Void) -> some ToolbarContent {
        ToolbarButton(.navigationBarTrailing, icon: "questionmark.circle", accessibilityLabel: "Help", action: action)
    }
    
    // MARK: - Refresh Button
    public static func refreshButton(isLoading: Bool = false, action: @escaping () -> Void) -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Group {
                if isLoading {
                    ProgressView()
                        .controlSize(.small)
                } else {
                    Button(action: action) {
                        Image(systemName: "arrow.clockwise")
                    }
                    .buttonStyle(.borderless)
                }
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(isLoading ? "Refreshing" : "Refresh")
            .accessibilityAddTraits(isLoading ? .updatesFrequently : [])
        }
    }
    
    // MARK: - Filter Button
    public static func filterButton(isActive: Bool = false, action: @escaping () -> Void) -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: action) {
                Image(systemName: isActive ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
            }
            .buttonStyle(.borderless)
            .symbolRenderingMode(.hierarchical)
            .accessibilityLabel(isActive ? "Filter, active" : "Filter")
            .accessibilityHint(isActive ? "Double tap to turn off filter" : "Double tap to turn on filter")
        }
    }
    
    // MARK: - Sort Button
    public static func sortButton(action: @escaping () -> Void) -> some ToolbarContent {
        ToolbarButton(
            .navigationBarTrailing,
            icon: "arrow.up.arrow.down.circle",
            accessibilityLabel: "Sort",
            action: action
        )
    }
    
    // MARK: - Notifications Badge
    public static func notificationsBadge(count: Int, action: @escaping () -> Void) -> some ToolbarContent {
        ToolbarBadge(.navigationBarTrailing, icon: "bell.fill", badgeCount: count, action: action)
    }
}

