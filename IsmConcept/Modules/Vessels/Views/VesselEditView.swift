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
    
    /// Given Property
    @State var vessel: Vessel
    
    /// State Properties
    @State private var showAddUser: Bool = false
    
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
            Section(header: Text("Vessel")) {
                
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
                
                /// Crew Members
                HStack {
                    Text("Crew Member").foregroundStyle(.secondary)
                    TextField("Crew", value: $vessel.crew, formatter: NumberFormatter())
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                }
                /// Guests
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
                Text("Vessel Status")
            } footer: {
                Text("If the vessel is not active, users will not be able to access the current app.")
            }
            
            /// Users
            Section(header: Text("Users")) {
//                if !vessel.users.isEmpty {
//                    ForEach(self.$vessel.users) { $user in
//                        HStack {
//                            Text(user.displayName).bold()
//                            Spacer()
//                            Text(user.role.description).foregroundStyle(.secondary)
//                        }
//                    }
//                } else {
//                    Text("No users have been assigned to this vessel.")
//                        .foregroundColor(.secondary)
//                }
//
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
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    store.update(vessel)
                    dismiss()
                }
            }
        }
    }
}


// MARK: - Preview
// ———————————————

#Preview {
    VesselEditView(vessel: Vessel.samples[0])
        .environment(VesselStore())
}
