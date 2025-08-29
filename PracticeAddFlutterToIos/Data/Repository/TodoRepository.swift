//
//  TodoRepository.swift
//  PracticeAddFlutterToIos
//
//  Created by Jonghyuck Jeon on 8/29/25.
//

import Foundation

struct TodoRepository: TodoRepositoryProtocol {
    private let dataSource: UserDefaultsDataSource
    
    init(dataSource: UserDefaultsDataSource = UserDefaultsDataSource()) {
        self.dataSource = dataSource
    }
    
    func loadTodos() async throws -> [Todo] {
        return await dataSource.loadTodos()
    }
    
    func saveTodos(_ todos: [Todo]) async throws {
        await dataSource.saveTodos(todos)
    }
}
