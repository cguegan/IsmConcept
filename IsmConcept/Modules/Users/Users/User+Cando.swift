//
//  User+Cando.swift
//  IsmConcept
//
//  Created by Christophe Guégan on 15/03/2025.
//

import Foundation

extension User {
    
    /// Is Admin
    /// - Returns: true if the user is an app admin
    ///
    func isAdmin() -> Bool {
        return self.role.level == 1
    }
    
    /// Is Manager
    /// - Returns: true if the user is part of the management team
    ///
    func isManager() -> Bool {
        return self.role.level < 10
    }
    
    /// Is Crew member
    func isCrewMember() -> Bool {
        return self.role.level >= 10 && self.role.level < 100
    }
    
    /// Is Captain
    func isCaptain() -> Bool {
        return self.role.level == 10
    }
    
    /// A user can edit another user
    /// - if he is an admin or captain
    /// - if he has a higher role
    /// - if not himself
    /// - if captain or lower
    ///
    func canEditUser(_ user: User) -> Bool {
        
        if user.role.level < self.role.level {
            return false
        }
        
        if user.id == self.id {
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
    ///
    func canAddOrDeleteVessels() -> Bool {
        if self.role.level < 6 {
            return true
        } else {
            return false
        }
    }
    
    
}
