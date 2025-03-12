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
    
    /// Environment Objects
    @Environment(PreferencesManager.self) var preferences
    
    /// State properties
    @State private var authService = AuthService.shared
    @State private var userStore   = UserStore()
    @State private var vesselStore = VesselStore()
    
    /// Main Body
    @MainActor
    var body: some View {
        Group {
            if authService.isLoading {
                LoadingView()
            } else if !authService.isAuthenticated {
                LoginView()
            } else if let user = authService.currentUser {
                SplitView(user: user)
            }
        }
        .environment(userStore)
        .environment(vesselStore)
        .preferredColorScheme(preferences.colorScheme)
    }
}


// MARK: - Preview
// ———————————————

#Preview {
    ContentView()
        .environment(PreferencesManager())
}
