//
//  VesselsListView.swift
//  IsmConcept
//
//  Created by Christophe Guégan on 08/03/2025.
//

import SwiftUI

struct VesselsListView: View {
    
    /// Environment Properpties
    @Environment(UserStore.self) private var userStore
    @Environment(VesselStore.self) private var store

    /// State Properpties
    @State private var showingAddVesselView = false

    var activeVessels: [Vessel] {
        store.vessels.filter { $0.isActive }
    }
    
    var inactiveVessels: [Vessel] {
        store.vessels.filter { !$0.isActive }
    }
    
    /// Main Body
    var body: some View {
        @Bindable var store = store
        NavigationStack {
            List {
                if !activeVessels.isEmpty {
                    Section(header: Text("Active Yachts")) {
                        ForEach(activeVessels) { vessel in
                            NavigationLink(destination: VesselEditView(vesselId: vessel.id!)) {
                                VesselListRow(vessel: vessel)
                            }
                        }
                    }
                }
                
                if !inactiveVessels.isEmpty {
                    Section(header: Text("Inactive Yachts")) {
                        ForEach(activeVessels) { vessel in
                            NavigationLink(destination: VesselEditView(vesselId: vessel.id!)) {
                                VesselListRow(vessel: vessel)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Yachts")
            .sheet(isPresented: $showingAddVesselView) {
                VesselAddSheet().environment(store)
            }
            .toolbar {
                if AppManager.shared.user.canAddOrDeleteVessels() {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            showingAddVesselView.toggle()
                        }) {
                            Image(systemName: "plus.circle")
                        }
                    }
                }
            }
        }
    }
}


// MARK: - Preview
// ———————————————

#Preview {
    @Previewable var store = VesselStore()
    //store.vessels = Vessel.samples
    VesselsListView()
        .environment(VesselStore())
}
