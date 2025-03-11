//
//  AuthError.swift
//  IsmConcept
//
//  Created by Christophe Guégan on 11/03/2025.
//


enum AuthError: Error {
    case userNotFound
    case invalidCredentials
    case serverError(String)
    case networkError
    case unknown(String)
    
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
        case .unknown(let message):
            return "Unknown error: \(message)"
        }
    }
}
