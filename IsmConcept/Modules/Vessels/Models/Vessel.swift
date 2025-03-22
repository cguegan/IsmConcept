//
//  Vessel.swift
//  IsmConcept
//
//  Created by Christophe Guégan on 05/03/2025.
//

import Foundation
import FirebaseFirestore

struct Vessel: Identifiable, Codable, Hashable {
    
    @DocumentID
    var id:         String?
    var name:       String
    var isActive:   Bool
    var imo:        String
    var master:     String
    var type:       VesselType
    var loa:        Double
    var beam:       Double
    var draft:      Double
    var gt:         Int
    var year:       Int
    var users:      [String] = []
    var crew:       Int
    var guests:     Int
    var flag:       Flag
    var classComp:  Classification
    var homePort:   String
    var location:   String
    var imageUrl:   String?
    var logoUrl:    String?
    var createdAt:  Date?
    var updatedAt:  Date?
    var backupAt:   Date?
    
    init(
        id: String? = nil,
        name: String,
        isActive: Bool    = false,
        imo: String       = "",
        master: String    = "",
        type: VesselType  = .company,
        loa: Double       = 0.0,
        beam: Double      = 0.0,
        draft: Double     = 0.0,
        gt: Int           = 0,
        year: Int         = 0,
        users: [String]   = [],
        crew: Int         = 0,
        guests: Int       = 0,
        flag: Flag        = .mc,
        classComp:      Classification = .none,
        homePort: String  = "",
        location: String  = "",
        imageUrl: String? = nil,
        logoUrl: String?  = nil,
        createdAt: Date?  = nil,
        updatedAt: Date?  = nil,
        backupAt: Date?   = nil
    ) {
        self.id        = id
        self.name      = name
        self.isActive  = isActive
        self.imo       = imo
        self.master    = master
        self.type      = type
        self.loa       = loa
        self.beam      = beam
        self.draft     = draft
        self.gt        = gt
        self.year      = year
        self.users     = users
        self.crew      = crew
        self.guests    = guests
        self.flag      = flag
        self.classComp = classComp
        self.homePort  = homePort
        self.location  = location
        self.imageUrl  = imageUrl
        self.logoUrl   = logoUrl
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.backupAt  = backupAt
    }
    
}

extension Vessel {
    
    /// Coding Keys
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case isActive  = "is_active"
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
        case classComp = "class_comp"
        case homePort  = "home_port"
        case location
        case imageUrl  = "image_url"
        case logoUrl   = "logo_url"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case backupAt  = "backup_at"
    }
    
}

