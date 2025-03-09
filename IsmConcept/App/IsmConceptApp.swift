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
    
    @State private var preferences = PreferencesManager.shared
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(preferences)
        }
    }
}
