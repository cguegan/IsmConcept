//
//  VesselEditView.swift
//  IsmConcept
//
//  Created by Christophe Guégan on 09/03/2025.
//

import SwiftUI

struct VesselEditView: View {
    
    /// Environment Properties
    @Environment(\.dismiss) private var dismiss
    @Environment(VesselStore.self) private var store
    
    /// State Properties
    @State private var vessel: Vessel
    @State private var showAddUser: Bool = false
    @State private var users: [User] = []
    @State private var edited: Bool = false

    /// Initializer
    init(vessel: Vessel) {
        print("[ DEBUG ] Vessel Edit \(vessel.name)")
        self.vessel = vessel
    }
    
    /// Computed Properties
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()

    /// Main Body
    var body: some View {
        Form {
            
            /// Vessel Main Information
            Section(header: Text("Yacht Information")) {
                
                /// Vessel Name
                HStack {
                    Text("Name").foregroundStyle(.secondary)
                    TextField("Name", text: $vessel.name)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.trailing)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.words)
                }
                
                /// Type
                HStack {
                    Text("Yacht Type").foregroundStyle(.secondary)
                    Spacer()
                    Picker("Yacht Type", selection: $vessel.type) {
                        ForEach(VesselType.allCases, id: \.self) { type in
                            Text(type.description).tag(type)
                        }
                    }
                    .foregroundColor(.primary)
                    .labelsHidden()
                }
                
                /// IMO Number
                HStack {
                    Text("IMO Number").foregroundStyle(.secondary)
                    TextField("Name", text: $vessel.imo)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.trailing)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.words)
                }
                
                /// Master
                HStack {
                    Text("Master").foregroundStyle(.secondary)
                    TextField("Master", text: $vessel.master)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.trailing)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.words)
                }
                
                /// Class
                HStack {
                    Text("Class").foregroundStyle(.secondary)
                    Spacer()
                    Picker("Class", selection: $vessel.classComp) {
                        ForEach(Classification.allCases) { classComp in
                            Text(classComp.rawValue).tag(classComp)
                        }
                    }
                    .labelsHidden()
                }
                
                /// Flag
                HStack {
                    Text("Flag").foregroundStyle(.secondary)
                    Spacer()
                    Picker("Flag", selection: $vessel.flag) {
                        ForEach(Flag.allCases, id: \.self) { flag in
                            Text(flag.rawValue).tag(flag)
                        }
                    }
                    .labelsHidden()
                }
                
                /// Home Port
                HStack {
                    Text("Home Port").foregroundStyle(.secondary)
                    TextField("Port", text: $vessel.homePort)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.trailing)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.words)
                }
                
                /// Build Year
                HStack {
                    Text("Build Year").foregroundStyle(.secondary)
                    TextField("Year", value: $vessel.year, formatter: NumberFormatter())
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                }
                
                /// Crew Mumber
                HStack {
                    Text("Crew Member").foregroundStyle(.secondary)
                    TextField("Crew", value: $vessel.crew, formatter: NumberFormatter())
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                }
                
                /// Guests Number
                HStack {
                    Text("Maximum Guests").foregroundStyle(.secondary)
                    TextField("Guest", value: $vessel.guests, formatter: NumberFormatter())
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                }
                
            }
            
            /// Dimensions
            Section(header: Text("Dimensions")) {
                /// Length Over All
                HStack {
                    Text("Length Over All").foregroundStyle(.secondary)
                    TextField("LOA", value: $vessel.loa, formatter: numberFormatter)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                    Text("m").foregroundStyle(.secondary)
                }
                /// Beam
                HStack {
                    Text("Beam").foregroundStyle(.secondary)
                        TextField("Beam", value: $vessel.beam, formatter: numberFormatter)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                    Text("m").foregroundStyle(.secondary)
                }
                /// Draft
                HStack {
                    Text("Draft").foregroundStyle(.secondary)
                    TextField("Draft", value: $vessel.draft, formatter: numberFormatter)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                    Text("m").foregroundStyle(.secondary)
                }
                /// Gross Tonnage
                HStack {
                    Text("Gross Tonnage").foregroundStyle(.secondary)
                    TextField("Gross Tonnage", value: $vessel.gt, formatter: NumberFormatter())
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                    Text("GT").foregroundStyle(.secondary)
                }
            }
            
            /// Vessel Status
            Section {
                HStack {
                    Text("Is Active").foregroundStyle(.secondary)
                    Spacer()
                    Toggle("Active", isOn: $vessel.isActive)
                        .labelsHidden()
                }
            } header: {
                Text("Yacht Status")
            } footer: {
                Text("If the yacht is not active, users will not be able to access the current app.")
            }
            
            /// Users
            Section(header: Text("Crew Members")) {
                if !vessel.users.isEmpty {
                    ForEach(self.users) { user in
                        HStack {
                            Text(user.displayName).bold()
                            Spacer()
                            Text(user.role.description).foregroundStyle(.secondary)
                        }
                    }
                } else {
                    Text("No users have been assigned yet to this vessel.")
                        .foregroundColor(.secondary)
                }

                /// Add User Button
                Button {
                    print("[ DEBUG ] Add User")
                    showAddUser.toggle()
                } label: {
                    Label("Add User", systemImage: "person.badge.plus")
                }
            }
            
        }
        .navigationTitle(vessel.name)
        .sheet(isPresented: $showAddUser) {
            AddUserSheet(vessel: $vessel)
        }
        .onChange(of: vessel) {
            print("[ DEBUG ] Vessel Changed")
            self.edited = true
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    store.update(vessel)
                    dismiss()
                }
                .disabled(!self.edited)
                .buttonStyle(.borderedProminent)
            }
        }
//        .onAppear {
//            Task {
//                if let vessel = await store.fetch(withID: vesselId) {
//                    self.vessel = vessel
//                    self.users = await store.fetchUsers(for: vessel)
//                }
//            }
//        }
    }
}


// MARK: - Preview
// ———————————————

#Preview {
    NavigationStack {
        VesselEditView(vessel: Vessel.samples[0])
            .environment(VesselStore())
    }
}
