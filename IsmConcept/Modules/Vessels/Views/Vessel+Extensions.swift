//
//  Vessel+Extensions.swift
//  IsmConcept
//
//  Created by Christophe Guégan on 09/03/2025.
//

import Foundation

extension Vessel {
    
    /// Returns the initials of the vessel's name
    ///
    func initials() -> String? {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: name) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        
        return nil
    }
}
