//
//  UserVesselPicker.swift
//  IsmConcept
//
//  Created by Christophe Guégan on 09/03/2025.
//

import SwiftUI
import FirebaseFirestore

struct UserVesselPicker: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var vessels: [Vessel] = []
    @Binding var user: User
    
    var body: some View {
        
        List {
            ForEach($vessels) { $vessel in
                Button {
                    print("Vessel selected: \(vessel.name)")
                    // Update the user
                    user.vesselID = vessel.id!
                    user.vessel   = vessel.name
                    print("[ DEBUG ] User updated: \(vessel.id!) - \(vessel.name)")
                    dismiss()
                } label: {
                    HStack {
                        Label("\(vessel.name)", systemImage: "\(vessel.type.icon)")
                            .foregroundColor(.primary)
                        
                        Spacer()
                        if vessel.id == user.vesselID {
                            Image(systemName: "checkmark")
                                .foregroundColor(.accentColor)
                        }
                    }
                }
            }
        }
        .navigationTitle("Select the vessel")
        .navigationBarTitleDisplayMode(.inline)
        .task{
            let db = Firestore.firestore().collection("vessels")
            do {
                let querySnapshot = try await db.getDocuments()
                self.vessels = querySnapshot.documents.compactMap { document in
                    return try? document.data(as: Vessel.self)
                }
            } catch {
                print("Error getting vessels: \(error)")
            }
        }
    }
}


// MARK: - Preview
// ———————————————

#Preview {
    NavigationStack {
        UserVesselPicker(user: .constant(User.samples.first!))
    }
}
