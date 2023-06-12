import SwiftData
import SwiftUI

@main
struct SwiftDataDemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        // Can pass one model class or an array of them.
        .modelContainer(for: [Todo.self])
    }
}
