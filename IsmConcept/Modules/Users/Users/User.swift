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
    var id:          String?
    var email:       String
    var displayName: String
    var phoneNbr:    String?
    var role:        UserRole
    var isActive:    Bool
    var vesselId:    String?
    var vessel:      String?
    var imageUrl:    String?
    var createdAt:   Date?
    var updatedAt:   Date?
    var lastLogin:   Date?
    
    init(
        id: String?       = nil,
        email: String,
        displayName: String,
        phoneNbr: String? = nil,
        role: UserRole    = .crew,
        isActive: Bool    = false,
        vesselId: String? = nil,
        vessel: String?   = nil,
        createdAt: Date?  = Date(),
        updatedAt: Date?  = Date()
    ) {
        self.id          = id
        self.email       = email
        self.displayName = displayName
        self.phoneNbr    = phoneNbr
        self.role        = role
        self.isActive    = isActive
        self.vesselId    = vesselId
        self.vessel      = vessel
        self.createdAt   = createdAt
        self.updatedAt   = updatedAt
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
        case vessel
        case imageUrl    = "image_url"
        case createdAt   = "created_at"
        case updatedAt   = "updated_at"
        case lastLogin   = "last_login"
    }
    
}

extension User {
    
    /// Is Admin
    ///
    func isAdmin() -> Bool {
        return self.role.level < 10
    }
    
    /// A user can edit another user
    /// - if he has a higher role
    /// - if not himself
    /// - if captain or lower
    ///
    func canEditUser(_ user: User) -> Bool {
        
        if user.role.level <= self.role.level {
            return false
        }
        
        if user.id == self.id {
            return false
        }
        
        if self.role.level < 11 {
            return false
        }
            
        return true
    }
    
    /// A user can delete another user
    /// - if not himself
    /// - if captain of the same vessel
    /// - if he is an admin
    ///
    
    func canDeleteUser(_ user: User) -> Bool {
        
        if user.id == self.id {
            return false
        }
        
        if self.role.level == 10 && self.vesselId == user.vesselId {
            return true
        }
        
        if self.role.level < 10 {
            return true
        }
        
        return false
    }
    
    /// a User can edit a vessel
    /// - if he is an admin
    /// - if he is the captain of the same vessel
    ///
    func canEditVessel(_ vesselId: String) -> Bool {
        
        if self.role.level < 10 {
            return true
        }
        
        if self.vesselId == vesselId && self.role.level == 10 {
            return true
        }
        
        return false
    }
    
    /// a User can add of delete a vessel
    /// - if he is an admin
    /// - if he is director
    func canAddOrDeleteVessels() -> Bool {
        if self.role.level < 6 {
            return true
        } else {
            return false
        }
    }
}

