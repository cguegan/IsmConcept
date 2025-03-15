//
//  AppManager.swift
//  IsmConcept
//
//  Created by Christophe Guégan on 14/03/2025.
//  https://medium.com/ordinaryindustries/singletons-in-swift-friend-or-foe-0e8dce7e1661

import Foundation
import Observation
import Firebase
import FirebaseCore
import FirebaseFirestore



@Observable
class AppManager {
    
    static let shared = AppManager()
    
    /// The user of the app
    var user: User = User.nullUser
    var vessel: Vessel = Vessel.nullVessel
    var state: AuthState = AuthState.loading
    
    /// Private initializer to prevent multiple instances
    ///
    private init() {}
    
    /// Set up the user
    /// - Parameter user: The user to set up
    ///
    func setupUser(_ user: User?) {
        self.state = .loading
        if let user = user {
            self.user = user
            self.fetchVessel()
            self.state = .signedIn
        } else {
            self.state = .signedOut
            print("[ ERROR ] User is nil when trying to set up user in AppManager")
        }
    }
    
    /// Fetch the vessel of the current user
    /// - Note: This function is called when the user is set
    ///
    func fetchVessel() {
        
        /// Firestore database reference
        let db = Firestore.firestore()
        let collectionName = "vessels"
        
        /// Fetch the vessel
        Task {
            if let vesselId = user.vesselId {
                do {
                    let document = try await db.collection(collectionName).document(vesselId).getDocument()
                    let vessel =  try document.data(as: Vessel.self)
                    print("[ DEBUG ] Got vessel with name: \(vessel.name)")
                    self.vessel = vessel
                } catch {
                    print("[ ERROR ] Failed to get vessel with error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    /// Reset the user and the vessel
    /// - Note: This function is called when the user logs out
    func resetUser() {
        self.user = User.nullUser
        self.vessel = Vessel.nullVessel
        self.state = .signedOut
    }
    
}
