//
//  NavigationManager.swift
//  IsmConcept
//
//  Created by Christophe Guégan on 07/03/2025.
//

import Foundation
import SwiftUI

@MainActor
@Observable
class NavigationManager {
    
    var selectedModule: Module? = .home
    var checklists: [Checklist] = []
    
    /// Get the list of departments with checklists
    func getDepartmentsDict() -> [Department: [Checklist]] {
        var dict: [Department: [Checklist]] = [:]
        for checklist in checklists {
            if dict[checklist.department] == nil {
                dict[checklist.department] = []
            }
            dict[checklist.department]?.append(checklist)
        }
        return dict
    }
    
    /// Get the checklists
    func fetchChecklists() async {
//        do {
//            let checklists = try await ChecklistStore.shared.getChecklists()
//            self.checklists = checklists
//        } catch {
//            print("[ Error ] Failed to fetch checklists: \(error)")
//        }
    }
    
}

