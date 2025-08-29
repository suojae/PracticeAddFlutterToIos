//
//  TodoListReducer.swift
//  PracticeAddFlutterToIos
//
//  Created by Jonghyuck Jeon on 8/29/25.
//

import ComposableArchitecture
import Foundation

@Reducer
struct TodoListReducer {
    @ObservableState
    struct State: Equatable {
        var todos: [Todo] = []
        var newTodoTitle: String = ""
        var isLoading: Bool = false
        var filter: TodoFilter = .all
        
        var filteredTodos: [Todo] {
            switch filter {
            case .all:
                return todos
            case .completed:
                return todos.filter { $0.isCompleted }
            case .incomplete:
                return todos.filter { !$0.isCompleted }
            }
        }
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case viewDidLoad
        case newTodoTitleChanged(String)
        case addTodoTapped
        case toggleTodo(id: UUID)
        case deleteTodo(id: UUID)
        case filterChanged(TodoFilter)
        case todosLoaded([Todo])
        case todosSaved
    }
    
    @Dependency(TodoUseCase.self) var todoUseCase
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case .viewDidLoad:
                state.isLoading = true
                return .run { send in
                    let todos = await todoUseCase.loadTodos()
                    await send(.todosLoaded(todos))
                }
                
            case .newTodoTitleChanged(let title):
                state.newTodoTitle = title
                return .none
                
            case .addTodoTapped:
                guard !state.newTodoTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                    return .none
                }
                
                state.todos = todoUseCase.addTodo(title: state.newTodoTitle, to: state.todos)
                state.newTodoTitle = ""
                
                return .run { [todos = state.todos] send in
                    await todoUseCase.saveTodos(todos)
                    await send(.todosSaved)
                }
                
            case .toggleTodo(let id):
                state.todos = todoUseCase.toggleTodo(id: id, in: state.todos)
                
                return .run { [todos = state.todos] send in
                    await todoUseCase.saveTodos(todos)
                    await send(.todosSaved)
                }
                
            case .deleteTodo(let id):
                state.todos = todoUseCase.deleteTodo(id: id, from: state.todos)
                
                return .run { [todos = state.todos] send in
                    await todoUseCase.saveTodos(todos)
                    await send(.todosSaved)
                }
                
            case .filterChanged(let filter):
                state.filter = filter
                return .none
                
            case .todosLoaded(let todos):
                state.isLoading = false
                state.todos = todos
                return .none
                
            case .todosSaved:
                return .none
            }
        }
    }
}

enum TodoFilter: String, CaseIterable, Equatable {
    case all = "All"
    case completed = "Completed"
    case incomplete = "Incomplete"
}
