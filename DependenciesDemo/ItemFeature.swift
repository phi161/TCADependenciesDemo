import AsyncAlgorithms
import ComposableArchitecture
import SwiftUI

struct ItemFeature: ReducerProtocol {

    @Dependency(\.itemRepository) var repository
    @Dependency(\.userManager) var user

    struct State: Equatable {
        var items: [Item]
    }

    enum Action {
        case onAppear
        case itemsLoaded([Item])
    }

    func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
        switch action {
        case .onAppear:
            return .run { send in
                // Combine the 2 streams..
                for await (allItems, ids) in combineLatest(repository.allItems(), user.itemIds()) {
                    // ..and filter available items based on the user's ids
                    let filtered = allItems.filter { ids.contains($0.id) }
                    await send(.itemsLoaded(filtered))
                }
            }
        case .itemsLoaded(let items):
            state.items = items
            return .none
        }
    }

}

struct ItemsView: View {

    let store: StoreOf<ItemFeature>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            List {
                ForEach(viewStore.items) { item in
                    Text(item.title)
                }
            }.task {
                viewStore.send(.onAppear)
            }
        }
    }
}

struct ItemsView_Previews: PreviewProvider {
    static var previews: some View {
        ItemsView(
            store: Store(
                initialState: .init(items: [
                    .mock1,
                    .mock2,
                    .mock3,
                    .mock4,
                    .mock5
                ]),
                reducer: ItemFeature()
            )
        )
    }
}
