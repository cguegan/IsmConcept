//
//  DatabaseError.swift
//  IsmConcept
//
//  Created by Christophe Guégan on 11/03/2025.
//


enum DatabaseError: Error {
    case documentNotFound
    case decodingError
    case permissionDenied
    case networkError
    case unknown(String)
    
    var description: String {
        switch self {
        case .documentNotFound:
            return "Document not found."
        case .decodingError:
            return "Decoding error."
        case .permissionDenied:
            return "Permission denied."
        case .networkError:
            return "Network error. Please check your connection."
        case .unknown(let message):
            return "Unknown error: \(message)"
        }
    }
}
