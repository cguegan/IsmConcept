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
    @State var userStore   = UserStore()
    @State var vesselStore = VesselStore()
    
    /// Main Body
    @MainActor
    var body: some View {
        Group {
            switch AuthManager.shared.loginStatus {
                case .loggedOut:
                    LoginView()
                case .active:
                    SplitView()
                        .environment(UserStore())
                        .environment(VesselStore())
                case .inactive:
                    NonActiveUser()
                case .checking:
                    ProgressView()
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
