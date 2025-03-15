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
    @Environment(PreferencesManager.self) private var preferences
    @Environment(UserStore.self) private var userStore
    @Environment(AuthService.self) private var authService
    
    /// Given Property
    @State private var user: User
    @State private var avatarItem: PhotosPickerItem?
    @State private var avatarImage: Image?
    
    init(user: User?) {
        if let user = user {
            self.user = user
        } else {
            self.user = User(email: "", displayName: "", role: .none)
        }
    }
    
    /// Main Body
    var body: some View {
        List {
            VStack(alignment: .center) {
                
                PhotosPicker(selection: $avatarItem, matching: .images) {
                    Avatar(user: user, size: .large)
                }
                .onChange(of: avatarItem) {
                    if let image = avatarItem {
                        print("[ DEBUG ] Image Selected")
                        userStore.uploadFromPicker(image, for: user)
                    } else {
                        print("Failed")
                    }
                }
                
                Text(user.displayName)
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
            Section() {
                
                /// Full Name
                HStack {
                    Text("Full Name").foregroundStyle(.secondary)
                    TextField("Full Name", text: $user.displayName)
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
                
                // MARK: - Vessel
                // ——————————————
                
                /// Change vessel for the user
                if userStore.currentUser.isAdmin() {
                    NavigationLink {
                        UserVesselPicker(user: $user)
                    } label: {
                        HStack {
                            Text("Yacht").foregroundStyle(.secondary)
                            Spacer()
                            Text(user.vessel ?? "Select a vessel")
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .multilineTextAlignment(.trailing)
                        }
                    }
                }
                
                /// Edit Vessel
                if let vesselId = user.vesselId {
                    if userStore.currentUser.canEditVessel(vesselId) {
                        NavigationLink {
//                            VesselEditView(vessel: preferences.vessel)
                            Text("Vessel Edit")
                        } label: {
//                            HStack {
//                                Text("Yacht").foregroundStyle(.secondary)
//                                Spacer()
//                                Text(preferences.vessel.name)
//                                    .frame(maxWidth: .infinity, alignment: .trailing)
//                                    .multilineTextAlignment(.trailing)
//                            }
                            Text("Vessel Edit")
                        }
                    }
                }
                
                /// Edit User Role
                if userStore.currentUser.canEditUser(user) {
                    HStack {
                        Text("Role").foregroundStyle(.secondary)
                        Spacer()
                        Picker("Role", selection: $user.role) {
                            ForEach(UserRole.allCases, id: \.self) {
                                Text($0.rawValue).tag($0)
                            }
                        }
                        .labelsHidden()
                    }
                }
                
                /// Cannot unactive self
                if userStore.currentUser.canEditUser(user) {
                    HStack {
                        Text("is Active").foregroundStyle(.secondary)
                        Spacer()
                        Toggle(isOn: $user.isActive) {}
                    }
                }
                
            } header: {
                Text("User Information")
            }
            
            Section(header: Text("Danger Zone")) {
                
                /// Logout
                ///
                Button {
                    Task {
                        try? await authService.signOut()
                    }
                } label: {
                    Label("Logout", systemImage: "square.and.arrow.up")
                }
                
                /// Cannot delete self
                ///
                if user.id != authService.user?.id {
                    Button {
                        print("Delete User")
                    } label: {
                        Label("Delete User", systemImage: "trash")
                    }
                }
                
                /// Change Password
                ///
                Button {
                    print("Change Password")
                } label: {
                    Label("Change Password", systemImage: "key")
                }
            }
            
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    userStore.update(user)
                    userStore.setCurrentUser(user)
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
        UserEditView(user: User.samples[0])
            .environment(UserStore())
            .environment(AuthService())
    }
}
