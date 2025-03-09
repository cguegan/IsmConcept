//
//  UserAvatar.swift
//  IsmConcept
//
//  Created by Christophe Guégan on 09/03/2025.
//

import SwiftUI

struct UserAvatar: View {
    
    /// State Properties
    @State var user: User
    
    /// Main Body
    var body: some View {
        Group {
            if let imageUrl = user.imageUrl,
               let url = URL(string: imageUrl) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .background(Color.secondary.opacity(0.4))
                        .background(Color.white)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        .shadow(color: .black.opacity(0.2), radius: 10, x: 2, y: 4)
                        .shadow(color: .black.opacity(0.2), radius: 4, y: 2)
                } placeholder: {
                    ProgressView()
                }
            }  else {
                if let initials = user.initials() {
                    Text(initials)
                        .font(.title)
                        .fontDesign(.rounded)
                        .bold()
                        .foregroundColor(.white)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .background(Color.secondary.opacity(0.4))
                        .background(Color.white)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        .shadow(color: .black.opacity(0.2), radius: 10, x: 2, y: 4)
                        .shadow(color: .black.opacity(0.2), radius: 4, y: 2)
                }
            }
        }
    }
}

// MARK: - Preview
// ———————————————

#Preview {
    UserAvatar(user: User.samples[0])
        .padding(.bottom)
}
