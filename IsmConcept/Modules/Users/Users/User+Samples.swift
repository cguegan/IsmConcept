//
//  User+Samples.swift
//  IsmConcept
//
//  Created by Christophe Guégan on 08/03/2025.
//

import Foundation

extension User {
    static let samples: [User] = [
        .init( email:       "cguegan@gmail.com",
               displayName: "Christophe Guégan",
               role:        UserRole.admin,
               vesselId:    Vessel.samples[0].id,
               imageUrl:    "https://picsum.photos/id/237/200/300" ),
        .init( email:       "johndoe@example.com",
               displayName: "John Doe",
               role:        UserRole.crew,
               vesselId:    Vessel.samples[1].id ),
        .init( email:       "jane@example.com",
               displayName: "Jane Doe",
               role:        UserRole.crew,
               vesselId:    Vessel.samples[2].id )
    ]
    
    static let nullUser = User(email: "", displayName: "", role: .none, isActive: false)
    
}

