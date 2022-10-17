import Dependencies
import Foundation

struct ItemFeatureClient {

    @Dependency(\.itemRepository) var itemRepository
    @Dependency(\.userManager) var userManager

    public var userItems: @Sendable () -> AsyncStream<[Item]>
}

extension ItemFeatureClient: DependencyKey {
    
    static var liveValue = ItemFeatureClient(
        userItems: {
            // TODO: Combine itemRepository.allItems() and userManager.itemIds(), filter and return
            // Emits: "one" 🔜 "one", "two", "three" 🔜 "one", "two", "three", "four", "five"
            AsyncStream<[Item]> { continuation in
                Task {
                    try await Task.sleep(nanoseconds: NSEC_PER_SEC * 2)
                    continuation.yield([.mock1])
                    try await Task.sleep(nanoseconds: NSEC_PER_SEC * 1)
                    continuation.yield([.mock1, .mock2, .mock3])
                    try await Task.sleep(nanoseconds: NSEC_PER_SEC * 1)
                    continuation.yield([.mock1, .mock2, .mock3, .mock4, .mock5])
                    continuation.finish()
                }
            }
        }
    )
    
}

extension DependencyValues {
    var itemFeatureClient: ItemFeatureClient {
        get { self[ItemFeatureClient.self] }
        set { self[ItemFeatureClient.self] = newValue }
    }
}
