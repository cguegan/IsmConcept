//
//  UsersListView.swift
//  IsmConcept
//
//  Created by Christophe Guégan on 08/03/2025.
//

import SwiftUI

struct UsersListView: View {
    
    /// Environment Properpties
    @State var store = UserStore()

    /// State Properpties
    @State private var showingAddUserView = false

    /// Main Body
    var body: some View {
        @Bindable var store = store
        NavigationStack {
            List {
                ForEach($store.users) { $user in
                    NavigationLink(destination: UserEditView(user: user).environment(store)) {
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
}
