//
//  LoginCredentials.swift
//  ReciMeProject
//
//  Created by Luis Pereira on 22/09/26.
//

import Foundation

struct LoginCredentials {
    let username: String
    let password: String
    
    var isValid: Bool {
        !username.isEmpty && !password.isEmpty
    }
}
