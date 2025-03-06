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
                VStack {
                    
                    Spacer()
                    
                    Image(systemName: "globe")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    Text("\(AuthManager.shared.user?.name ?? "Unknown user") is logged in")
                    
                    Spacer()
                    
                    Button("Sign Out", action: {
                        AuthManager.shared.signOut()
                    })
                    .buttonStyle(.borderedProminent)
                }
            } else {
                LoginView()
            }
        }
//        .preferredColorScheme(userPreferences.colorScheme)
    }
}

#Preview {
    ContentView()
}
