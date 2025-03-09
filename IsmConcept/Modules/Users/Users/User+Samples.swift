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
               vesselID: Vessel.samples[0].id ),
        .init( name:     "John Doe",
               email:    "johndoe@example.com",
               role:     UserRole.crew,
               vesselID: Vessel.samples[1].id ),
        .init( name:     "Jane Doe",
               email:    "jane@example.com",
               role:     UserRole.crew,
               vesselID: Vessel.samples[2].id )
    ]
}

