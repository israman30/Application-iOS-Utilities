import SwiftUI

/// Coordinator pattern for `NavigationStack` that is reusable from the `Utils` framework.
///
/// - **Coordinator** (class): owns navigation state (`path`) and provides navigation APIs,
///   plus two overridable view builders: root view + destination views.
/// - **CoordinatorView** (struct): builds the `NavigationStack` using `path` and delegates
///   view construction to the coordinator.
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
/// Typical usage:
/// - Define your own `Route: Hashable` (usually an enum)
/// - Subclass `Coordinator<Route>` and override `rootView()` / `destinationView(for:)`
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
            withAnimation { path.append(route) }
        } else {
            path.append(route)
        }
    }

    public func setPath(_ routes: [Route], animated: Bool = true) {
        if animated {
            withAnimation { path = routes }
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
            withAnimation { path.removeLast() }
        } else {
            path.removeLast()
        }
    }

    public func navigateBack(steps: Int, animated: Bool = true) {
        guard steps > 0, !path.isEmpty else { return }
        let safeSteps = min(steps, path.count)
        if animated {
            withAnimation { path.removeLast(safeSteps) }
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
            withAnimation { path.removeAll() }
        } else {
            path.removeAll()
        }
    }
}

/// A reusable `NavigationStack` host for any coordinator.
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

#if DEBUG
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
