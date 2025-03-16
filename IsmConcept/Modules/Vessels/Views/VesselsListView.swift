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
    @Environment(VesselStore.self) private var vesselStore

    /// State Properpties
    @State private var showingAddVesselView = false
    
    /// Main Body
    var body: some View {
        @Bindable var vesselStore = vesselStore
        NavigationStack {
            List {
                Section(header: Text("Yachts")) {
                    ForEach(vesselStore.vessels) { vessel in
                        NavigationLink(destination: VesselEditView(vesselId: vessel.id!)) {
                            VesselListRow(vessel: vessel)
                        }
                    }
                }
            }
            .navigationTitle("Yachts")
            .sheet(isPresented: $showingAddVesselView) {
                VesselAddSheet().environment(vesselStore)
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
