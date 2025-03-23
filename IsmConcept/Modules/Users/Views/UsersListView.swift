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

    /// State Properpties
    @State private var showingAddUserView = false

    /// Main Body
    var body: some View {
        @Bindable var store = store
        NavigationStack {
            List {
                ForEach($store.users) { $user in
                    NavigationLink(destination: UserEditView(user: user)) {
                        UserListRow(user: user)
                    }
                }
            }
            .navigationTitle("Users")
            .alert( store.errorMessage ?? "An Error Occured",
                    isPresented: $store.showErrorAlert) {
                Button("OK", role: .cancel) { }
            }
            .toolbar {
                if AppManager.shared.user
                    .canAddOrDeleteVessels() {
                    ToolbarItem(
                        placement: .navigationBarTrailing
                    ) {
                        Button(
                            action: {
                                showingAddUserView
                                    .toggle()
                            }) {
                                Image(
                                    systemName: "plus.circle"
                                )
                            }
                    }
                }
            }
            .sheet( isPresented: $showingAddUserView) {
                UserAddSheet()
            }
                
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
