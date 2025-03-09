//
//  ExecChecklist.swift
//  iChecks
//
//  Created by Christophe Guégan on 28/12/2024.
//

import Foundation
import Firebase
import FirebaseFirestore
import PencilKit

struct ExecutedChecklist: Identifiable, Codable {
    
    @DocumentID
    var id: String?
    var title: String
    var notes: String
    var department: Department
    var completionState: Double
    var name: String
    var position: String
    var latitude: Double
    var longitude: Double
    var place: String
    var country: String
    var checklines: [Checkline]
    var signature: PKDrawing
    var executedAt: Date = Date()

}
