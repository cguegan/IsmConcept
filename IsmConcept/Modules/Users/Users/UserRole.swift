//
//  UserRole.swift
//  IsmConcept
//
//  Created by Christophe Guégan on 05/03/2025.
//

import Foundation

enum UserRole: Int, CaseIterable, Codable {
    
    case admin    = 1
    case director = 5
    case editor   = 6
    case manager  = 7
    case captain  = 10
    case officer  = 15
    case crew     = 20
    case surveyor = 100
    case guest    = 200
    case none     = 1000
    
    var level: Int {
        switch self {
            case .admin:    return 1
            case .director: return 5
            case .editor:   return 6
            case .manager:  return 7
            case .captain:  return 10
            case .officer:  return 15
            case .crew:     return 20
            case .surveyor: return 100
            case .guest:    return 200
            case .none:     return 1000
        }
    }
    
    var description: String {
        switch self {
            case .admin:    return "Administrator"
            case .director: return "Director"
            case .editor:   return "Editor"
            case .manager:  return "Manager"
            case .captain:  return "Captain"
            case .officer:  return "Officer"
            case .crew:     return "Crew"
            case .surveyor: return "Surveyor"
            case .guest:    return "Guest"
            case .none:     return "None"
        }
    }
    
}
