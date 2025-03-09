//
//  UserListRow.swift
//  IsmConcept
//
//  Created by Christophe Guégan on 08/03/2025.
//

import SwiftUI

struct UserListRow: View {
    
    /// Environment Properties
    @Environment(UserStore.self) private var store
    
    /// Given Properties
    var user: User
    
    /// Main Body
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: "photo")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            
            VStack(alignment: .leading) {
                Text(user.name)
                    .font(.headline)
                
                Text(user.role.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
            }
            
            Spacer()
            Text(user.vessel ?? "").padding(.top, 8)
            
        }
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                withAnimation {
                    store.remove(user)
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
    UserListRow(user: User.samples[0])
        .environment(UserStore())
}
