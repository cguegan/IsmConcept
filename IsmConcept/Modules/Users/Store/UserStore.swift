//
//  UserStore.swift
//  IsmConcept
//
//  Created by Christophe Guégan on 08/03/2025.
//

import Foundation
import Observation
import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import PhotosUI

@Observable
final class UserStore {

    var users: [User] = []
    var errorMessage: String?
    var showErrorAlert: Bool = false

    /// Firestore database reference
    ///
    let db = Firestore.firestore()
    let collectionName = "users"
    var listener: ListenerRegistration?
    
    /// Storage of images
    ///
    let storage = Storage.storage()
    let storageRef = Storage.storage().reference()
    
    /// Initialize the store and enable live sync
    ///
    init() {
        enableLiveSync()
    }
    
    /// Deinitialize the store and remove the listener
    ///
    deinit {
        listener?.remove()
    }
    
    /// Enable live sync with Firestore
    /// - Note: This method will listen to Firestore changes and update of the users
    ///         array for the current user only.
    ///
    func enableLiveSync() {
        
        print("[ DEBUG ] Enabling user live sync ...")
        
        //let role = AuthManager.shared.user.role.rawValue
        
        listener = Firebase.userCollection //.whereField("role", isGreaterThan: role)
            .addSnapshotListener { querySnapshot, error in
                if let querySnapshot = querySnapshot {
                    self.users = querySnapshot.documents.compactMap { document in
                        return try? document.data(as: User.self)
                    }
                }
            }
    }
    
    
    // MARK: - CRUD Operations
    
    /// Add a new user to Firestore database
    /// - Parameter user: The user to add
    /// - Returns: Void
    ///
    func add(_ user: User) {
        do {
            try Firebase.userCollection.addDocument(from: user)
        } catch {
            print("[ ERROR ] Failed to add user with error: \(error.localizedDescription)")
            self.errorMessage = error.localizedDescription
            self.showErrorAlert = true
        }
    }
    
    /// Delete a user from Firestore
    /// - Parameter user: The user to delete
    /// - Returns: Void
    ///
    func remove(_ user: User) {
        Task {
            do {
                /// Check if user has an ID
                guard let id = user.id else { return }
                
                /// Delete user picture  from firebase storage
                try await self.deleteImage(for: user)
                
                /// Delete the user
                try await Firebase.userCollection.document(id).delete()
            } catch {
                print("[ ERROR ] Failed to remove user with error: \(error.localizedDescription)")
                self.errorMessage = error.localizedDescription
                self.showErrorAlert = true
            }
        }
    }
    
    /// Update a user in Firestore
    /// - Parameter user: The user to update
    /// - Returns: Void
    ///
    func update(_ user: User) {
        
        /// Check if user has an ID
        guard let id = user.id else { return }
        
        /// Set updated date
        /// - Note: This is important to keep track of the last update date
        var user = user
        user.updatedAt = Date()
        
        /// Update the user
        do {
            try Firebase.userCollection.document(id).setData(from: user)
        } catch {
            print("[ ERROR ] Failed to update user with error: \(error.localizedDescription)")
            self.errorMessage = error.localizedDescription
            self.showErrorAlert = true
        }
        
    }
    
    // MARK: - Upload Image to Firebase Storage
    
    /// Upload a photos picker user to Firebase Storage
    /// - Parameters:
    ///     - image:     The image to upload as PhotosPickerItem
    ///     - user:        The user to associate the image with
    ///
    func uploadFromPicker(_ image: PhotosPickerItem, for user: User) {
        
        /// Check if the image is valid
        print("[ DEBUG ] Uploading image ...")
        
        /// Load the image data
        image.loadTransferable(type: Data.self) { result in
            switch result {
            case .success(let imageData):
                if let imageData = imageData,
                   let uiImage = UIImage(data: imageData) {
                    self.uploadImage(uiImage, for: user)
                    print("[ DEBUG ] Image uploaded successfully.")
                } else {
                    print("[ ERROR ] No supported content type found.")
                }
            case .failure(let error):
                print("[ ERROR ] While loading transferable: \(error.localizedDescription)")
                self.errorMessage = error.localizedDescription
                self.showErrorAlert = true
            }
        }
    }
    
    /// Upload an image to Firebase Storage
    /// - Parameters:
    ///     - image:    The image to upload in UIImage format
    ///     - user:       The user to associate the image with
    ///
    func uploadImage(_ image: UIImage, for user: User) {
        
        /// Create a reference to the image in Firebase Storage
        let storagePath = storageRef.child("\(collectionName)/\(user.id ?? UUID().uuidString).jpg")
        let resizedImage = image.aspectFittedToHeight(512)
        let data = resizedImage.jpegData(compressionQuality: 0.5)
        
        /// Set the metadata
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        /// Upload the image
        if let data = data {
            storagePath.putData(data, metadata: metadata) { (metadata, error) in
                if let error = error {
                    print("[ ERROR ] Failed to upload image: \(error)")
                    self.errorMessage = error.localizedDescription
                    self.showErrorAlert = true
                } else {
                    storagePath.downloadURL { (url, error) in
                        if let url = url {
                            var user = user
                            user.imageUrl = url.absoluteString
                            self.update(user)
                        }
                    }
                }
            }
        }
    }
    
    /// Delete an image from Firebase Storage
    /// - Parameters:
    ///    - imageUrl: The URL of the image to delete
    ///    - user: The user to associate the image with
    ///
    func deleteImage(for user: User) async throws {
        
        /// Check if the user has an image URL
        guard let url = user.imageUrl else { return }
        
        /// Create a reference to the image in Firebase Storage
        let storagePath = storage.reference(forURL: url)
        
        /// Delete the image
        do {
            try await storagePath.delete()
        } catch {
            throw error
        }
    }
    
}
