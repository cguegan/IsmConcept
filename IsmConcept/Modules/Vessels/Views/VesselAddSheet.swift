//
//  VesselAddSheet.swift
//  IsmConcept
//
//  Created by Christophe Guégan on 09/03/2025.
//

import SwiftUI

struct VesselAddSheet: View {
    
    /// Environment Properties
    @Environment(\.dismiss) var dismiss
    @Environment(VesselStore.self) private var store
    
    /// State Properties
    @State var vessel: Vessel = Vessel.blank
    
    /// Main Body
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Vessel Information")) {
                    
                    /// Full Name
                    HStack {
                        Text("Name").foregroundStyle(.secondary)
                        TextField("Name", text: $vessel.name)
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.trailing)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.words)
                    }
                    
                    /// IMO Number
                    HStack {
                        Text("IMO Number").foregroundStyle(.secondary)
                        TextField("IMO Number", text: $vessel.imo)
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
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
                    
                }
                
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
                    Text("If the vessel is not active, users will not be able to access it.")
                }
                    

            }
            .navigationBarTitle("Add Vessel")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        store.add(self.vessel)
                        dismiss()
                    }
                }
            }
        }
        
    }
}


// MARK: - Preview
// ———————————————

#Preview {
    NavigationStack {
        VesselAddSheet()
            .environment(VesselStore())
    }
}
