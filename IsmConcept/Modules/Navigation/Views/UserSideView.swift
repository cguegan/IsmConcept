//
//  UserSideView.swift
//  IsmConcept
//
//  Created by Christophe Guégan on 08/03/2025.
//

import SwiftUI

struct UserSideView: View {
    
    let user: User
    
    var body: some View {
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
}

#Preview {
    UserSideView(user: User.samples[0])
}
