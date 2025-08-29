//
//  PracticeAddFlutterToIosApp.swift
//  PracticeAddFlutterToIos
//
//  Created by Jonghyuck Jeon on 8/29/25.
//

import SwiftUI
import ComposableArchitecture

@main
struct PracticeAddFlutterToIosApp: App {
    var body: some Scene {
        WindowGroup {
            TodoListView(
                store: Store(initialState: TodoListReducer.State()) {
                    TodoListReducer()
                        ._printChanges()
                }
            )
        }
    }
}
