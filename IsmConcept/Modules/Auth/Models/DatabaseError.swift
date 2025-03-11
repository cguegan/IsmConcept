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
}
