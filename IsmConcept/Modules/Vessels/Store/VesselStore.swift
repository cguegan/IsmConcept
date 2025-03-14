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
    
    /// Current Vessel
//    var currentVessel: Vessel {
//        guard let authUser = Auth.auth().currentUser else { return Vessel.blank }
//        if let user = users.first(where: { $0.id == authUser.uid }) {
//            if let vessel = vessels.first(where: { $0.id == user.vesselId }) {
//                return vessel
//            } else {
//                return Vessel.blank
//            }
//        } else {
//            return Vessel.blank
//        }
//    }
    
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
    func get(withID id: String) async -> Vessel? {
        do {
            let document = try await db.collection(collectionName).document(id).getDocument()
            let vessel =  try document.data(as: Vessel.self)
            print("[ DEBUG ] Got vessel with name: \(vessel.name)")
            return vessel
        } catch {
            print("[ ERROR ] Failed to get vessel with error: \(error.localizedDescription)")
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
    func getUsers(for vessel: Vessel) async -> [User]  {
        
        /// Check if vessel has an ID
        guard let id = vessel.id else { return [] }
                
        /// Set users dbRef
        let usersRef = db.collection("users")
        
        /// Get the users
        do {
            let querySnapshot = try await usersRef.whereField("vessel_id", isEqualTo: id).getDocuments()
            let users = querySnapshot.documents.compactMap { document in
                return try? document.data(as: User.self)
            }
            return users
        } catch {
            print("[ ERROR ] Failed to get users with error: \(error.localizedDescription)")
        }
        return []
    }
    
    /// addUser
    ///
    func addUser(_ user: User, to vessel: Vessel) {
        if let userId = user.id,
           let vesselId = vessel.id {
            
            /// Add the user to the new vessel
            if let index = vessels.firstIndex(where: { $0.id == vesselId }) {
                if !vessels[index].users.contains(userId) {
                    vessels[index].users.append(userId)
                }
            }
            
            /// Remove user from the old vessel
            if let index = vessels.firstIndex(where: { $0.id == user.vesselId }) {
                if let index = vessels[index].users.firstIndex(where: { $0 == userId }) {
                    vessels[index].users.remove(at: index)
                }
            }
            
        }
    }
}
