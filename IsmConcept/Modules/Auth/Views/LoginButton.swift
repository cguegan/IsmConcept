//
//  LoginButton.swift
//  IsmConcept
//
//  Created by Christophe Guégan on 05/03/2025.
//

import SwiftUI

struct LoginButton: View {
    
    /// Given Property
    let title: String
    let disabled: Bool
    var action: () -> Void
    
    /// Main Body
    var body: some View {
        Button(action: {
            Task {
                self.action()
            }
        }, label: {
            HStack {
                Text(title)
                Spacer()
                Image(systemName: "arrow.right")
            }
            .frame(maxWidth: .infinity)
            .padding(12)
        })
        .buttonStyle(.borderedProminent)
        .padding()
        .disabled(disabled)
    }
}


// MARK: - Preview
// ———————————————

#Preview {
    LoginButton(title: "Login", disabled: false, action: {})
}
