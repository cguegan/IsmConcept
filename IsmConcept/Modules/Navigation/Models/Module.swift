//
//  Module.swift
//  iChecks
//
//  Created by Christophe Guégan on 07/09/2024.
//

import Foundation

public enum Module: Hashable, Identifiable, Codable {
    
    case home
    case profile
    case checklists(department: Department)
    case safetyChecks
    case procedures
    case familiarisations
    case jobDescriptions
    case drillReports
    case noonReports
    case audits
    case companyDocuments
    case masterStandingOrders
    case yachtManuals
    case vessels
    case users
    case settings
    
    public var id: Self { self }
}
