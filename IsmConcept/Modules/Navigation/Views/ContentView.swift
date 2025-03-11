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
    @Environment(AuthService.self) var authService
    
    /// State properties
    @State var userStore   = UserStore()
    @State var vesselStore = VesselStore()
    
    /// Main Body
    @MainActor
    var body: some View {
        Group {
            if authService.isLoading {
                LoadingView()
            } else if !authService.isAuthenticated {
                LoginView()
            } else if let user = authService.currentUser {
                SplitView()
            }
        }
        .preferredColorScheme(preferences.colorScheme)
    }
}


// MARK: - Preview
// ———————————————

#Preview {
    ContentView()
        .environment(PreferencesManager())
}
