import Dependencies
import Foundation

struct ItemRepository {
    public var allItems: @Sendable () -> AsyncStream<[Item]>
}

extension ItemRepository: DependencyKey {
    static var liveValue = ItemRepository(
        allItems: {
            // Emits: "one", "two" 🔜 "one", "two", "three" 🔜 "one", "two", "three", "four", "five"
            AsyncStream<[Item]> { continuation in
                Task {
                    try await Task.sleep(nanoseconds: NSEC_PER_SEC * 2)
                    continuation.yield([.mock1, .mock2])
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
    var itemRepository: ItemRepository {
        get { self[ItemRepository.self] }
        set { self[ItemRepository.self] = newValue }
    }
}
