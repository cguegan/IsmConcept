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
    @Environment(\.dismiss)        var dismiss
    @Environment(UserStore.self)   var userStore
    @Environment(VesselStore.self) var vesselStore

    /// State properties
    @Binding var user: User
    
    /// Main body
    var body: some View {
        @Bindable var vesselStore = vesselStore
        List {
            ForEach($vesselStore.vessels) { $vessel in
                Button {
                    print("[ DEBUG ] \(vessel.name) selected")
                    
                    // Update the user
                    user.vesselId = vessel.id!
                    user.vesselName = vessel.name
                    userStore.update(user)
                    
                    // Update the vessel
                    vesselStore.assignUser(user, to: vessel)
                    
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
