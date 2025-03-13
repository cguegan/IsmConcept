//
//  PreferencesManager.swift
//  IsmConcept
//
//  Created by Christophe Guégan on 07/03/2025.
//

import SwiftUI
import Foundation


@MainActor
@Observable
class PreferencesManager {
    
    class Storage {
        @AppStorage("user_allow_editing")   public var allowEditing: Bool = false
        @AppStorage("user_admin_mode")      public var adminMode: Bool = false
        @AppStorage("app_night_vision")     public var nightVision: Bool = false
        @AppStorage("app_appearance")       public var appearance: Scheme = .light
    }
    
    init() {
        let sharedDefault = UserDefaults.standard
        isNightMode  = sharedDefault.bool(forKey: "app_night_vision")
        adminMode    = sharedDefault.bool(forKey: "user_admin_mode")
        allowEditing = sharedDefault.bool(forKey: "user_allow_editing")
        colorScheme  = appearance.theme
    }
    
    public static let sharedDefault = UserDefaults(suiteName: "silex.net.ismConcept")
    public static let shared = PreferencesManager()
    private let storage = Storage()
    
    /// Published properties
    ///
    var colorScheme:    ColorScheme?
    var isNightMode:    Bool = false
    var isAdminMode:    Bool = false
    var isAllowEditing: Bool = false
    
    /// Updates the app storage values
    ///
    var allowEditing: Bool {
        set {
            storage.allowEditing = newValue
        }
        get {
            return storage.allowEditing
        }
    }
    
    var adminMode: Bool {
        set {
            storage.adminMode = newValue
            isAdminMode = newValue
        }
        get {
            return storage.adminMode
        }
    }
    
    var nightVision: Bool {
        set {
            storage.nightVision = newValue
            withAnimation {
                isNightMode = newValue
                if newValue == true {
                    colorScheme = .dark
                } else {
                    colorScheme = appearance.theme
                }
                    
            }
        }
        get {
            return storage.nightVision
        }
    }
    
    var appearance: Scheme {
        set {
            colorScheme = newValue.theme
            withAnimation(.easeInOut(duration: 10)) {
                storage.appearance = newValue
            }
        }
        get {
            return storage.appearance
        }
    }

}
