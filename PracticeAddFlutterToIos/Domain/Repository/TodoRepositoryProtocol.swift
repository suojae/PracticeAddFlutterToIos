//
//  TodoRepositoryProtocol.swift
//  PracticeAddFlutterToIos
//
//  Created by Jonghyuck Jeon on 8/29/25.
//

import Foundation

protocol TodoRepositoryProtocol {
    func loadTodos() async throws -> [Todo]
    func saveTodos(_ todos: [Todo]) async throws
}
