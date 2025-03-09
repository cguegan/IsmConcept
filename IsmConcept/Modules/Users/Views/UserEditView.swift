//
//  UserEditView.swift
//  IsmConcept
//
//  Created by Christophe Guégan on 08/03/2025.
//

import SwiftUI
import PhotosUI

struct UserEditView: View {
    
    /// Environment Properties
    @Environment(\.dismiss) private var dismiss
    @Environment(UserStore.self) private var store

    /// Initializer
    init(user: User) {
        self.user = user
        self.user.phoneNbr = ""
    }
    
    /// Given Property
    @State var user: User
    @State private var avatarItem: PhotosPickerItem?
    @State private var avatarImage: Image?

    /// Main Body
    var body: some View {
        List {
            
            /// User Avatar
            VStack(alignment: .center) {
                                
                PhotosPicker(selection: $avatarItem, matching: .images) {
                    LargeUserAvatar(user: user)
                }
                .onChange(of: avatarItem) {
                    if let image = avatarItem {
                        print("[ DEBUG ] Image Selected")
                        store.uploadImage(image, for: user)
                    } else {
                        print("Failed")
                    }
                }
                .padding(.bottom, 20)
                
                Text(user.name)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(user.role.description)
                    
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .listRowBackground(Color.clear)
            .scrollContentBackground(.hidden)
            
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
                ///
                if let user = AuthManager.shared.user,
                   user.role.rawValue < 10 {
                    HStack {
                        NavigationLink {
                            UserVesselPicker(user: $user)
                        } label: {
                            Text("Vessel").foregroundStyle(.secondary)
                            Spacer()
                            Text(user.vessel ?? "Select a vessel")
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .multilineTextAlignment(.trailing)
                        }
                    }
                }
                
                if let vessel = AuthManager.shared.vessel {
                        NavigationLink {
                            VesselEditView(vessel: vessel)
                                .environment(VesselStore())
                        } label: {
                            HStack {
                                Text("Yacht").foregroundStyle(.secondary)
                                Spacer()
                                Text(vessel.name)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .multilineTextAlignment(.trailing)
                            }
                        }
                }
                
                /// Role
                if let user = AuthManager.shared.user,
                   user.role.rawValue < 10 {
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
                
                Button {
                    AuthManager.shared.signOut()
                } label: {
                    Label("Logout", systemImage: "arrowshape.turn.up.backward")
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
        .task {
            
        }
    }
}


// MARK: - Preview
// ———————————————

#Preview {
    NavigationStack {
        UserEditView(user: User.samples[0])
            .environment(UserStore())
    }
}
