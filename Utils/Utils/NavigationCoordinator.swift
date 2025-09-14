import SwiftUI

// MARK: - Navigation Destination Enum
/// Defines all possible navigation destinations in the app
/// This provides type-safe navigation and enables deep linking
enum NavigationDestination: Hashable {
    case home
    case profile(userID: String)
    case settings
    case detail(id: String, title: String)
    case search(query: String)
    case form(data: FormData)
    
    // Custom hashable implementation for associated values
    func hash(into hasher: inout Hasher) {
        switch self {
        case .home:
            hasher.combine(0)
        case .profile(let userID):
            hasher.combine(1)
            hasher.combine(userID)
        case .settings:
            hasher.combine(2)
        case .detail(let id, let title):
            hasher.combine(3)
            hasher.combine(id)
            hasher.combine(title)
        case .search(let query):
            hasher.combine(4)
            hasher.combine(query)
        case .form(let data):
            hasher.combine(5)
            hasher.combine(data)
        }
    }
    
    static func == (lhs: NavigationDestination, rhs: NavigationDestination) -> Bool {
        switch (lhs, rhs) {
        case (.home, .home):
            return true
        case (.profile(let lhsID), .profile(let rhsID)):
            return lhsID == rhsID
        case (.settings, .settings):
            return true
        case (.detail(let lhsID, let lhsTitle), .detail(let rhsID, let rhsTitle)):
            return lhsID == rhsID && lhsTitle == rhsTitle
        case (.search(let lhsQuery), .search(let rhsQuery)):
            return lhsQuery == rhsQuery
        case (.form(let lhsData), .form(let rhsData)):
            return lhsData == rhsData
        default:
            return false
        }
    }
}

// MARK: - Form Data Model
struct FormData: Hashable {
    let id: String
    let title: String
    let description: String
}

// MARK: - Navigation Coordinator
/// A reusable navigation coordinator that manages navigation state and history
@Observable
class NavigationCoordinator {
    /// The current navigation path
    var path = NavigationPath()
    
    /// Navigation history for advanced back navigation
    var navigationHistory: [NavigationDestination] = []
    
    /// Maximum history size to prevent memory issues
    private let maxHistorySize = 50
    
    // MARK: - Navigation Methods
    
    /// Navigate to a specific destination
    /// - Parameter destination: The destination to navigate to
    func navigate(to destination: NavigationDestination) {
        path.append(destination)
        addToHistory(destination)
    }
    
    /// Navigate back to a specific destination in history
    /// - Parameter destination: The destination to navigate back to
    func navigateBack(to destination: NavigationDestination) {
        guard let index = navigationHistory.firstIndex(of: destination) else { return }
        
        // Remove all destinations after the target
        let targetIndex = navigationHistory.count - 1 - index
        path.removeLast(path.count - targetIndex)
        
        // Update history
        navigationHistory = Array(navigationHistory.prefix(index + 1))
    }
    
    /// Navigate back one step
    func navigateBack() {
        guard !path.isEmpty else { return }
        path.removeLast()
        if !navigationHistory.isEmpty {
            navigationHistory.removeLast()
        }
    }
    
    /// Navigate to root (clear all navigation)
    func navigateToRoot() {
        path.removeLast(path.count)
        navigationHistory.removeAll()
    }
    
    /// Replace current navigation stack with new destination
    /// - Parameter destination: The new destination
    func replace(with destination: NavigationDestination) {
        path.removeLast(path.count)
        path.append(destination)
        navigationHistory.removeAll()
        addToHistory(destination)
    }
    
    // MARK: - Deep Linking Support
    
    /// Handle deep link URL and convert to navigation destination
    /// - Parameter url: The deep link URL
    func handleDeepLink(_ url: URL) {
        guard let destination = parseDeepLink(url) else { return }
        replace(with: destination)
    }
    
    /// Parse deep link URL to navigation destination
    /// - Parameter url: The deep link URL
    /// - Returns: Navigation destination if valid
    private func parseDeepLink(_ url: URL) -> NavigationDestination? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return nil
        }
        
        switch components.path {
        case "/home":
            return .home
        case "/profile":
            if let userID = components.queryItems?.first(where: { $0.name == "id" })?.value {
                return .profile(userID: userID)
            }
        case "/settings":
            return .settings
        case "/detail":
            if let id = components.queryItems?.first(where: { $0.name == "id" })?.value,
               let title = components.queryItems?.first(where: { $0.name == "title" })?.value {
                return .detail(id: id, title: title)
            }
        case "/search":
            if let query = components.queryItems?.first(where: { $0.name == "q" })?.value {
                return .search(query: query)
            }
        case "/form":
            if let id = components.queryItems?.first(where: { $0.name == "id" })?.value,
               let title = components.queryItems?.first(where: { $0.name == "title" })?.value,
               let description = components.queryItems?.first(where: { $0.name == "description" })?.value {
                let formData = FormData(id: id, title: title, description: description)
                return .form(data: formData)
            }
        default:
            break
        }
        
        return nil
    }
    
    // MARK: - Private Methods
    
    /// Add destination to navigation history
    /// - Parameter destination: The destination to add
    private func addToHistory(_ destination: NavigationDestination) {
        navigationHistory.append(destination)
        
        // Maintain history size limit
        if navigationHistory.count > maxHistorySize {
            navigationHistory.removeFirst()
        }
    }
}

// MARK: - Navigation Coordinator View
/// A reusable view that provides navigation coordination
struct NavigationCoordinatorView<Content: View>: View {
    @State private var coordinator = NavigationCoordinator()
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            content
                .navigationDestination(for: NavigationDestination.self) { destination in
                    destinationView(for: destination)
                }
        }
        .environment(coordinator)
    }
    
    /// Create the appropriate view for each navigation destination
    /// - Parameter destination: The navigation destination
    /// - Returns: The view to display
    @ViewBuilder
    private func destinationView(for destination: NavigationDestination) -> some View {
        switch destination {
        case .home:
            HomeView()
        case .profile(let userID):
            ProfileView(userID: userID)
        case .settings:
            SettingsView()
        case .detail(let id, let title):
            DetailView(id: id, title: title)
        case .search(let query):
            SearchView(query: query)
        case .form(let data):
            FormView(data: data)
        }
    }
}

// MARK: - Environment Key
/// Environment key for accessing the navigation coordinator
private struct NavigationCoordinatorKey: EnvironmentKey {
    static let defaultValue: NavigationCoordinator? = nil
}

// MARK: - Environment Extension
extension EnvironmentValues {
    var navigationCoordinator: NavigationCoordinator? {
        get { self[NavigationCoordinatorKey.self] }
        set { self[NavigationCoordinatorKey.self] = newValue }
    }
}

// MARK: - View Extension
extension View {
    /// Access the navigation coordinator from the environment
    var coordinator: NavigationCoordinator? {
        @Environment(\.navigationCoordinator) var coordinator
        return coordinator
    }
}

// MARK: - Example Views (Placeholder implementations)
struct HomeView: View {
    @Environment(\.navigationCoordinator) var coordinator
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Home")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Button("Go to Profile") {
                coordinator?.navigate(to: .profile(userID: "user123"))
            }
            .buttonStyle(.borderedProminent)
            
            Button("Go to Settings") {
                coordinator?.navigate(to: .settings)
            }
            .buttonStyle(.bordered)
            
            Button("Search") {
                coordinator?.navigate(to: .search(query: "swiftui"))
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
}

struct ProfileView: View {
    let userID: String
    @Environment(\.navigationCoordinator) var coordinator
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Profile")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("User ID: \(userID)")
                .font(.headline)
            
            Button("Go to Detail") {
                coordinator?.navigate(to: .detail(id: "detail123", title: "User Detail"))
            }
            .buttonStyle(.borderedProminent)
            
            Button("Back to Home") {
                coordinator?.navigateBack()
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
}

struct SettingsView: View {
    @Environment(\.navigationCoordinator) var coordinator
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Settings")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Button("Go to Form") {
                let formData = FormData(id: "form1", title: "Settings Form", description: "Configure your settings")
                coordinator?.navigate(to: .form(data: formData))
            }
            .buttonStyle(.borderedProminent)
            
            Button("Back to Home") {
                coordinator?.navigateToRoot()
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
}

struct DetailView: View {
    let id: String
    let title: String
    @Environment(\.navigationCoordinator) var coordinator
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Detail")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("ID: \(id)")
                .font(.headline)
            
            Text("Title: \(title)")
                .font(.headline)
            
            Button("Back") {
                coordinator?.navigateBack()
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
}

struct SearchView: View {
    let query: String
    @Environment(\.navigationCoordinator) var coordinator
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Search Results")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Query: \(query)")
                .font(.headline)
            
            Button("Back") {
                coordinator?.navigateBack()
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
}

struct FormView: View {
    let data: FormData
    @Environment(\.navigationCoordinator) var coordinator
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Form")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("ID: \(data.id)")
                .font(.headline)
            
            Text("Title: \(data.title)")
                .font(.headline)
            
            Text("Description: \(data.description)")
                .font(.body)
            
            Button("Back") {
                coordinator?.navigateBack()
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
}

// MARK: - Usage Example
struct ContentView: View {
    var body: some View {
        NavigationCoordinatorView {
            HomeView()
        }
    }
}

#Preview {
    ContentView()
} 