import ComposableArchitecture
import SwiftUI

@main
struct DependenciesDemoApp: App {
    var body: some Scene {
        WindowGroup {
            ItemsView(
                store: Store(
                    initialState: .init(items: []),
                    reducer: ItemFeature()
                )
            )
        }
    }
}
