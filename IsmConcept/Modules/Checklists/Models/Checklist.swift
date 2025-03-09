//
//  Checklist.swift
//  iChecks
//
//  Created by Christophe Guégan on 26/11/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class Checklist: Identifiable, Codable {
    
    @DocumentID
    var id: String?
    var title: String = ""
    var order: Int = 0
    var department: Department = .none
    var notes: String = ""
    var checklines: [Checkline] = []
    var createdAt: Date = Date()
    var updatedAt: Date?
        
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case order
        case department
        case notes
        case checklines
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    
    // MARK: - Computed Properties
    // —————————————————————-—————

    /// Return the completion state as a double value from 0.0 to 1.0
    var completionState: Double {
        if itemsChecked > 0 {
            return Double(itemsChecked) / Double(totalLinesNbr)
        } else {
            return 0.0
        }
    }
    
    /// Return the number of currently checked checklines
    var itemsChecked: Int {
        return checklines.reduce(0) { itemsCount, item in
            if item.isChecked {
                return itemsCount + 1
            } else {
                return itemsCount
            }
        }
    }
    
    /// Return the total number of checklines
    var totalLinesNbr: Int {
        return checklines.reduce(0) { itemsCount, item in
            if item.type == .item {
                return itemsCount + 1
            } else {
                return itemsCount
            }
        }
    }
    
    /// Return the number of items in the checklist
    var itemsCount: Int {
        return checklines.count
    }
    
    /// Return items sorted by order
    var sortedItems: [Checkline] {
        checklines.sorted { $0.order < $1.order }
    }
    
    /// Return a string used for file name of the checklist
    var fileName: String {
        return "\(department.description + "_" + title.replacingOccurrences(of: " ", with: "_"))"
    }
    
    
    // MARK: - Initialization
    // —————————————————————-
    
    init( title: String,
          order: Int,
          department: Department,
          notes: String,
          checklines: [Checkline] = [],
          createdAt: Date = Date(),
          updatedAt: Date = Date()
    ) {
        self.title = title
        self.department = department
        self.notes = notes
        self.order = order
        self.checklines = checklines
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
}
