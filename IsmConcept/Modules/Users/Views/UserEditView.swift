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
    @Environment(\.dismiss)               private var dismiss
    @Environment(PreferencesManager.self) private var preferences
    @Environment(UserStore.self)          private var userStore
    @Environment(AuthService.self)        private var authService
    
    /// Given Property
    @State private var user: User
    @State private var avatarItem: PhotosPickerItem?
    @State private var avatarImage: Image?
    @State private var showEditVesselSheet: Bool = false
    @State private var editableVesselId: String?
    
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
            /// Avatar and User Information
            VStack(alignment: .center) {
                
                PhotosPicker(selection: $avatarItem, matching: .images) {
                    Avatar(user: user, size: .large, withShadow: true)
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
            
            /// Editable User Information
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
                if AppManager.shared.user.isManager() {
                    /// Only crew members can be added to a vessel
                    if user.isCrewMember() {
                        NavigationLink {
                            UserVesselPicker(user: $user)
                        } label: {
                            HStack {
                                Text("Select a Yacht").foregroundStyle(.secondary)
                                Spacer()
                                Text(user.vesselName ?? "Select a vessel")
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .multilineTextAlignment(.trailing)
                            }
                        }
                    }
                }
                
                /// Change user role
                if AppManager.shared.user.canEditUser(user) {
                    HStack {
                        Text("Role").foregroundStyle(.secondary)
                        Spacer()
                        Picker("Role", selection: $user.role) {
                            ForEach(UserRole.allCases, id: \.self) { role in
                                if role.level > AppManager.shared.user.role.level {
                                    Text(role.rawValue).tag(role)
                                }
                            }
                        }
                        .labelsHidden()
                    }
                }
                
                /// Cannot unactive self
                if AppManager.shared.user.canEditUser(user) {
                    HStack {
                        Text("is Active").foregroundStyle(.secondary)
                        Spacer()
                        Toggle(isOn: $user.isActive) {}
                    }
                }
                
            } header: {
                Text("User Information")
            }
            
            /// Edit Yacht Information
            if user.isCrewMember() {
                Section("Yacht Information") {
                    
                    HStack {
                        Text("Yacht Name:").foregroundStyle(.secondary)
                        Spacer()
                        Text("\(user.vesselName ?? "nil")")
                    }
                    
                    if  let vessel = user.vesselName,
                        let vesselId = user.vesselId,
                        user.canEditVessel(vesselId) {
                        
                        Section() {
                            Button {
                                editableVesselId = vesselId
                                showEditVesselSheet.toggle()
                            } label: {
                                Label("Edit \(vessel)", systemImage: "shippingbox")
                            }
                        }
                    }
                }
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
                if user.id != AppManager.shared.user.id {
                    Button {
                        print("Deleting User ...")
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
            
            /// Debug Information
            if Constants.debugMode {
                Section() {
                    HStack {
                        Text("Yacht Name:").foregroundStyle(.secondary)
                        Spacer()
                        Text("\(user.vesselName ?? "nil")")
                    }
                    
                    HStack {
                        Text("Yacht ID:").foregroundStyle(.secondary)
                        Spacer()
                        Text("\(user.vesselId ?? "nil")")
                    }
                    
                    HStack {
                        Text("Created At").foregroundStyle(.secondary)
                        Spacer()
                        Text(user.createdAt?.formatted() ?? "N/A")
                    }
                    
                    HStack {
                        Text("Updated At").foregroundStyle(.secondary)
                        Spacer()
                        Text(user.updatedAt?.formatted() ?? "N/A")
                    }
                    
                    HStack {
                        Text("Last Login").foregroundStyle(.secondary)
                        Spacer()
                        Text(user.lastLogin?.formatted() ?? "N/A")
                    }
                }
            }
            
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    /// Update the user
                    userStore.update(user)
                    
                    if user.id == AppManager.shared.user.id {
                        /// Update the user in the app manager
                        AppManager.shared.user = user
                    } else {
                        /// Dismiss the view
                        dismiss()
                    }
                    
                }
            }
        }
        .sheet(item: $editableVesselId) {
            editableVesselId = nil
        } content: { editableVesselId in
            VesselEditView(vesselId: editableVesselId)
        }

    }
}

extension String: @retroactive Identifiable {
    public typealias ID = Int
    public var id: Int {
        return hash
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
