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
    case company
    case none
    
    var id: Self { self }
    
    var description: String {
        switch self {
            case .motor:   return "Motor Yacht"
            case .sailing: return "Sailing Yacht"
            case .company: return "Yachting Concept Monaco"
            case .none:    return "Null"
        }
    }
    
    var short: String {
        switch self {
            case .motor:   return "MY"
            case .sailing: return "SY"
            case .company: return "YCM"
            case .none:    return "N/A"
        }
    }
    
    var icon: String {
        switch self {
            case .motor:   return "ferry"
            case .sailing: return "sailboat"
            case .company: return "text.book.closed"
            case .none:    return "xmark"
        }
    }
}
