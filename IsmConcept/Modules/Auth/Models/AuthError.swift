//
//  AuthError.swift
//  IsmConcept
//
//  Created by Christophe Guégan on 11/03/2025.
//

import Foundation

enum AuthError: LocalizedError, CustomStringConvertible {
    case userNotFound
    case invalidCredentials
    case serverError(String)
    case networkError
    case tooManyAttempts
    case databaseError(DatabaseError)
    case unknown(String)
    
    var errorDescription: String? {
        return self.description
    }
    
    var description: String {
        switch self {
        case .userNotFound:
            return "User not found. Please check your email."
        case .invalidCredentials:
            return "Invalid credentials. Please check your email and password."
        case .serverError(let message):
            return "Server error: \(message)"
        case .networkError:
            return "Network error. Please check your connection."
        case .tooManyAttempts:
            return "Too many login attempts. Please try again later."
        case .databaseError(let error):
            return "Database error: \(error.localizedDescription)"
        case .unknown(let message):
            return "Unknown error: \(message)"
        }
    }
}

// End of file
