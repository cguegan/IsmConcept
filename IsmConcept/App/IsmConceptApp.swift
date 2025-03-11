//
//  IsmConceptApp.swift
//  IsmConcept
//
//  Created by Christophe Guégan on 05/03/2025.
//

import SwiftUI
import FirebaseCore

@main
struct IsmConceptApp: App {
    
    /// State Properties
    @State var preferences = PreferencesManager.shared
    @State private var authService: AuthService

    /// Initialization
    init() {
        FirebaseApp.configure()
        self.authService = AuthService()
    }
    
    /// Main Body
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(PreferencesManager())
                .environment(AuthService())
        }
    }
    
}
