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
        HStack {
            Image("user-square")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
                .cornerRadius(20)
                .padding(.trailing)
                .shadow(radius: 5, x: 0, y: 5)

            VStack(alignment: .leading) {
                Text(user.name)
                    .font(.headline)
                
                Text(user.vesselID ?? "No vessel")

                Text(user.role.description)
                    .foregroundColor(.secondary)
            }
                    
        }
    }
}

#Preview {
    UserSideView(user: User.samples[0])
}
