//
//  DataModel.swift
//  ToDo List
//
//  Created by Andrey Zhelev on 23.11.2024.
//
import Foundation

struct ToDos: Codable {
    let todos: [ToDo]
    let total, skip, limit: Int
}

struct ToDo: Codable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}
