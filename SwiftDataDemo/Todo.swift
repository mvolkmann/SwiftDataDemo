import Foundation // for Date type
import SwiftData

@Model
final class Todo {
    var title: String
    var completed: Bool
    var created: Date

    init(title: String) {
        self.title = title
        completed = false
        created = Date.now
    }
}
