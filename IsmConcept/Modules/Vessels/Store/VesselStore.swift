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
import FirebaseStorage
import PhotosUI

@Observable
final class VesselStore {
    
    var vessels: [Vessel] = []
    var error: Error?
    var errorMessage: String?
    
    /// Firestore database reference
    ///
    let db = Firestore.firestore()
    let collectionName = "vessels"
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
            .addSnapshotListener { querySnapshot, error in
                if let querySnapshot = querySnapshot {
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
    
    
}
