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
    @State private var userStore   = UserStore()
    @State private var vesselStore = VesselStore()
    
    /// Main Body
    @MainActor
    var body: some View {
        Group {
            switch AppManager.shared.state {
            case .loading:
                LoadingView()
            case .signedIn:
                SplitView()
            case .signedOut:
                LoginView()
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
        .environment(AuthService())
}
