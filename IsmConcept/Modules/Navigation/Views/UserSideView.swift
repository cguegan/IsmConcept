//
//  UserSideView.swift
//  IsmConcept
//
//  Created by Christophe Guégan on 08/03/2025.
//

import SwiftUI

struct UserSideView: View {
    
    @Environment(AuthService.self) private var authService
    @Environment(UserStore.self) private var userStore


    var body: some View {
        HStack(alignment: .top) {
            UserAvatar(user: userStore.currentUser)
                .padding(.trailing)
                .padding(.leading, 12)
            
            VStack(alignment: .leading) {
                Text(userStore.currentUser.displayName)
                    .font(.headline)
                
                Text(userStore.currentUser.vessel ?? "No vessel")
                
                Text(userStore.currentUser.role.rawValue.capitalized)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    UserSideView()
        .environment(AuthService())
        .environment(UserStore())
}
