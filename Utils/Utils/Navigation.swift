import SwiftUI

/// Coordinator pattern for `NavigationStack` that is reusable from the `Utils` framework.
///
/// This file provides a small, library-friendly abstraction around `NavigationStack` that
/// keeps navigation state and view construction in one place (a coordinator), while still
/// letting SwiftUI own the navigation container.
///
/// ### Setup (what you create in your app/module)
/// 1. Define a `Route` type (usually an enum) that conforms to `Hashable`.
/// 2. Subclass `Coordinator<Route>` and implement:
///    - `rootView()` for the first screen
///    - `destinationView(for:)` for pushed screens
/// 3. Host everything using `CoordinatorView(coordinator:)`.
///
/// ### How it works (implementation summary)
/// - `Coordinator` owns the navigation stack state as an array of routes (`path: [Route]`)
/// - `CoordinatorView` creates a `NavigationStack(path:)` bound to that array
/// - `.navigationDestination(for:)` delegates destination view construction back to the coordinator
/// - The coordinator is injected into the view tree via `.environmentObject(coordinator)`
///
/// ### Usage (copy/paste)
/// ```swift
/// import SwiftUI
/// import Utils
///
/// enum AppRoute: Hashable { case details(id: String), settings }
///
/// final class AppCoordinator: Coordinator<AppRoute> {
///     override func rootView() -> AnyView { AnyView(HomeView()) }
///     override func destinationView(for route: AppRoute) -> AnyView {
///         switch route {
///         case .details(let id): AnyView(DetailsView(id: id))
///         case .settings: AnyView(SettingsView())
///         }
///     }
/// }
///
/// struct AppRoot: View {
///     var body: some View {
///         CoordinatorView(coordinator: AppCoordinator())
///     }
/// }
///
/// struct HomeView: View {
///     @EnvironmentObject var coordinator: AppCoordinator
///     var body: some View {
///         Button("Go") { coordinator.navigate(to: .details(id: "123")) }
///     }
/// }
/// ```
@MainActor
public protocol Coordinating: ObservableObject {
    associatedtype Route: Hashable
    var path: [Route] { get set }

    /// Build the root (first) screen in the `NavigationStack`.
    func rootView() -> AnyView

    /// Build the destination view for a pushed route.
    func destinationView(for route: Route) -> AnyView
}

/// Base coordinator class you can subclass in your app/module.
///
/// ### Implementation notes
/// - The `path` is `[Route]` (instead of `NavigationPath`) so it can be bound directly to
///   `NavigationStack(path:)` with type safety and without type erasure.
/// - View construction returns `AnyView` to keep the API surface small and easy to override.
@MainActor
open class Coordinator<Route: Hashable>: ObservableObject, Coordinating {
    @Published public var path: [Route] = []

    public init() {}

    open func rootView() -> AnyView {
        AnyView(EmptyView())
    }

    open func destinationView(for route: Route) -> AnyView {
        AnyView(EmptyView())
    }

    // MARK: - Navigation APIs

    public func navigate(to route: Route, animated: Bool = true) {
        if animated {
           let _ = withAnimation { path.append(route) }
        } else {
            path.append(route)
        }
    }

    public func setPath(_ routes: [Route], animated: Bool = true) {
        if animated {
           let _ = withAnimation { path = routes }
        } else {
            path = routes
        }
    }

    public func replace(with route: Route, animated: Bool = true) {
        setPath([route], animated: animated)
    }

    public func navigateBack(animated: Bool = true) {
        guard !path.isEmpty else { return }
        if animated {
            _ = withAnimation { path.removeLast() }
        } else {
            path.removeLast()
        }
    }

    public func navigateBack(steps: Int, animated: Bool = true) {
        guard steps > 0, !path.isEmpty else { return }
        let safeSteps = min(steps, path.count)
        if animated {
           let  _ = withAnimation { path.removeLast(safeSteps) }
        } else {
            path.removeLast(safeSteps)
        }
    }

    public func popTo(_ route: Route, animated: Bool = true) {
        guard let index = path.lastIndex(of: route) else { return }
        let desiredCount = index + 1
        let toRemove = path.count - desiredCount
        guard toRemove > 0 else { return }
        navigateBack(steps: toRemove, animated: animated)
    }

    public func navigateToRoot(animated: Bool = true) {
        if animated {
           let _ = withAnimation { path.removeAll() }
        } else {
            path.removeAll()
        }
    }
}

/// A reusable `NavigationStack` host for any coordinator.
///
/// ### Usage
/// Create the coordinator once at the root, and pass it here. `CoordinatorView` will keep it
/// alive using `@StateObject` and inject it into the environment as an `EnvironmentObject`.
@MainActor
public struct CoordinatorView<C: Coordinating>: View {
    @StateObject private var coordinator: C

    public init(coordinator: @autoclosure @escaping () -> C) {
        _coordinator = StateObject(wrappedValue: coordinator())
    }

    public var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.rootView()
                .navigationDestination(for: C.Route.self) { route in
                    coordinator.destinationView(for: route)
                }
        }
        .environmentObject(coordinator)
    }
}

/// Backwards-friendly alias for the coordinator-based host view.
///
/// Prefer `CoordinatorView` directly.
@available(*, deprecated, message: "Use CoordinatorView(coordinator:) instead.")
public typealias Navigation<C: Coordinating> = CoordinatorView<C>


// MARK: - Coordinator Sample (Debug-only)

#if DEBUG
/// A small demo view you can run in previews to see coordinator navigation in action.
///
/// This is compiled only in Debug builds to avoid adding demo types to your Release framework.
public struct CoordinatorSampleView: View {
    public init() {}

    public var body: some View {
        CoordinatorView(coordinator: SampleCoordinator())
    }
}

private enum SampleRoute: Hashable {
    case details(id: String)
    case settings
}

@MainActor
private final class SampleCoordinator: Coordinator<SampleRoute> {
    override func rootView() -> AnyView {
        AnyView(SampleHomeView())
    }

    override func destinationView(for route: SampleRoute) -> AnyView {
        switch route {
        case .details(let id):
            AnyView(SampleDetailsView(id: id))
        case .settings:
            AnyView(SampleSettingsView())
        }
    }
}

private struct SampleHomeView: View {
    @EnvironmentObject private var coordinator: SampleCoordinator

    var body: some View {
        List {
            Section("Navigation") {
                Button("Push details") {
                    coordinator.navigate(to: .details(id: UUID().uuidString.prefix(6).description))
                }

                Button("Push settings") {
                    coordinator.navigate(to: .settings)
                }

                Button("Push 3 details") {
                    coordinator.setPath([
                        .details(id: "A1"),
                        .details(id: "B2"),
                        .details(id: "C3")
                    ])
                }
            }
        }
        .navigationTitle("Coordinator Sample")
    }
}

private struct SampleDetailsView: View {
    let id: String
    @EnvironmentObject private var coordinator: SampleCoordinator

    var body: some View {
        VStack(spacing: 16) {
            Text("Details")
                .font(.title)
                .fontWeight(.semibold)

            Text("ID: \(id)")
                .font(.headline)
                .foregroundStyle(.secondary)

            Button("Push another details") {
                coordinator.navigate(to: .details(id: UUID().uuidString.prefix(6).description))
            }
            .buttonStyle(.borderedProminent)

            Button("Back") {
                coordinator.navigateBack()
            }
            .buttonStyle(.bordered)

            Button("Pop to root") {
                coordinator.navigateToRoot()
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .navigationTitle("Details")
    }
}

private struct SampleSettingsView: View {
    @EnvironmentObject private var coordinator: SampleCoordinator

    var body: some View {
        VStack(spacing: 16) {
            Text("Settings")
                .font(.title)
                .fontWeight(.semibold)

            Button("Back") {
                coordinator.navigateBack()
            }
            .buttonStyle(.bordered)

            Button("Pop to root") {
                coordinator.navigateToRoot()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .navigationTitle("Settings")
    }
}

struct CoordinatorSampleView_Previews: PreviewProvider {
    static var previews: some View {
        CoordinatorSampleView()
    }
}
#endif
