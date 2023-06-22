//
//  TodoListApp.swift
//  TodoList
//
//  Created by Cumulations Technology on 22/06/23.
//

import SwiftUI

@main
struct TodoListApp: App {
    @StateObject private var watchManager = WatchManager()
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(watchManager)
        }
    }
}
