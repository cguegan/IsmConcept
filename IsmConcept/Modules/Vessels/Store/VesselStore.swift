//
//  VesselStore.swift
//  IsmConcept
//
//  Created by Christophe Guégan on 09/03/2025.
//

import Foundation
import Observation
import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import PhotosUI

@Observable
final class VesselStore {
    
    var vessels: [Vessel] = []
    var error: Error?
    var errorMessage: String?
    var showErrorAlert: Bool = false
    
    /// Firestore database reference
    ///
    let db = Firestore.firestore()
    let collectionName = "vessels"
    let logoCollectionName = "logos"
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
        
        print("[ DEBUG ] Enabling vessel live sync ...")
        
        listener = db.collection(collectionName)
            .order(by: "name", descending: false)
            .addSnapshotListener { querySnapshot, error in
                if let querySnapshot = querySnapshot {
                    print("[ DEBUG ] Got \(querySnapshot.documents.count) vessels")
                    self.vessels = querySnapshot.documents.compactMap { document in
                        return try? document.data(as: Vessel.self)
                    }
                }
            }
    }
    
    
    // MARK: - CRUD Operations
    
    /// Add a new vessel to Firestore database
    /// - Parameter vessel: The vessel to add
    /// - Returns: Void
    ///
    func add(_ vessel: Vessel) {
        do {
            try db.collection(collectionName).addDocument(from: vessel)
        } catch {
            print("[ ERROR ] Failed to add vessel with error: \(error.localizedDescription)")
            self.error = error
            self.errorMessage = error.localizedDescription
        }
    }
    
    /// Get a vessel from Firestore
    /// - Parameter id: The vessel ID
    /// - Returns: The vessel
    /// - Note: This method is async and will return the vessel if found
    ///
    func fetch(withID id: String) async -> Vessel? {
        do {
            let document = try await db.collection(collectionName).document(id).getDocument()
            let vessel =  try document.data(as: Vessel.self)
            print("[ DEBUG ] Got vessel with name: \(vessel.name)")
            return vessel
        } catch {
            print("[ ERROR ] Failed to fetch vessel with error: \(error.localizedDescription)")
            self.error = error
            self.errorMessage = error.localizedDescription
        }
        return nil
    }
    
    /// Fetch all vessels from Firestore
    /// - Returns: An array of vessels
    ///
    func fetchVessels() async -> [Vessel] {
        do {
            let querySnapshot = try await db.collection(collectionName).getDocuments()
            vessels = querySnapshot.documents.compactMap { document in
                return try? document.data(as: Vessel.self)
            }
            return vessels
        } catch {
            print("[ ERROR ] Failed to fetch vessels with error: \(error.localizedDescription)")
            self.error = error
            self.errorMessage = error.localizedDescription
        }
        return []
    }
    
    /// Delete a vessel from Firestore
    /// - Parameter vessel: The vessel to delete
    /// - Returns: Void
    ///
    func remove(_ vessel: Vessel) {
        
        /// Check if vessel has an ID
        guard let id = vessel.id else { return }
        
        /// Delete vessel picture  from firebase storage
        //        deleteImage(for: vessel)
        
        /// Delete the user
        db.collection(collectionName).document(id).delete()
        
    }
    
    /// Update a vessel in Firestore
    /// - Parameter vessel: The vessel to update
    /// - Returns: Void
    ///
    func update(_ vessel: Vessel) {
        
        print("[ DEBUG ] Updating vessel \(vessel.name)")
        
        /// Check if document has an ID
        guard let id = vessel.id else { return }
        
        /// Set updated date
        /// - Note: This is important to keep track of the last update date
        var vessel = vessel
        vessel.updatedAt = Date()
        
        /// Update the document
        do {
            try db.collection(collectionName).document(id).setData(from: vessel)
        } catch {
            print("[ ERROR ] Failed to update vessel with error: \(error.localizedDescription)")
            self.error = error
            self.errorMessage = error.localizedDescription
        }
        
    }
    
    /// Get users for a specific vessel
    ///
    func fetchUsers(for vessel: Vessel) async -> [User]  {
        
        /// Check if vessel has an ID
        guard let id = vessel.id else { return [] }
                
        /// Set users dbRef
        let usersRef = db.collection("users")
        
        /// Get the users
        do {
            let querySnapshot = try await usersRef.whereField("vessel_id", isEqualTo: id).getDocuments()
            var users = querySnapshot.documents.compactMap { document in
                return try? document.data(as: User.self)
            }
            users.sort { $0.role.level < $1.role.level }
            
            return users
        } catch {
            print("[ ERROR ] Failed to fetch users with error: \(error.localizedDescription)")
        }
        return []
    }
    
    /// Assign a user to the vessel
    ///
    func assignUser(_ user: User, to vessel: Vessel) {
        
        /// Check if user has an ID
        guard let userId = user.id else { return }
        
        /// Check if user has a vessel ID
        guard let oldVesselId = user.vesselId else { return }
        
        /// Start the process
        print("[ DEBUG ] Assigning user \(user.displayName) to vessel \(vessel.name)")
        Task {
            
            /// Remove user from his old vessel
            /// 1. Search for the old vessel
            if let oldVesselIndex = vessels.firstIndex(where: { $0.id == oldVesselId }) {
                /// 2. Search for the user in the old vessel
                if let UserIndex = vessels[oldVesselIndex].users.firstIndex(where: { $0 == userId }) {
                    print("[ DEBUG ] Old vessel found \(vessels[oldVesselIndex].name)")
                    print("[ DEBUG ] Removing user \(user.displayName) from vessel \(vessels[oldVesselIndex].name)")
                    vessels[oldVesselIndex].users.remove(at: UserIndex)
                    update(vessels[oldVesselIndex])
                } else {
                    print("[ DEBUG ] User \(user.displayName) not found in old vessel")
                }
            }
            
            /// Add the user to the new vessel
            if !vessel.users.contains(userId) {
                var vesselToUpdate = vessel
                print("[ DEBUG ] Append user \(user.displayName) to vessel \(vesselToUpdate.name)")
                vesselToUpdate.users.append(userId)
                update(vesselToUpdate)
            }
        }
            
    }
    
    
    // MARK: - Upload Image to Firebase Storage
    
    /// Upload a photos picker user to Firebase Storage
    /// - Parameters:
    ///     - image:     The image to upload as PhotosPickerItem
    ///     - vessel:     The vessel to associate the image with
    ///
    func uploadFromPicker(_ image: PhotosPickerItem, for vessel: Vessel) {
        
        /// Check if the image is valid
        print("[ DEBUG ] Uploading image ...")
        
        /// Load the image data
        image.loadTransferable(type: Data.self) { result in
            switch result {
            case .success(let imageData):
                if let imageData = imageData,
                   let uiImage = UIImage(data: imageData) {
                    self.uploadImage(uiImage, for: vessel)
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
    ///     - vessel:       The vessel to associate the image with
    ///
    func uploadImage(_ image: UIImage, for vessel: Vessel) {
        
        /// Create a reference to the image in Firebase Storage
        let storagePath = storageRef.child("\(collectionName)/\(vessel.id ?? UUID().uuidString).jpg")
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
                            var vessel = vessel
                            vessel.imageUrl = url.absoluteString
                            self.update(vessel)
                        }
                    }
                }
            }
        }
    }
    
    /// Delete an image from Firebase Storage
    /// - Parameters:
    ///    - imageUrl: The URL of the image to delete
    ///    - vessel: The vessel to associate the image with
    ///
    func deleteImage(for vessel: Vessel) async throws {
        
        /// Check if the user has an image URL
        guard let url = vessel.imageUrl else { return }
        
        /// Create a reference to the image in Firebase Storage
        let storagePath = storage.reference(forURL: url)
        
        /// Delete the image
        do {
            try await storagePath.delete()
        } catch {
            throw error
        }
    }
    
    
    // MARK: - Upload Logo to Firebase Storage
    
    /// Upload a photos picker user to Firebase Storage
    /// - Parameters:
    ///     - image:     The logo to upload as PhotosPickerItem
    ///     - vessel:     The vessel to associate the logo with
    ///
    func uploadLogoFromPicker(_ image: PhotosPickerItem, for vessel: Vessel) {
        
        /// Check if the image is valid
        print("[ DEBUG ] Uploading logo ...")
        
        /// Load the image data
        image.loadTransferable(type: Data.self) { result in
            switch result {
            case .success(let imageData):
                if let imageData = imageData,
                   let uiImage = UIImage(data: imageData) {
                    self.uploadLogo(uiImage, for: vessel)
                    print("[ DEBUG ] logo uploaded successfully.")
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
    
    /// Upload a logo to Firebase Storage
    /// - Parameters:
    ///     - image:    The image to upload in UIImage format
    ///     - vessel:       The vessel to associate the image with
    ///
    func uploadLogo(_ image: UIImage, for vessel: Vessel) {
        
        /// Create a reference to the image in Firebase Storage
        let storagePath = storageRef.child("\(logoCollectionName)/\(vessel.id ?? UUID().uuidString).png")
        let resizedImage = image.aspectFittedToHeight(512)
        let data = resizedImage.pngData()
        
        /// Set the metadata
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        
        /// Upload the image
        if let data = data {
            storagePath.putData(data, metadata: metadata) { (metadata, error) in
                if let error = error {
                    print("[ ERROR ] Failed to upload logo: \(error)")
                    self.errorMessage = error.localizedDescription
                    self.showErrorAlert = true
                } else {
                    storagePath.downloadURL { (url, error) in
                        if let url = url {
                            var vessel = vessel
                            vessel.logoUrl = url.absoluteString
                            self.update(vessel)
                        }
                    }
                }
            }
        }
    }
    
}
