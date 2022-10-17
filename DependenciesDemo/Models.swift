import Foundation

struct Item: Equatable, Identifiable {
    let id: String
    let title: String
}

extension Item {
    static let mock1 = Item(id: "01", title: "one")
    static let mock2 = Item(id: "02", title: "two")
    static let mock3 = Item(id: "03", title: "three")
    static let mock4 = Item(id: "04", title: "four")
    static let mock5 = Item(id: "05", title: "five")
}
