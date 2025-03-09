//
//  Scheme.swift
//  iChecks
//
//  Created by Christophe Guégan on 11/7/24.
//

import Foundation
import SwiftUI

enum Scheme: Int, Identifiable, CaseIterable {
    case light
    case dark
    case unspecified
        
    var description: String {
        switch self {
            case .light: return "Light"
            case .dark: return "Dark"
            case .unspecified: return "System"
        }
    }
    
    var theme: ColorScheme? {
        switch self {
            case .light: return .light
            case .dark: return .dark
            default: return nil
        }
    }
    
    var uiInterfaceStyle: UIUserInterfaceStyle? {
        switch self {
            case .light: return .light
            case .dark: return .dark
            case .unspecified: return .unspecified
        }
    }
    
    var id: Self { self }
    
}
