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
import SwiftData

@Observable
class AuthManager {

    /// Published properties
    var userSession: FirebaseAuth.User?
    var user: User?
    var vessel: Vessel?
    
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
//    var listener: ListenerRegistration?
    
    /// Private initializer
    ///
    private init() {
        self.userSession = Auth.auth().currentUser
    }
    
    /// Get the Firestore Collection Reference
    ///
    private func dbRef() -> CollectionReference {
        return db.collection(collectionName)
    }
    
    /// Get the storage reference  for the current user image
    /// - Throws: Error if user is not authenticated
    ///
    private func storageRef() throws -> StorageReference {
        
        /// Check if user is autenticated
        guard let user = Auth.auth().currentUser else {
            throw NSError(domain: "User is not authenticated.", code: 0)
        }
        
        return Storage.storage()
                      .reference(withPath: "/\(collectionName)/\(user.uid)/")
        
    }
    
    /// Login user with email and password
    /// - Parameters:   - email: email address
    ///                - password: password
    ///
    @MainActor
    func login(withEmail email: String, password: String) async throws {
        print("[ DEBUG ] Logging in with email: \(email)...")
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            print("[ DEBUG ] User logged in successfully with ID: \(result.user.uid)")
            await self.fetchUser()
            await self.fetchVessel()
        } catch {
            throw NSError(domain: "Failed to sign in with error \(error.localizedDescription)", code: 0)
        }
    }
    
    /// Sign out user
    /// - Returns: Void
    ///
    func signOut() {
        try? Auth.auth().signOut()  // sign out user from Firebase
        self.userSession = nil      // set user session to nil
        self.user = nil             // set user to nil
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
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            
            print("[ DEBUG ] Auth User created successfully with ID: \(result.user.uid)")
            
            // Create the vessel in the model context
            let user = User( id:       result.user.uid,
                             name:     name,
                             email:    email,
                             role:     .crew,
                             isActive: true,
                             vesselID: vessel.id,
                             vessel:   vessel.name )
            
            // Backup the user to firebase
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
    
    /// Get the user from Firestore
    ///
    func fetchUser() async {
        
        /// Check if user is authenticated
        guard let id = self.userSession?.uid else { return }
        
        /// Get the user from Firestore
        print("[ DEBUG ] Fetching user with ID: \(id)...")
        do {
            let user = try await dbRef().document(id).getDocument(as: User.self)
            self.user = user
        } catch {
            self.errorMessage = "Failed to get user with error \(error.localizedDescription)"
            self.showErrorAlert = true
            print("[ ERROR ] Failed to get user with error \(error.localizedDescription)")
        }
        
    }
    
    /// Get the vessel of the current user
    ///
    func fetchVessel() async {
        if let vesselID = self.user?.vesselID {
            print("[ DEBUG ] Fetched vessel with id: \(vesselID)")
            self.vessel = await VesselStore.shared.get(withID: vesselID)
        }
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
    
    /// Delete a user from Firestore
    /// - Parameter document: The user to delete
    /// - Returns: Void
    ///
    func remove(_ user: User) {
        
        /// Check if document has an ID
        guard let id = user.id else { return }
        
        /// Delete all images from firebase storage
        // TODO: - code to delete user picture from firebase storage
        
        /// Delete the document from Firestore
        dbRef().document(id).delete()
        
    }
    
    /// Update a user in Firestore
    /// - Parameter user: The user to update
    /// - Returns: Void
    ///
    func update(_ user: User) {

        /// Check if user has an ID
        guard let id = user.id else { return }
        
        /// Update the user in Firestore
        do {
            try dbRef().document(id).setData(from: user)
        } catch {
            self.errorMessage = "Failed to update user with error \(error.localizedDescription)"
            self.showErrorAlert = true
        }
    }
    
    /// Upload a file to Firebase Storage
    /// - Parameters:
    ///   - user:   The user to upload the image
    ///   - image:  The image to upload
    ///
    func uploadImage(forUser user: User, image: UIImage) async {
        
        /// Check if user has an ID
        guard let id = user.id else { return }
        
        /// Convert image to data
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {return}
        
        /// Create a reference to the image in Firebase Storage
        guard let ref = try? storageRef().child(id) else { return }
        
        /// Upload the image to Firebase Storage
        ref.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                self.errorMessage = "Failed to upload image with error: \(error.localizedDescription)"
                self.showErrorAlert = true
                return
            }
            
            ref.downloadURL { url, error in
                guard let imageURL = url?.absoluteString else {return}
                var user = user
                user.imageUrl = imageURL
                self.update(user)
            }
        }
    }
    
    /// Delete a file from Firebase Storage
    ///
    func deleteImage(forUser user: User) {
        
        /// Check if the URL is a valid storage URL
        guard let url = user.imageUrl, url.hasPrefix("gs://") else { return }
        
        /// Create a reference to the image in Firebase Storage
        guard let ref = try? storageRef().child(url) else { return }
        
        /// Delete the image from Firebase Storage
        ref.delete { error in
            if let error = error {
                self.errorMessage = "Failed to upload image with error: \(error.localizedDescription)"
                self.showErrorAlert = true
                return
            }
        }
    }
    
}
