//
//  VesselDetailView.swift
//  IsmConcept
//
//  Created by Christophe Guégan on 09/03/2025.
//

import SwiftUI

struct VesselDetailView: View {
    
    /// Environment Properties
    @Environment(\.dismiss) private var dismiss
    @Environment(VesselStore.self) private var store
    
    /// State Properties
    @State private var vessel: Vessel
    @State private var showAddUser: Bool = false
    @State private var users: [User] = []

    /// Initializer
    init(vessel: Vessel) {
        print("[ DEBUG ] Vessel Details \(vessel.name)")
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
        List {
            
            /// Vessel Main Information
            Section(header: Text("Yacht Information")) {
                
                /// Vessel Name
                HStack {
                    Text("Name").foregroundStyle(.secondary)
                    Text(vessel.name)
                        .frame(maxWidth: .infinity, alignment: .trailing)

                }
                
                /// Type
                HStack {
                    Text("Yacht Type").foregroundStyle(.secondary)
                    Text(vessel.type.description)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                
                /// IMO Number
                HStack {
                    Text("IMO Number").foregroundStyle(.secondary)
                    Text(vessel.imo)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                
                /// Master
                HStack {
                    Text("Master").foregroundStyle(.secondary)
                    Text(vessel.master)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                
                /// Class
                HStack {
                    Text("Class").foregroundStyle(.secondary)
                    Text(vessel.classComp.description)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                
                /// Flag
                HStack {
                    Text("Flag").foregroundStyle(.secondary)
                    Text(vessel.flag.rawValue)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                
                /// Home Port
                HStack {
                    Text("Home Port").foregroundStyle(.secondary)
                    Text(vessel.homePort)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                
                /// Build Year
                HStack {
                    Text("Build Year").foregroundStyle(.secondary)
                    Text(vessel.year.description)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                
                /// Crew Mumber
                HStack {
                    Text("Crew Member").foregroundStyle(.secondary)
                    Text(vessel.crew.description)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                
                /// Guests Number
                HStack {
                    Text("Maximum Guests").foregroundStyle(.secondary)
                    Text(vessel.guests.description)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                
            }
            
            /// Dimensions
            Section(header: Text("Dimensions")) {
                /// Length Over All
                HStack {
                    Text("Length Over All").foregroundStyle(.secondary)
                    Text("\(vessel.loa.description) m")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                /// Beam
                HStack {
                    Text("Beam").foregroundStyle(.secondary)
                    Text("\(vessel.beam.description) m")
                        .frame(maxWidth: .infinity, alignment: .trailing)}
                /// Draft
                HStack {
                    Text("Draft").foregroundStyle(.secondary)
                    Text("\(vessel.draft.description) m")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                /// Gross Tonnage
                HStack {
                    Text("Gross Tonnage").foregroundStyle(.secondary)
                    Text("\(vessel.gt.description) GT")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
            
            /// Users
            Section(header: Text("Crew Members")) {
                if !vessel.users.isEmpty {
                    ForEach(self.users) { user in
                        HStack {
                            Text(user.displayName).bold()
                            Text(user.role.description).foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                } else {
                    Text("No users have been assigned yet to this yacht.")
                        .foregroundColor(.secondary)
                }
            }
            
        }
        .navigationTitle(vessel.name)
    }
}


// MARK: - Preview
// ———————————————

#Preview {
    NavigationStack {
        VesselDetailView(vessel: Vessel.samples[0])
            .environment(VesselStore())
    }
}
