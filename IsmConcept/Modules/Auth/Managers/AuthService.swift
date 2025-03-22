//
//  AuthManager.swift
//  IsmConcept
//
//  Created by Christophe Guégan on 11/8/24.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

@Observable
class AuthService {
    
    /// Current user
    private(set) var authenticatedUser: FirebaseAuth.User?
    
    /// Auth state listener handle
    private var authStateHandle: AuthStateDidChangeListenerHandle?

    /// Initialize the AuthService
    ///
    init() {
        setupAuthStateListener()
    }
    
    /// Deinitialize the AuthService
    ///
    deinit {
        if let handle = authStateHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    /// Setup the Auth State Listener
    /// - Note: This method will listen to the authentication state changes.
    ///         If the handle detect a change of user, it will automatically fetch
    ///         the new user data. If the user is nil, it will reset the user status and
    ///         logout.
    ///
    private func setupAuthStateListener() {
        authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] (_, user) in
            
            /// Ensure self is not nil
            guard let _ = self else {
                print("[ ERROR ] AuthService deallocated")
                return
            }
            
            print("[ DEBUG ] Auth state changed: \(user?.uid ?? "No user")")
            
            /// Update the current user
            Task { @MainActor in
                if let user = user {
                    await AppManager.shared.setupUser(user.uid)
                } else {
                    AppManager.shared.resetUser()
                }
            }
        }
    }
    
    /// Login a user
    /// - Parameters: email: The user email
    ///               password: The user password
    /// - Throws:     AuthError
    ///
    @MainActor
    func signIn(email: String, password: String) async throws {
        AppManager.shared.state = .loading
        do {
            let _ = try await Auth.auth().signIn(withEmail: email, password: password).user
            AppManager.shared.resetError()
            AppManager.shared.state = .signedIn
        } catch {
            print("[ ERROR ] Failed to sign in user: \(error)")
            AppManager.shared.showError(error.localizedDescription)
            AppManager.shared.state = .signedOut
        }
    }
    
    /// Signup a new user
    /// - Parameters:
    ///     - email: The user email
    ///     - password: The user password
    ///     - displayName: The user display name
    ///     - role: The user role: default is .crew
    ///     - vesselId: The user vessel ID
    /// - Throws: AuthError
    /// - Note: This method will create the user in Firebase Auth and Firestore database.
    ///
    @MainActor
    func signup( email: String,
                 password: String,
                 displayName: String,
                 role: UserRole = .crew,
                 vesselId: String? = nil,
                 vesselName: String? = nil) async throws {
        do {
            // Create the user in Firebase Auth
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
            let userId = authResult.user.uid
            
            // Create the user document in Firestore database
            let newUser = User( id:          userId,
                                email:       email,
                                displayName: displayName,
                                role:        role,
                                vesselId:    vesselId,
                                vesselName:  vesselName,
                                createdAt:   Date(),
                                updatedAt:   Date(),
                                lastLogin:   Date())
            
            try Firebase.userCollection.document(userId).setData(from: newUser)
            
            // The auth state listener will handle loading the user data
            
        } catch {
            AppManager.shared.showError(error.localizedDescription)
        }
    }
    
    /// Sign out the current user
    /// - Throws: AuthError
    ///
    @MainActor
    func signOut() async throws {
        AppManager.shared.state = .loading
        do {
            print("[ DEBUG ] Signing out user")
    
            try Auth.auth().signOut()
            self.authenticatedUser = nil
            AppManager.shared.resetUser()
            AppManager.shared.resetError()
        } catch {
            AppManager.shared.showError(error.localizedDescription)
            AppManager.shared.resetUser()
        }
    }
}
