//
//  DependencyContainer.swift
//  PracticeAddFlutterToIos
//
//  Created by Jonghyuck Jeon on 8/29/25.
//

import Foundation
import ComposableArchitecture

// MARK: - TodoUseCase를 TestDependencyKey로 구현
extension TodoUseCase: TestDependencyKey {
    public static let liveValue = TodoUseCase(
        repository: TodoRepository(
            dataSource: UserDefaultsDataSource()
        )
    )
    
    public static let testValue = TodoUseCase(
        repository: MockTodoRepository()
    )
    
    public static let previewValue = TodoUseCase(
        repository: PreviewTodoRepository()
    )
}

// MARK: - Mock Repository for Testing
final class MockTodoRepository: TodoRepositoryProtocol {
    private var todos: [Todo] = []
    private var shouldThrowError = false
    
    func loadTodos() async throws -> [Todo] {
        if shouldThrowError {
            throw TodoRepositoryError.loadFailed
        }
        return todos
    }
    
    func saveTodos(_ todos: [Todo]) async throws {
        if shouldThrowError {
            throw TodoRepositoryError.saveFailed
        }
        self.todos = todos
    }
    
    // Test Helper Methods
    func setShouldThrowError(_ shouldThrow: Bool) {
        shouldThrowError = shouldThrow
    }
    
    func setMockTodos(_ todos: [Todo]) {
        self.todos = todos
    }
}

// MARK: - Preview Repository
final class PreviewTodoRepository: TodoRepositoryProtocol {
    private var sampleTodos: [Todo] = []
    
    init() {
        sampleTodos = [
            Todo(title: "TCA 공부하기"),
            Todo(title: "Clean Architecture 연습"),
            Todo(title: "UserDefaults 구현")
        ]
        
        // 완료된 할일도 하나 추가
        var completedTodo = Todo(title: "프로젝트 세팅 완료")
        sampleTodos.append(Todo(
            id: completedTodo.id,
            title: completedTodo.title,
            isCompleted: true,
            createdAt: completedTodo.createdAt
        ))
    }
    
    func loadTodos() async throws -> [Todo] {
        // 로딩 시뮬레이션
        try await Task.sleep(nanoseconds: 500_000_000)
        return sampleTodos
    }
    
    func saveTodos(_ todos: [Todo]) async throws {
        // 저장 시뮬레이션
        try await Task.sleep(nanoseconds: 100_000_000)
        sampleTodos = todos
    }
}

// MARK: - Repository Errors
enum TodoRepositoryError: Error, LocalizedError {
    case loadFailed
    case saveFailed
    case dataCorrupted
    
    var errorDescription: String? {
        switch self {
        case .loadFailed:
            return "할일 목록을 불러올 수 없습니다"
        case .saveFailed:
            return "할일 목록을 저장할 수 없습니다"
        case .dataCorrupted:
            return "데이터가 손상되었습니다"
        }
    }
}
