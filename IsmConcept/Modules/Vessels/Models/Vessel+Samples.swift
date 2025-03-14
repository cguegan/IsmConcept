//
//  Vessel+Samples.swift
//  IsmConcept
//
//  Created by Christophe Guégan on 09/03/2025.
//

import Foundation

extension Vessel {
    static let samples: [Vessel] = [
        Vessel( id: "1",
                name: "Vessel 1",
                isActive: true,
                imo: "IMO 1",
                master: "Master 1",
                type: .motor,
                loa: 100.0,
                beam: 10.0,
                draft: 5.0,
                gt: 1000,
                year: 2020,
                users: [],
                crew: 10,
                guests: 20,
                flag: .cisr,
                homePort: "Home Port 1",
                location: "Location 1",
                imageUrl: "Image 1",
                createdAt: Date(),
                updatedAt: Date(),
                backupAt: Date() ),
        Vessel( id: "2",
                name: "Vessel 2",
                isActive: true,
                imo: "IMO 2",
                master: "Master 2",
                type: .motor,
                loa: 200.0,
                beam: 20.0,
                draft: 10.0,
                gt: 2000,
                year: 2021,
                users: [],
                crew: 20,
                guests: 40,
                flag: .fr,
                homePort: "Home Port 2",
                location: "Location 2",
                imageUrl: "Image 2",
                createdAt: Date(),
                updatedAt: Date(),
                backupAt: Date() ),
        Vessel( id: "3",
                name: "Vessel 3",
                isActive: true,
                imo: "IMO 3",
                master: "Master 3",
                type: .motor,
                loa: 300.0,
                beam: 30.0,
                draft: 15.0,
                gt: 3000,
                year: 2022,
                users: [],
                crew: 30,
                guests: 60,
                flag: .mi,
                homePort: "Home Port 3",
                location: "Location 3",
                imageUrl: "Image 3",
                createdAt: Date(),
                updatedAt: Date(),
                backupAt: Date() )
    ]
    
    static let nullVessel: Vessel = Vessel( name: "",
                                            isActive: false,
                                            imo: "",
                                            master: "",
                                            type: .company)
        
}
