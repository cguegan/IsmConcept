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

    /// Main Body
    var body: some View {
        @Bindable var store = store
        NavigationStack {
            List {
                Text("Number of Vessels: \(store.vessels.count)")
                ForEach(store.vessels) { vessel in
                    NavigationLink(destination: VesselEditView(vessel: vessel)) {
                        VesselListRow(vessel: vessel)
                    }
                }
            }
            .navigationTitle("Yachts")
            .sheet(isPresented: $showingAddVesselView) {
                VesselAddSheet().environment(store)
            }
            .toolbar {
                if userStore.currentUser.canAddOrDeleteVessels() {
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
