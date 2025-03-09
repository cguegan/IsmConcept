//
//  VesselsListView.swift
//  IsmConcept
//
//  Created by Christophe Guégan on 08/03/2025.
//

import SwiftUI

struct VesselsListView: View {
    
    /// Environment Properpties
    @State var store = VesselStore()

    /// State Properpties
    @State private var showingAddVesselView = false

    /// Main Body
    var body: some View {
        @Bindable var store = store
        NavigationStack {
            List {
                ForEach($store.vessels) { $vessel in
//                    NavigationLink(destination: UserDetailView(user: user).environment(store)) {
                        VesselListRow(vessel: vessel).environment(store)
//                    }
                }
            }
            .navigationTitle("Yachts")
            .sheet(isPresented: $showingAddVesselView) {
                VesselAddSheet().environment(store)
            }
            .toolbar {
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


// MARK: - Preview
// ———————————————

#Preview {
    @Previewable var store = VesselStore()
    //store.vessels = Vessel.samples
    VesselsListView()
        .environment(VesselStore())
}
