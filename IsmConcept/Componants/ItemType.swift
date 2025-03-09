//
//  ItemType.swift
//  iChecks
//
//  Created by Christophe Guégan on 08/09/2024.
//

import Foundation

enum ItemType: String, Codable, CaseIterable, Identifiable {
    case item
    case section
    case note
    
    var id: Self { self }
    
    var description: String {
        switch self {
        case .item:
            return "Item"
        case .section:
            return "Section"
        case .note:
            return "Notes"
        }
    }
    
    var icon: String {
        switch self {
        case .item:
            return "checkmark.square"
        case .section:
            return "line.3.horizontal"
        case .note:
            return "text.alignleft"
        }
    }
}
