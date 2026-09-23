//
//  User.swift
//  ReciMeProject
//
//  Created by Luis Pereira on 22/09/26.
//

import Foundation

struct User: Codable, Identifiable, Equatable {
    let id: UUID
    let username: String
    let email: String
    
    init(id: UUID = UUID(), username: String, email: String) {
        self.id = id
        self.username = username
        self.email = email
    }
}
