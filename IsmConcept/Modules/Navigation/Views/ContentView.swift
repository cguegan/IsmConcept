//
//  ContentView.swift
//  IsmConcept
//
//  Created by Christophe Guégan on 05/03/2025.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct ContentView: View {
    
    var body: some View {
        Group {
            if AuthManager.shared.userSession != nil {
                if let user = AuthManager.shared.user {
                    if user.isActive {
                        SplitView(user: user)
                    } else {
                        NonActiveUser()
                    }
                } else {
                    ProgressView()
                }
            } else {
                LoginView()
            }
        }
//        .preferredColorScheme(userPreferences.colorScheme)
    }
}


// MARK: - Preview
// ———————————————

#Preview {
    ContentView()
}
