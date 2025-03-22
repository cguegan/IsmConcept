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
import FirebaseAuth



@Observable
class AppManager {
    
    static let shared = AppManager()
    
    /// The user of the app
    var user: User = User.nullUser
    var vessel: Vessel = Vessel.nullVessel
    var state: AuthState = AuthState.loading
    var errorMessage: String = ""
    var showErrorAlert: Bool = false
    
    /// Private initializer to prevent multiple instances
    ///
    private init() {}
    
    /// Set up the user
    /// - Parameter authUserId: The auth user id
    ///
    @MainActor
    func setupUser(_ authUserId: String?) async {
        Task {
            print("[ DEBUG ] Setting up user in AppManager")
            self.state = .loading

            guard let authUserId = authUserId else {
                print("[ ERROR ] Auth user id is nil when trying to set up user in AppManager")
                return
            }
            
            /// Fetch the user data
            ///
            guard let user = await self.fetchUser(authUserId: authUserId) else {
                print("[ ERROR ] Failed to fetch user data")
                return
            }
            
            self.user = user
            
            /// Fetch the vessel data
            ///
            if let vessel = await self.fetchVessel(user.vesselId) {
                self.vessel = vessel
            }
                
            /// Set the login state
            ///
            if self.user.isActive && self.vessel.isActive {
                self.state = .signedIn
            } else if self.user.isActive && self.user.isManager() {
                self.state = .signedIn
            } else {
                self.state = .inactive
            }
            
            /// Reset the error if everything is ok
            self.resetError()
        }
    }
    
    /// Fetch user data from Firestore
    /// - Parameters: userId: The user ID
    /// - Throws: DatabaseError
    ///
    private func fetchUser(authUserId: String) async -> User? {
        do {
            let documentSnapshot = try await Firebase.userCollection.document(authUserId).getDocument()
            
            guard documentSnapshot.exists else {
                print("[ ERROR ] User not found")
                AppManager.shared.showError("User not found")
                return nil
            }
            
            guard let user = try? documentSnapshot.data(as: User.self) else {
                print("[ ERROR ] Failed to decode user data")
                AppManager.shared.showError("Failed to decode user data")
                return nil
            }
            
            print("[ DEBUG ] Got user data: \(user.displayName)")
            print("[ DEBUG ] Got user data: \(user.role.level)")
            
            // Update last login time
            try? await updateLastLogin(userId: authUserId)
            return user
        } catch {
            print("[ ERROR ] Failed to fetch user data: \(error)")
            AppManager.shared.showError(error.localizedDescription)
            return nil
        }
    }
    
    /// Fetch the vessel of the current user
    /// - Note: This function is called when the user is set
    ///
    func fetchVessel(_ vesselId: String?) async -> Vessel? {
        guard let vesselId = vesselId else {
            return nil
        }
        
        do {
            let document = try await Firebase.vesselCollection.document(vesselId).getDocument()
            let vessel =  try document.data(as: Vessel.self)
            print("[ DEBUG ] Got vessel with name: \(vessel.name)")
            self.resetError()
            return vessel
        } catch {
            print("[ ERROR ] Failed to fetch vessel with error: \(error.localizedDescription)")
            showError("Failed to fetch vessel with error: \(error.localizedDescription)")
            return nil
        }
    }
    
    /// Reset the user and the vessel
    /// - Note: This function is called when the user logs out
    ///
    func resetUser() {
        self.user = User.nullUser
        self.vessel = Vessel.nullVessel
        self.state = .signedOut
        try? Auth.auth().signOut()
    }
    
    /// Update last login
    /// - Parameters: userId: The user ID
    /// - Throws: DatabaseError
    /// - Note: This method will update the last login time for the user
    ///
    private func updateLastLogin(userId: String) async throws {
        do {
            try await Firebase.userCollection
                              .document(userId)
                              .updateData(["lastLogin": Date()])
            self.user.lastLogin = Date()
            self.resetError()
        } catch {
            print("[ ERROR ] Failed to update last login: \(error)")
            self.showError(error.localizedDescription)
        }
    }
    
    /// Show an error message
    ///
    func showError(_ message: String) {
        self.errorMessage = message
        self.showErrorAlert = true
    }
    
    /// Reset the error message
    ///
    func resetError() {
        self.errorMessage = ""
        self.showErrorAlert = false
    }
}
