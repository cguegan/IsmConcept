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
    private(set) var currentUser: FirebaseAuth.User?
    private(set) var user: IsmConcept.User?
    private(set) var error: Error?
    
    /// Firestore database reference
    private let db = Firestore.firestore()
    private var authStateHandler: AuthStateDidChangeListenerHandle?
    private var collectionName = "users"
    
    /// Initialize the AuthService
    ///
    init() {
        setupAuthStateListener()
    }
    
    /// Deinitialize the AuthService
    ///
    deinit {
        if let handler = authStateHandler {
            Auth.auth().removeStateDidChangeListener(handler)
        }
    }
    
    /// Setup the Auth State Listener
    /// - Note: This method will listen to the authentication state changes
    /// 
    private func setupAuthStateListener() {
        authStateHandler = Auth.auth().addStateDidChangeListener { [weak self] (_, user) in
            
            /// Ensure self is not nil
            guard let self = self else {
                print("[ ERROR ] AuthService deallocated")
                return
            }
            
            print("[ DEBUG ] Auth state changed: \(user?.uid ?? "No user")")
            
            /// Update the current user
            Task { @MainActor in
                if let user = user {
                    do {
                        try await self.fetchUserData(userId: user.uid)
                        AppManager.shared.setupUser(self.user)
                    } catch {
                        AppManager.shared.resetUser()
                        print("[ ERROR ] Failed to fetch user data: \(error)")
                    }
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
        do {
            let _ = try await Auth.auth().signIn(withEmail: email, password: password).user
        } catch {
            print("[ ERROR ] Failed to sign in user: \(error)")
            throw handleFirebaseAuthError(error)
        }
    }
    
    /// Fetch user data from Firestore
    /// - Parameters: userId: The user ID
    /// - Throws: DatabaseError
    ///
    @MainActor
    private func fetchUserData(userId: String) async throws {
        do {
            let documentSnapshot = try await db.collection("users").document(userId).getDocument()
            
            guard documentSnapshot.exists else {
                print("[ ERROR ] User not found")
                throw DatabaseError.documentNotFound
            }
            
            guard let user = try? documentSnapshot.data(as: User.self) else {
                print("[ ERROR ] Failed to decode user data")
                throw DatabaseError.decodingError
            }
            
            self.user = user
            AppManager.shared.setupUser(user)
            
            // Update last login time
            Task { try? await updateLastLogin(userId: userId) }
            
        } catch {
            print("[ ERROR ] Failed to fetch user data: \(error)")
            throw self.handleFirebaseError(error)
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
    func signup(email: String, password: String, displayName: String, role: UserRole = .crew, vesselId: String? = nil) async throws {
        do {
            // Create the user in Firebase Auth
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
            let userId = authResult.user.uid
            
            // Create the user document in Firestore database
            let newUser = User( id: userId,
                                email: email,
                                displayName: displayName,
                                role: role,
                                vesselId: vesselId,
                                createdAt: Date(),
                                updatedAt: Date(),
                                lastLogin: Date())
            
            try db.collection(collectionName).document(userId).setData(from: newUser)
            
            // The auth state listener will handle loading the user data
            
        } catch {
            throw handleFirebaseAuthError(error)
        }
    }
    
    /// Sign out the current user
    /// - Throws: AuthError
    ///
    @MainActor
    func signOut() async throws {
        do {
            AppManager.shared.state = .loading
            print("[ DEBUG ] Signing out user")
            
            try Auth.auth().signOut()
            
            self.currentUser = nil
            self.error = nil
            AppManager.shared.resetUser()
        } catch {
            let authError = handleFirebaseAuthError(error)
            self.error = authError
            AppManager.shared.resetUser()
            throw authError
        }
    }
    
    /// Update last login
    /// - Parameters: userId: The user ID
    /// - Throws: DatabaseError
    /// - Note: This method will update the last login time for the user
    ///
    private func updateLastLogin(userId: String) async throws {
        do {
            try await db.collection(collectionName)
                        .document(userId)
                        .updateData(["lastLogin": Date()])
        } catch {
            print("[ ERROR ] Failed to update last login: \(error)")
            throw handleFirebaseError(error)
        }
    }
    
    /// Handle Firebase Auth Errors
    /// - Parameters: error: The error to handle
    /// - Returns: AuthError
    ///
    private func handleFirebaseAuthError(_ error: Error) -> AuthError {
        let nsError = error as NSError
        
        let errorMessage = "[ ERROR ] Firebase Auth error: \(error.localizedDescription)"
        print(errorMessage)
        
        switch nsError.code {
        case AuthErrorCode.userNotFound.rawValue:
            return .userNotFound
        case AuthErrorCode.wrongPassword.rawValue:
            return .invalidCredentials
        case AuthErrorCode.networkError.rawValue:
            return .networkError
        case AuthErrorCode.tooManyRequests.rawValue:
            return .tooManyAttempts
        default:
            return .unknown(error.localizedDescription)
        }
    }
    
    /// Handle Firebase Errors
    /// - Parameters: error: The error to handle
    /// - Returns: DatabaseError
    private func handleFirebaseError(_ error: Error) -> Error {
        let nsError = error as NSError
        print("[ DEBUG ] Handling Firebase error: \(error)")
        
        let databaseError: DatabaseError
        switch nsError.code {
        case FirestoreErrorCode.notFound.rawValue:
            databaseError = .documentNotFound
        case FirestoreErrorCode.permissionDenied.rawValue:
            databaseError = .permissionDenied
        case FirestoreErrorCode.unavailable.rawValue:
            databaseError = .networkError
        default:
            databaseError = .unknown(error.localizedDescription)
        }
        
        return AuthError.databaseError(databaseError)
    }
    
}
