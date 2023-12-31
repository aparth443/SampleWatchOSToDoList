//
//  TodoListApp.swift
//  TodoList Watch App
//
//  Created by Cumulations Technology on 22/06/23.
//

import SwiftUI

@main
struct TodoList_Watch_AppApp: App {
    @StateObject private var watchManager = WatchManager()
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(watchManager)
        }
    }
}
