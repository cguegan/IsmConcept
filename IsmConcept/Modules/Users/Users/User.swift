//
//  User.swift
//  IsmConcept
//
//  Created by Christophe Guégan on 05/03/2025.
//

import Foundation
import FirebaseFirestore

struct User: Codable, Identifiable, Hashable {
    
    @DocumentID
    var id:          String?
    var email:       String
    var displayName: String
    var phoneNbr:    String?
    var role:        UserRole
    var isActive:    Bool
    var vesselId:    String?
    var vesselName:  String?
    var imageUrl:    String?
    var createdAt:   Date?
    var updatedAt:   Date?
    var lastLogin:   Date?
    
    init(
        id: String?         = nil,
        email: String,
        displayName: String,
        phoneNbr: String?   = nil,
        role: UserRole      = .crew,
        isActive: Bool      = false,
        vesselId: String?   = nil,
        vesselName: String? = nil,
        imageUrl: String?   = nil,
        createdAt: Date?    = Date(),
        updatedAt: Date?    = Date(),
        lastLogin: Date?    = Date()
    ) {
        self.id          = id
        self.email       = email
        self.displayName = displayName
        self.phoneNbr    = phoneNbr
        self.role        = role
        self.isActive    = isActive
        self.vesselId    = vesselId
        self.vesselName  = vesselName
        self.imageUrl    = imageUrl
        self.createdAt   = createdAt
        self.updatedAt   = updatedAt
        self.lastLogin   = lastLogin
    }
    
}

extension User {
    
    /// Coding Keys
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case displayName = "display_name"
        case phoneNbr    = "phone_number"
        case role
        case isActive    = "is_active"
        case vesselId    = "vessel_id"
        case vesselName  = "vessel_name"
        case imageUrl    = "image_url"
        case createdAt   = "created_at"
        case updatedAt   = "updated_at"
        case lastLogin   = "last_login"
    }
    
    
}



