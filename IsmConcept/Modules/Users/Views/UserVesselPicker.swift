//
//  UserVesselPicker.swift
//  IsmConcept
//
//  Created by Christophe Guégan on 09/03/2025.
//

import SwiftUI
import FirebaseFirestore

struct UserVesselPicker: View {
    
    /// Environment properties
    @Environment(\.dismiss) var dismiss
    @Environment(VesselStore.self) var vesselStore
    
    /// State properties
    @Binding var user: User
    
    /// Main body
    var body: some View {
        @Bindable var vesselStore = vesselStore
        List {
            ForEach($vesselStore.vessels) { $vessel in
                Button {
                    print("Vessel selected: \(vessel.name)")
                    
                    // Update the user
                    user.vesselId = vessel.id!
                    print("[ DEBUG ] User updated: \(vessel.id!) - \(vessel.name)")
                    
                    // Update the vessel
                    vesselStore.addUser(user, to: vessel)
                    
                    // Dismiss the view
                    dismiss()
                } label: {
                    HStack {
                        Label("\(vessel.name)", systemImage: "\(vessel.type.icon)")
                            .foregroundColor(.primary)
                        
                        Spacer()
                        if vessel.id == user.vesselId {
                            Image(systemName: "checkmark")
                                .foregroundColor(.accentColor)
                        }
                    }
                }
            }
        }
        .navigationTitle("Select the vessel")
        .navigationBarTitleDisplayMode(.inline)
    }
}


// MARK: - Preview
// ———————————————

#Preview {
    NavigationStack {
        UserVesselPicker(user: .constant(User.samples.first!))
    }
}
