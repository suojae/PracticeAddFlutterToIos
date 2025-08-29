//
//  UserDefaultsDataSource.swift
//  PracticeAddFlutterToIos
//
//  Created by Jonghyuck Jeon on 8/29/25.
//

import Foundation

struct UserDefaultsDataSource {
    private let userDefaults: UserDefaults
    private let todosKey = "todos_key"
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func loadTodos() async -> [Todo] {
        guard let data = userDefaults.data(forKey: todosKey) else {
            return []
        }
        
        do {
            return try JSONDecoder().decode([Todo].self, from: data)
        } catch {
            print("Failed to decode todos: \(error)")
            return []
        }
    }
    
    func saveTodos(_ todos: [Todo]) async {
        do {
            let data = try JSONEncoder().encode(todos)
            userDefaults.set(data, forKey: todosKey)
        } catch {
            print("Failed to encode todos: \(error)")
        }
    }
}

