//
//  TodoUseCase.swift
//  PracticeAddFlutterToIos
//
//  Created by Jonghyuck Jeon on 8/29/25.
//

import Foundation

struct TodoUseCase {
    let repository: TodoRepositoryProtocol
    
    func loadTodos() async -> [Todo] {
        do {
            return try await repository.loadTodos()
        } catch {
            print("Failed to load todos: \(error)")
            return []
        }
    }
    
    func saveTodos(_ todos: [Todo]) async {
        do {
            try await repository.saveTodos(todos)
        } catch {
            print("Failed to save todos: \(error)")
        }
    }
    
    func addTodo(title: String, to todos: [Todo]) -> [Todo] {
        var updatedTodos = todos
        updatedTodos.append(Todo(title: title))
        return updatedTodos
    }
    
    func toggleTodo(id: UUID, in todos: [Todo]) -> [Todo] {
        todos.map { todo in
            todo.id == id ?
            Todo(id: todo.id, title: todo.title, isCompleted: !todo.isCompleted, createdAt: todo.createdAt) :
            todo
        }
    }
    
    func deleteTodo(id: UUID, from todos: [Todo]) -> [Todo] {
        todos.filter { $0.id != id }
    }
    
    func updateTodo(id: UUID, newTitle: String, in todos: [Todo]) -> [Todo] {
        todos.map { todo in
            todo.id == id ?
            Todo(id: todo.id, title: newTitle, isCompleted: todo.isCompleted, createdAt: todo.createdAt) :
            todo
        }
    }
}
