//
//  UserDetailView.swift
//  IsmConcept
//
//  Created by Christophe Guégan on 08/03/2025.
//

import SwiftUI

struct UserDetailView: View {
    
    /// Environment Properties
    @Environment(\.dismiss) private var dismiss
    @Environment(UserStore.self) private var store

    init(user: User) {
        self.user = user
        self.user.phoneNbr = ""
    }
    
    /// Binden Property
    @State var user: User

    /// Computed Properties
    var imageUrl: URL? {
        guard let url = user.imageUrl else { return nil }
        guard let imageUrl = URL(string: url) else { return nil }
        return imageUrl
    }
    
    /// Main Body
    var body: some View {
        List {
            
            /// Email
            Section() {
                HStack {
                    Text("Email").foregroundStyle(.secondary)
                    Spacer()
                    Text(user.email)
                }
            } header: {
                Text("Email")
            } footer: {
                Text("Email cannot be changed")
            }
            
            // Editable User Information
            Section(header: Text("User Information")) {
                if let imageUrl = imageUrl {
                    AsyncImage(url: imageUrl) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                            .frame(width: 100, height: 100)
                    } placeholder: {
                        ProgressView()
                    }
                }
                /// Full Name
                HStack {
                    Text("Full Name").foregroundStyle(.secondary)
                    TextField("Full Name", text: $user.name)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.trailing)
                }
                /// Phone
                HStack {
                    Text("Phone").foregroundStyle(.secondary)
                    TextField("Phone", text: $user.phoneNbr.toUnwrapped(defaultValue: ""))
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.trailing)
                }
                
                /// Vessel
                HStack {
                    NavigationLink {
                        Text("Vessel").foregroundStyle(.secondary)
                        //VesselListView(selectedVessel: $user.vesselID)
                    } label: {
                        Text("Vessel").foregroundStyle(.secondary)
                        Spacer()
                        Text(user.vesselID ?? "Select a vessel")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                /// Role
                HStack {
                    Text("Role").foregroundStyle(.secondary)
                    Spacer()
                    Picker("Role", selection: $user.role) {
                        ForEach(UserRole.allCases, id: \.self) {
                            Text($0.description).tag($0)
                        }
                    }
                    .labelsHidden()
                }
                
                /// Cannot unactive self  if user is admin
                if let userID = AuthManager.shared.user?.id,
                    user.role == .admin,
                    user.id != userID {
                    HStack {
                        Text("is Active").foregroundStyle(.secondary)
                        Spacer()
                        Toggle(isOn: $user.isActive) {}
                    }
                }
            }
            
            Section(header: Text("Danger Zone")) {
                /// Cannot delete self
                if let userID = AuthManager.shared.user?.id,
                   user.id != userID {
                    Button {
                        print("Delete User")
                    } label: {
                        Label("Delete User", systemImage: "trash")
                    }
                }

                Button {
                    print("Change Password")
                } label: {
                    Label("Change Password", systemImage: "lock")
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    store.update(user)
                    dismiss()
                }
            }
        }
    }
}


// MARK: - Preview
// ———————————————

#Preview {
    NavigationStack {
        UserDetailView(user: User.samples[0])
            .environment(UserStore())
    }
}
