//
//  Todo.swift
//  PracticeAddFlutterToIos
//
//  Created by Jonghyuck Jeon on 8/29/25.
//

import Foundation

struct Todo: Equatable, Identifiable, Codable {
    let id: UUID
    var title: String
    var isCompleted: Bool
    let createdAt: Date
    
    init(title: String) {
        self.id = UUID()
        self.title = title
        self.isCompleted = false
        self.createdAt = Date()
    }
    
    init(id: UUID, title: String, isCompleted: Bool, createdAt: Date) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.createdAt = createdAt
    }
}
