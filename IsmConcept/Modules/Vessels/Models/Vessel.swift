//
//  Vessel.swift
//  IsmConcept
//
//  Created by Christophe Guégan on 05/03/2025.
//

import Foundation
import FirebaseFirestore

struct Vessel: Identifiable, Codable {
    
    @DocumentID
    var id:        String?
    var name:      String
    var isActive:  Bool
    var imo:       String
    var master:    String
    var type:      VesselType
    var loa:       Double
    var beam:      Double
    var draft:     Double
    var gt:        Int
    var year:      Int
    var users:     [User] = []
    var crew:      Int
    var guests:    Int
    var flag:      Flag
    var homePort:  String
    var location:  String
    var imageUrl:  String
    var createdAt: Date?
    var updatedAt: Date?
    var backupAt:  Date?
    
}

extension Vessel {
    
    /// Coding Keys
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case isActive = "is_active"
        case imo
        case master
        case type
        case loa
        case beam
        case draft
        case gt
        case year
        case users
        case crew
        case guests
        case flag
        case homePort = "home_port"
        case location
        case imageUrl = "image_url"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case backupAt = "backup_at"
    }
    
}

