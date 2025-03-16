//
//  Classification.swift
//  IsmConcept
//
//  Created by Christophe Guégan on 10/03/2025.
//

import Foundation

enum Classification: String, CaseIterable, Codable, Identifiable {
    
    case lr   = "LR"
    case bv   = "BV"
    case abs  = "ABS"
    case rina = "RINA"
    case dnv  = "DNV"
    case none = "None"
    
    var id: String { self.rawValue }
    
    var description: String {
        switch self {
        case .lr:
            return "Lloyd's Register"
        case .bv:
            return "Bureau Veritas"
        case .abs:
            return "American Bureau of Shipping"
        case .rina:
            return "Registro Italiano Navale"
        case .dnv:
            return "Det Norske Veritas"
        case .none:
            return "N/A"
        }
    }
    
}
