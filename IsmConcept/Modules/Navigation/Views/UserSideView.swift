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
        
        let user: User = AppManager.shared.user
        let vessel: Vessel = AppManager.shared.vessel
        
        HStack(alignment: .top) {
            Avatar(user: user, size: .small)
            
            VStack(alignment: .leading) {
                Text(user.displayName)
                    .font(.headline)
                
                if !vessel.name.isEmpty {
                    Text(vessel.name)
                }
                
                Text(user.role.description)
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
