//
//  YachtType.swift
//  IsmConcept
//
//  Created by Christophe Guégan on 09/03/2025.
//

import Foundation

enum VesselType: String, Codable, CaseIterable, Identifiable {
    case motor
    case sailing
    
    var id: Self { self }
    
    var description: String {
        switch self {
            case .motor:   return "Motor Yacht"
            case .sailing: return "Sailing Yacht"
        }
    }
    
    var short: String {
        switch self {
            case .motor:   return "MY"
            case .sailing: return "SY"
        }
    }
    
    var icon: String {
        switch self {
            case .motor:   return "ferry"
            case .sailing: return "sailboat"
        }
    }
}
