//
//  UsersListView.swift
//  IsmConcept
//
//  Created by Christophe Guégan on 08/03/2025.
//

import SwiftUI

struct UsersListView: View {
    
    /// Environment Properpties
    @Environment(UserStore.self) var store
    @Environment(AuthService.self) var authService

    /// State Properpties
    @State private var showingAddUserView = false

    /// Main Body
    var body: some View {
        @Bindable var store = store
        NavigationStack {
            List {
                ForEach($store.users) { $user in
                    NavigationLink(destination: UserEditView(user: user)) {
                        UserListRow(user: user).environment(store)
                    }
                }
            }
            .navigationTitle("Users")
        }
    }
}


// MARK: - Preview
// ———————————————

#Preview {
    UsersListView()
        .environment(UserStore())
        .environment(AuthService())
}
