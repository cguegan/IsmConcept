//
//  UserSideView.swift
//  IsmConcept
//
//  Created by Christophe Guégan on 08/03/2025.
//

import SwiftUI

struct UserSideView: View {
    
    @Environment(AuthService.self) private var authService

    var body: some View {
        if let user = authService.user {
            HStack(alignment: .top) {
                UserAvatar(user: user)
                    .padding(.trailing)
                    .padding(.leading, 12)
                
                VStack(alignment: .leading) {
                    Text(user.displayName)
                        .font(.headline)
                    
                    Text(user.vessel ?? "No vessel")
                    
                    Text(user.role.rawValue)
                        .foregroundColor(.secondary)
                }
            }
        }
        else {
            Text("No User")
        }
    }
}

#Preview {
    UserSideView()
        .environment(AuthService())
}
