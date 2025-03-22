//
//  InactiveUserView.swift
//  IsmConcept
//
//  Created by Christophe Guégan on 07/03/2025.
//

import SwiftUI

struct InactiveUserView: View {

    /// Environment Objects
    @Environment(AuthService.self) var authService
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            TopLogoView()
                .padding(.bottom)
            
            Text("Hello \(AppManager.shared.user.displayName)")
            Text("Your account is not currently active.\nPlease contact Yachting Concept Monaco for further support.")
                .multilineTextAlignment(.center)
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
    InactiveUserView()
        .environment(AuthService())
}
