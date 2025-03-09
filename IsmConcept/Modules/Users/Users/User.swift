//
//  User.swift
//  IsmConcept
//
//  Created by Christophe Guégan on 05/03/2025.
//

import Foundation
import FirebaseFirestore

struct User: Codable, Identifiable {
    
    @DocumentID
    var id:        String?
    var name:      String
    var email:     String
    var phoneNbr:  String?
    var role:      UserRole
    var isActive:  Bool
    var vesselID:  String?
    var vessel:    String?
    var imageUrl:  String?
    var createdAt: Date?
    var updatedAt: Date?
    
    init(
        id: String? = nil,
        name: String,
        email: String,
        phoneNbr: String? = nil,
        role: UserRole = .crew,
        isActive: Bool = false,
        vesselID: String? = nil,
        vessel: String? = nil,
        createdAt: Date? = Date(),
        updatedAt: Date? = Date()
    ) {
        self.id        = id
        self.name      = name
        self.email     = email
        self.phoneNbr  = phoneNbr
        self.role      = role
        self.isActive  = isActive
        self.vesselID  = vesselID
        self.vessel    = vessel
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
}

extension User {
    
    /// Coding Keys
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case phoneNbr  = "phone_number"
        case role
        case isActive  = "is_active"
        case vesselID  = "vessel_id"
        case vessel
        case imageUrl  = "image_url"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
}

