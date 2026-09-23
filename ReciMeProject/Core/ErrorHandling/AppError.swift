//
//  AppError.swift
//  ReciMeProject
//
//  Created by Luis Pereira on 22/09/26.
//

import Foundation

enum AppError: LocalizedError {
    // Authentication Errors
    case authenticationFailed(reason: String)
    case unauthorized
    case sessionExpired
    
    // Network Errors
    case networkUnavailable
    case serverError(statusCode: Int)
    case timeout
    case invalidResponse
    
    // Data Errors
    case dataNotFound
    case decodingFailed(error: Error)
    case invalidData
    
    // Recipe Errors
    case recipeNotFound(id: String)
    case recipeFetchFailed(reason: String)
    
    // Storage Errors
    case saveFailed
    case loadFailed
    case deleteFailed
    
    // Validation Errors
    case validationFailed(field: String, reason: String)
    case emptyField(field: String)
    
    // Unknown
    case unknown(error: Error)
    
    var errorDescription: String? {
        switch self {
        case .authenticationFailed(let reason):
            return "Authentication failed: \(reason)"
        case .unauthorized:
            return "You are not authorized to perform this action"
        case .sessionExpired:
            return "Your session has expired. Please login again."
            
        case .networkUnavailable:
            return "No internet connection. Please check your network."
        case .serverError(let statusCode):
            return "Server error occurred (Status: \(statusCode))"
        case .timeout:
            return "Request timed out. Please try again."
        case .invalidResponse:
            return "Invalid response from server"
            
        case .dataNotFound:
            return "Data not found"
        case .decodingFailed:
            return "Failed to process data"
        case .invalidData:
            return "Invalid data format"
            
        case .recipeNotFound(let id):
            return "Recipe not found (ID: \(id))"
        case .recipeFetchFailed(let reason):
            return "Failed to fetch recipes: \(reason)"
            
        case .saveFailed:
            return "Failed to save data"
        case .loadFailed:
            return "Failed to load data"
        case .deleteFailed:
            return "Failed to delete data"
            
        case .validationFailed(let field, let reason):
            return "\(field): \(reason)"
        case .emptyField(let field):
            return "\(field) cannot be empty"
            
        case .unknown(let error):
            return "An unexpected error occurred: \(error.localizedDescription)"
        }
    }
    
    var userFriendlyMessage: String {
        switch self {
        case .authenticationFailed:
            return "Login failed. Please check your credentials."
        case .unauthorized:
            return "Access denied"
        case .sessionExpired:
            return "Session expired. Please login again."
            
        case .networkUnavailable:
            return "No internet connection"
        case .serverError:
            return "Server is having issues. Please try again later."
        case .timeout:
            return "Request took too long. Please try again."
        case .invalidResponse:
            return "Something went wrong. Please try again."
            
        case .dataNotFound:
            return "Content not available"
        case .decodingFailed, .invalidData:
            return "Unable to load content"
            
        case .recipeNotFound:
            return "Recipe not available"
        case .recipeFetchFailed:
            return "Unable to load recipes"
            
        case .saveFailed:
            return "Failed to save"
        case .loadFailed:
            return "Failed to load"
        case .deleteFailed:
            return "Failed to delete"
            
        case .validationFailed(_, let reason):
            return reason
        case .emptyField(let field):
            return "\(field) is required"
            
        case .unknown:
            return "Something went wrong"
        }
    }
    
    var severity: LogLevel {
        switch self {
        case .authenticationFailed, .unauthorized, .sessionExpired:
            return .warning
        case .networkUnavailable, .timeout:
            return .warning
        case .serverError:
            return .error
        case .dataNotFound, .recipeNotFound:
            return .info
        case .decodingFailed, .invalidData, .invalidResponse:
            return .error
        case .recipeFetchFailed:
            return .error
        case .saveFailed, .loadFailed, .deleteFailed:
            return .error
        case .validationFailed, .emptyField:
            return .debug
        case .unknown:
            return .error
        }
    }
}
