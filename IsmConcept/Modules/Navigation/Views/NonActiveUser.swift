//
//  NonActiveUser.swift
//  IsmConcept
//
//  Created by Christophe Guégan on 07/03/2025.
//

import SwiftUI

struct NonActiveUser: View {

    /// Environment Objects
    @Environment(AuthService.self) var authService
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            TopLogoView()
                .padding(.bottom)
            
            Text("Hello \(authService.user?.displayName ?? "unknown")")
                
            Text("Your account is not yet active.\nPlease contact support.")
            Spacer()
            Button("Sign Out", action: {
                Task {
                    try? await authService.signOut()
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
        .environment(AuthService())
}
