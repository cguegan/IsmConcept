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

    /// Initialization
    init() {
        FirebaseApp.configure()
    }
    
    /// Main Body
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(PreferencesManager())
        }
    }
    
}
