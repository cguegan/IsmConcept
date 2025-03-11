//
//  NonActiveUser.swift
//  IsmConcept
//
//  Created by Christophe Guégan on 07/03/2025.
//

import SwiftUI

struct NonActiveUser: View {
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            TopLogoView()
                .padding(.bottom)
            
            Text("Hello \(AuthService.shared.currentUser?.displayName ?? "unknown")")
                
            Text("Your account is not yet active.\nPlease contact support.")
            Spacer()
            Button("Sign Out", action: {
                Task {
                    try? await AuthService.shared.signOut()
                }
            })
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: 370)
    }
}


// MARK: - Preview
// ———————————————

#Preview {
    NonActiveUser()
}
