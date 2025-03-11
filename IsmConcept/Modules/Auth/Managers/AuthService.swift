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
class AuthService {
    private(set) var currentUser: User?
    private(set) var isAuthenticated = false
    private(set) var isLoading = true
    
    private let db = Firestore.firestore()
    private var authStateHandler: AuthStateDidChangeListenerHandle?
    private var collectionName = "users"
    
    static let shared = AuthService()

    /// Initialization
    ///
    init() {
        setupAuthStateListener()
    }
    
    /// De-Init
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
            guard let self = self else { return }
            
            Task { @MainActor in
                if let user = user {
                    do {
                        try await self.fetchUserData(userId: user.uid)
                    } catch {
                        self.isAuthenticated = false
                        self.currentUser = nil
                        print("Failed to fetch user data: \(error)")
                    }
                } else {
                    self.isAuthenticated = false
                    self.currentUser = nil
                }
                self.isLoading = false
            }
        }
    }
    
    /// Fetch user data from Firestore
    /// - Parameters: userId: The user ID
    /// - Throws: DatabaseError
    ///
    @MainActor
    private func fetchUserData(userId: String) async throws {
        do {
            let documentSnapshot = try await db.collection(collectionName).document(userId).getDocument()
            
            guard documentSnapshot.exists else {
                throw DatabaseError.documentNotFound
            }
            
            guard let userData = try? documentSnapshot.data(as: User.self) else {
                throw DatabaseError.decodingError
            }
            
            self.currentUser = userData
            self.isAuthenticated = true
            
            // Update last login time
            try? await db.collection(collectionName).document(userId).updateData([
                "lastLogin": Timestamp(date: Date())
            ])
        } catch {
            throw self.handleFirebaseError(error)
        }
    }
    
    /// Login a user
    /// - Parameters: email: The user email
    ///               password: The user password
    /// - Throws: AuthError
    ///
    func login(email: String, password: String) async throws {
        do {
            let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
            
            // Wait for the auth state listener to update currentUser
            let deadline = Date().addingTimeInterval(2)
            while currentUser == nil && Date() < deadline {
                try await Task.sleep(nanoseconds: 100_000_000) // 0.1 second
            }
            
            guard currentUser != nil else {
                throw AuthError.userNotFound
            }
        } catch {
            throw handleFirebaseAuthError(error)
        }
    }
    
    /// Signup a new user
    /// - Parameters: email: The user email
    ///               password: The user password
    ///               displayName: The user display name
    ///               role: The user role: default is .crew
    ///               vesselId: The user vessel ID
    ///    Throws: AuthError
    ///
    func signup(email: String, password: String, displayName: String, role: UserRole = .crew, vesselId: String? = nil) async throws {
        do {
            // Create the user in Firebase Auth
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
            let userId = authResult.user.uid
            
            // Create the user document in Firestore
            let newUser = User( id: userId,
                                email: email,
                                displayName: displayName,
                                role: role,
                                vesselId: vesselId,
                                createdAt: Date() )
            
            try db.collection(collectionName).document(userId).setData(from: newUser)
            
            // The auth state listener will handle loading the user data
        } catch {
            throw handleFirebaseAuthError(error)
        }
    }
    
    /// Sign out the current user
    /// - Throws: AuthError
    ///
    func signOut() async throws {
        do {
            try Auth.auth().signOut()
        } catch {
            throw handleFirebaseAuthError(error)
        }
    }
    
    /// Handle Firebase Auth Errors
    /// - Parameters: error: The error to handle
    /// - Returns: AuthError
    ///
    private func handleFirebaseAuthError(_ error: Error) -> AuthError {
        let nsError = error as NSError
        
        switch nsError.code {
        case AuthErrorCode.userNotFound.rawValue:
            return .userNotFound
        case AuthErrorCode.wrongPassword.rawValue:
            return .invalidCredentials
        case AuthErrorCode.networkError.rawValue:
            return .networkError
        default:
            return .unknown(error.localizedDescription)
        }
    }
    
    /// Handle Firebase Errors
    /// - Parameters: error: The error to handle
    /// - Returns: DatabaseError
    private func handleFirebaseError(_ error: Error) -> Error {
        let nsError = error as NSError
        
        switch nsError.code {
        case FirestoreErrorCode.notFound.rawValue:
            return DatabaseError.documentNotFound
        case FirestoreErrorCode.permissionDenied.rawValue:
            return DatabaseError.permissionDenied
        case FirestoreErrorCode.unavailable.rawValue:
            return DatabaseError.networkError
        default:
            return DatabaseError.unknown(error.localizedDescription)
        }
    }
    
}
