//
//  Checkline.swift
//  iChecks
//
//  Created by Christophe Guégan on 16/02/2025.
//

import SwiftUI
import Firebase


struct Checkline: Identifiable, Codable, Equatable {
    
    var id:         String
    var title:      String
    var order:      Int
    var action:     String
    var notes:      String
    var type:       ItemType
    var isChecked:  Bool
    var checkedAt:  Date?
    var itemNumber: Int?
    
    
    // MARK: - Computed Properties
    // ———————————————————————————

    var itemString: String {
        return String(format: "%02d", order)
    }

    static func == (lhs: Checkline, rhs: Checkline) -> Bool {
        return lhs.id == rhs.id
    }
    
    
    // MARK: - Coding Keys
    // ———————————————————
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case order
        case action
        case notes
        case type
        case isChecked  = "is_checked"
        case checkedAt  = "checked_at"
        case itemNumber = "item_number"
    }
    
    
    // MARK: - Default initializer
    // ———————————————————————————
    
    init( id: String = UUID().uuidString,
          title: String,
          order: Int,
          action: String,
          notes: String = "",
          type: ItemType = ItemType.item,
          isChecked: Bool = false,
          checkedAt: Date? = nil,
          itemNumber: Int? = 0 ) {
        self.id = id
        self.title = title
        self.order = order
        self.action = action
        self.notes = notes
        self.type = type
        self.isChecked = isChecked
        self.checkedAt = checkedAt
        self.itemNumber = 0
    }
    
    
    // MARK: - Methods
    // ———————————————
    
    /// Reset the checkline
//    func reset() {
//        self.isChecked = false
//        self.checkedAt = nil
//    }
    
}
