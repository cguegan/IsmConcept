//
//  AuthManager.swift
//  IsmConcept
//
//  Created by Christophe Guégan on 11/8/24.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

@Observable
@MainActor
class AuthManager {

    /// Published properties
    var userSession: FirebaseAuth.User?
    var user: User    = User(name: "", email: "", isActive: false)
    var vessel:Vessel = Vessel(name: "")
    var loginStatus   = LoginStatus.loggedOut
    
    /// Shared instance
    static let shared = AuthManager()
    
    /// Firestore error messages
    let errorTitle = "Authentication Error"
    var errorMessage = ""
    var showErrorAlert: Bool = false

    /// Firestore database reference
    ///
    let db = Firestore.firestore()
    let collectionName = "users"
    
    /// Private initializer
    ///
    private init() {
        self.userSession = Auth.auth().currentUser
//        self.defineStatus()
    }
    
//    private func defineStatus() {
//        if self.userSession == nil {
//            loginStatus = .loggedOut
//        } else {
//            if let user = self.fetchUser {
//                
//            }
//        }
//    }
    
    /// Get the Firestore Collection Reference
    ///
    private func dbRef() -> CollectionReference {
        return db.collection(collectionName)
    }
    
    /// Login user with email and password
    /// - Parameters:   - email: email address
    ///                - password: password
    ///
    @MainActor
    func login(withEmail email: String, password: String) async throws {
        print("[ DEBUG ] Logging in with email: \(email)...")
        self.loginStatus = .checking
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            print("[ DEBUG ] User logged in successfully with ID: \(result.user.uid)")
            await self.fetchUser()
        } catch {
            throw NSError(domain: "Failed to sign in with error \(error.localizedDescription)", code: 0)
        }
    }
    
    /// Sign out user
    /// - Returns: Void
    ///
    /// 1. Sign out from firebase
    /// 2. Set user session to nil
    /// 3. Reset user
    /// 4. Reset vessel
    ///
    func signOut() {
        try? Auth.auth().signOut()
        self.userSession = nil
        self.user = User( name: "", email: "", isActive: false )
        self.vessel = Vessel(name: "")
        self.loginStatus = .loggedOut
    }
    
    /// Create user with email and password when the form is submited
    /// - Parameters:   - email: email address
    ///                 - password: password
    /// - Throws:       Error if user creation fails
    /// - Returns:      Optional user
    ///
    @MainActor
    func createUser(withEmail email: String, password: String, name: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            
            print("[ DEBUG ] Auth User created successfully with ID: \(result.user.uid)")
            
            // Create the vessel in the model context
            let user = User( name:     name,
                             email:    email,
                             role:     .none,
                             isActive: false )
            
            // Backup the user to firebase
            try self.add(user)
                        
            // Return the user
            self.user = user
            
        } catch {
            throw NSError(domain: "Failed to create user with error \(error.localizedDescription)", code: 0)
        }
    }
    
    /// Create user for a vessel
    /// - Parameters:   - vessel: The vessel to create the user for
    ///                - email: email address
    ///                - password: password
    ///                - name: user name
    /// - Returns: Optional user
    ///
    @MainActor
    func createUser(for vessel: Vessel, withEmail email: String, password: String, name: String) async throws -> User? {
        do {
            /// Create User
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            
            print("[ DEBUG ] Auth User created successfully with ID: \(result.user.uid)")
            
            /// Create the user in the vessel context
            let user = User( id:       result.user.uid,
                             name:     name,
                             email:    email,
                             role:     .crew,
                             isActive: true,
                             vesselID: vessel.id,
                             vessel:   vessel.name )
            
            /// Backup the user to firebase
            try self.add(user)
            return user
        } catch {
            throw NSError(domain: "Failed to create user with error \(error.localizedDescription)", code: 0)
        }
    }
    
    /// Reset the user password
    /// - Returns: Void
    func resetPassword() {
        // TODO: - code to reset password
    }
    
    /// Add a new user to Firestore database
    /// - Parameter user: The user to add
    /// - Returns: Void
    ///
    func add(_ user: User) throws {
        guard let id = user.id else { return }
        do {
            try dbRef().document(id).setData(from: user)
        } catch {
            throw NSError(domain: "Failed to add user to Firestore.", code: 0)
        }
    }
    
    /// Get the user from Firestore
    ///
    func fetchUser() async {
        
        /// Check if user is authenticated
        guard let id = self.userSession?.uid else { return }
        
        /// Get the user from Firestore
        print("[ DEBUG ] Fetching user with ID: \(id)...")
        do {
            self.user = try await dbRef().document(id).getDocument(as: User.self)
            if user.isActive {
                self.loginStatus = .active
            } else {
                self.loginStatus = .inactive
            }
        } catch {
            self.errorMessage = "Failed to get user with error \(error.localizedDescription)"
            self.showErrorAlert = true
            print("[ ERROR ] Failed to get user with error \(error.localizedDescription)")
        }
        
    }
    
    /// Get the vessel of the current user
    ///
    func fetchVessel() async {
        
        /// Check is current user has a vessel id
        guard let vesselID = user.vesselID else { return }
        
        /// Try to load vessel
        print("[ DEBUG ] Fetched vessel with id: \(vesselID)")
        if let vessel = await VesselStore.shared.get(withID: vesselID) {
            self.vessel = vessel
        }
    }
    
    
}
