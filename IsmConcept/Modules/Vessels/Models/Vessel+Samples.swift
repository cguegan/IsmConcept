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
                name: "Mimtee",
                isActive: true,
                imo: "9771418",
                master: "Thierry Roux",
                type: .motor,
                loa: 78.9,
                beam: 12.0,
                draft: 4.5,
                gt: 1299,
                year: 2019,
                users: [],
                crew: 24,
                guests: 12,
                flag: .mi,
                classComp: .lr,
                homePort: "Bikini",
                location: "Monaco",
                imageUrl: "Image 1",
                logoUrl: "Logo 1",
                createdAt: Date(),
                updatedAt: Date(),
                backupAt: Date() ),
        Vessel( id: "2",
                name: "Madame Kate",
                isActive: true,
                imo: "1011654",
                master: "Daniel Sola",
                type: .motor,
                loa: 60.6,
                beam: 10.32,
                draft: 3.55,
                gt: 1120,
                year: 2015,
                users: [],
                crew: 17,
                guests: 12,
                flag: .cisr,
                homePort: "George Town",
                location: "Antibes",
                imageUrl: "https://image.yachtcharterfleet.com/w1277/h618/qh/ca/m2/ke274fce6/vessel/resource/305623/charter-madame-kate-yacht.jpg",
                logoUrl: "Logo 2",
                createdAt: Date(),
                updatedAt: Date(),
                backupAt: Date() ),
        Vessel( id: "3",
                name: "Were Dreams",
                isActive: true,
                imo: "IMO 3",
                master: "Jean-Louis Carrel / Christophe Guegan",
                type: .motor,
                loa: 52.0,
                beam: 9.0,
                draft: 3.4,
                gt: 642,
                year: 2008,
                users: [],
                crew: 13,
                guests: 11,
                flag: .cisr,
                homePort: "George Town",
                location: "Cannes",
                imageUrl: "https://image.yachtcharterfleet.com/w1277/h618/qh/ca/m2/k32503269/vessel/resource/85745/charter-were-dreams-yacht.jpg",
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
