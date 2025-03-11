//
//  UserRole.swift
//  IsmConcept
//
//  Created by Christophe Guégan on 05/03/2025.
//

import Foundation

enum UserRole: String, CaseIterable, Codable {
    
    case admin    = "admin"
    case director = "director"
    case editor   = "editor"
    case manager  = "manager"
    case captain  = "captain"
    case officer  = "officer"
    case crew     = "crew"
    case surveyor = "surveyor"
    case guest    = "guest"
    case none     = "none"
    
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
    
    var canEditVesselInfo: Bool {
        return self == .captain || self == .admin
    }
    
    var canEditChecklists: Bool {
        return level >= UserRole.officer.level
    }
    
    var canViewAllVessels: Bool {
        return self == .admin
    }
    
    static func < (lhs: UserRole, rhs: UserRole) -> Bool {
        return lhs.level < rhs.level
    }
}
