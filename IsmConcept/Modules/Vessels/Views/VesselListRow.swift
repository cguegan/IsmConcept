//
//  VesselListRow.swift
//  IsmConcept
//
//  Created by Christophe Guégan on 08/03/2025.
//

import SwiftUI

struct VesselListRow: View {
    
    /// Environment Properties
    @Environment(VesselStore.self) private var store
    
    /// Given Properties
    var vessel: Vessel
    
    /// Main Body
    var body: some View {
        HStack(alignment: .top) {
            
            Image(systemName: vessel.type.icon)
                .imageScale(.large)
                .foregroundColor(vessel.isActive ? .accentColor : .secondary)
            
            VStack(alignment: .leading) {
                Text(vessel.name)
                    .font(.headline)
                    .foregroundColor(vessel.isActive ? .primary : .secondary)
                Text(vessel.flag.rawValue)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    
            }
        }
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                withAnimation {
                    store.remove(vessel)
                }
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}

// MARK: - Preview
// ———————————————

#Preview {
    VesselListRow(vessel: Vessel.samples[0])
        .environment(UserStore())
}
