//
//  Department.swift
//  iChecks
//
//  Created by Christophe Guégan on 16/11/24.
//

import Foundation

public enum Department: String, CaseIterable, Identifiable, Codable, Equatable {
    
    case emergency
    case bridge
    case engine
    case deck
    case service
    case interior
    case laundry
    case galley
    case none
    
    public var id: String {
        self.rawValue
    }
  
    var icon: String {
        switch self {
        case .emergency: return "exclamationmark.triangle"
        case .bridge: return "binoculars"
        case .engine: return "wrench.and.screwdriver"
        case .deck: return "ferry"
        case .service: return "fork.knife"
        case .interior: return "bed.double"
        case .laundry: return "washer"
        case .galley: return "cooktop"
        case .none: return "questionmark"
        }
    }
    
    var description: String {
        switch self {
        case .emergency: return "Emergency"
        case .bridge: return "Bridge"
        case .engine: return "Engine"
        case .deck: return "Deck"
        case .service: return "Service"
        case .interior: return "Interior"
        case .laundry: return "Laundry"
        case .galley: return "Galley"
        case .none: return "Not set"
        }
    }
    
}
