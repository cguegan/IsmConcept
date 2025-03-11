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
    
    /// Given Property
    @State var user: User
    @State private var avatarItem: PhotosPickerItem?
    @State private var avatarImage: Image?

    /// Main Body
    var body: some View {
            List {
                VStack(alignment: .center) {
                    
                    PhotosPicker(selection: $avatarItem, matching: .images) {
                        LargeUserAvatar(user: user)
                    }
                    .onChange(of: avatarItem) {
                        if let image = avatarItem {
                            print("[ DEBUG ] Image Selected")
                            store.uploadFromPicker(image, for: user)
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
                    if AuthManager.shared.user.role.rawValue < 10 {
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
                    
                    NavigationLink {
                        VesselEditView(vessel: AuthManager.shared.vessel)
                    } label: {
                        HStack {
                            Text("Yacht").foregroundStyle(.secondary)
                            Spacer()
                            Text(AuthManager.shared.vessel.name)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .multilineTextAlignment(.trailing)
                        }
                    }
                    
                    /// Role
                    if AuthManager.shared.user.role.rawValue < 10 {
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
                    if user.role == .admin,
                       user.id != AuthManager.shared.user.id {
                        HStack {
                            Text("is Active").foregroundStyle(.secondary)
                            Spacer()
                            Toggle(isOn: $user.isActive) {}
                        }
                    }
                }
                
                Section(header: Text("Danger Zone")) {
                    /// Cannot delete self
                    if user.id != AuthManager.shared.user.id {
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
