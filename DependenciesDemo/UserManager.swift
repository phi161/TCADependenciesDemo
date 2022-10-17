import Dependencies
import Foundation

struct UserManager {
    public var itemIds: @Sendable () -> AsyncStream<[String]>
}

extension UserManager: DependencyKey {
    static var liveValue = UserManager(
        itemIds: {
            // Emits: "02" 🔜 "02", "04"
            AsyncStream<[String]> { continuation in
                Task {
                    try await Task.sleep(nanoseconds: NSEC_PER_SEC * 1)
                    continuation.yield(["02"])
                    try await Task.sleep(nanoseconds: NSEC_PER_SEC * 2)
                    continuation.yield(["02", "04"])
                    continuation.finish()
                }
            }
        }
    )
}

extension DependencyValues {
    var userManager: UserManager {
        get { self[UserManager.self] }
        set { self[UserManager.self] = newValue }
    }
}
