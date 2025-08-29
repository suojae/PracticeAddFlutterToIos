//
//  TodoListView.swift
//  PracticeAddFlutterToIos
//
//  Created by Jonghyuck Jeon on 8/29/25.
//

import SwiftUI
import ComposableArchitecture

struct TodoListView: View {
    @Bindable var store: StoreOf<TodoListReducer>
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // 입력 섹션
                VStack {
                    HStack {
                        TextField(
                            "새 할일을 입력하세요",
                            text: $store.newTodoTitle
                        )
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onSubmit {
                            store.send(.addTodoTapped)
                        }
                        
                        Button("추가") {
                            store.send(.addTodoTapped, animation: .spring())
                        }
                        .disabled(store.newTodoTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        .buttonStyle(.borderedProminent)
                    }
                    
                    // 필터 섹션
                    Picker("Filter", selection: $store.filter) {
                        ForEach(TodoFilter.allCases, id: \.self) { filter in
                            Text(filter.rawValue).tag(filter)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .padding()
                .background(Color(.systemGroupedBackground))
                
                // 할일 목록
                if store.isLoading {
                    Spacer()
                    ProgressView("로딩 중...")
                    Spacer()
                } else if store.filteredTodos.isEmpty {
                    Spacer()
                    VStack {
                        Image(systemName: "checkmark.circle")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("할일이 없습니다")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                } else {
                    List {
                        ForEach(store.filteredTodos) { todo in
                            TodoRowView(
                                todo: todo,
                                onToggle: {
                                    store.send(.toggleTodo(id: todo.id), animation: .easeInOut)
                                },
                                onDelete: {
                                    store.send(.deleteTodo(id: todo.id), animation: .easeOut)
                                }
                            )
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                let todo = store.filteredTodos[index]
                                store.send(.deleteTodo(id: todo.id), animation: .easeOut)
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("할일 목록")
            .onAppear {
                store.send(.viewDidLoad)
            }
        }
    }
}

// MARK: - TodoRowView
struct TodoRowView: View {
    let todo: Todo
    let onToggle: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onToggle) {
                Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(todo.isCompleted ? .green : .gray)
                    .font(.title2)
            }
            .buttonStyle(PlainButtonStyle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(todo.title)
                    .font(.body)
                    .strikethrough(todo.isCompleted, color: .gray)
                    .foregroundColor(todo.isCompleted ? .gray : .primary)
                
                Text(todo.createdAt.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
                    .font(.body)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
    }
}

// MARK: - Preview
#Preview {
    TodoListView(
        store: Store(initialState: TodoListReducer.State()) {
            TodoListReducer()
        }
    )
}
