//
//  Checklisft+Mock.swift
//  iChecks
//
//  Created by Christophe Guégan on 18/02/2025.
//

import Foundation

// MARK: - Mock Data
// —————————————————

extension Checklist {
    
    static var sample: Checklist {
        let checklist = Checklist(
                title:          "Pre-Departure",
                order:          0,
                department:     .bridge,
                notes:          LoremIpsum.medium,
                checklines: [
                    Checkline( title:  "Safety",
                               order:  0,
                               action: "",
                               notes:  "",
                               type:   .section),
                    Checkline( title:  "Fire Extinguisher",
                               order:  1,
                               action: "Checked",
                               notes:  "Check the fire extinguisher is in place.",
                               type:   ItemType.item),
                    Checkline( title:  "Fire Alarm",
                               order:  2,
                               action: "Checked",
                               notes:  "Check the fire alarm is working.",
                               type:   .item),
                    Checkline( title:  "Emergency Exit",
                               order:  3,
                               action: "Checked",
                               notes:  "Check the emergency exit is clear.",
                               type:   .item),
                    Checkline( title:  "",
                               order:  3,
                               action: "",
                               notes:  LoremIpsum.medium,
                               type:   .note)
                ]
            )
        
        /// Return the checklist
        return checklist
    }
    
}
