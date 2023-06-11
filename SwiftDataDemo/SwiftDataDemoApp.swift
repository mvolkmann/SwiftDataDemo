//
//  SwiftDataDemoApp.swift
//  SwiftDataDemo
//
//  Created by Mark Volkmann on 6/10/23.
//

import SwiftUI
import SwiftData

@main
struct SwiftDataDemoApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Item.self)
    }
}
