//
//  User+Samples.swift
//  IsmConcept
//
//  Created by Christophe Guégan on 08/03/2025.
//

import Foundation

extension User {
    static let samples: [User] = [
        .init( name:     "Christophe Guégan",
               email:    "cguegan@gmail.com",
               role:     UserRole.admin,
               vesselID: "Yachting Concept Monaco" ),
        .init( name:     "John Doe",
               email:    "johndoe@example.com",
               role:     UserRole.crew,
               vesselID: "Windsor" ),
        .init( name:     "Jane Doe",
               email:    "jane@example.com",
               role:     UserRole.crew,
               vesselID: "Windsor" )
    ]
}

