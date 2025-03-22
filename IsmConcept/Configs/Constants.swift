//
//  Constants.swift
//  IsmConcept
//
//  Created by Christophe Guégan on 21/03/2025.
//

import Foundation
import Firebase


struct Constants {
    static let appName = "IsmConcept"
    static let appVersion = "0.2.0"
    static let appBuild = "1"
    static let appStoreId = "1234567890"
    static let appStoreUrl = "https://apps.apple.com/app/id\(appStoreId)"
    static let appSupportEmail = "cguegan@gmail.com"
    static let debugMode = true
}

/// Firestore database references
struct Firebase {
    static let db = Firestore.firestore()
    static let userCollection = db.collection("users")
    static let vesselCollection = db.collection("vessels")
}
