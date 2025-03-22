//
//  YachtLogo.swift
//  IsmConcept
//
//  Created by Christophe Guégan on 22/03/2025.
//

import SwiftUI
import Kingfisher

struct YachtLogo: View {
    
    enum LogoSize: CGFloat {
        case small
        case medium
        case large
        
        var size: CGFloat {
            switch self {
                case .small: return 44
                case .medium: return 60
                case .large: return 140
            }
        }
    }
        
    var vessel: Vessel
    var size: LogoSize = .medium
    var withShadow: Bool = false
    
    /// Computed properties
    var url: URL {
        if let imageUrl = vessel.logoUrl,
           let url = URL(string: imageUrl) {
               return url
        } else {
            return URL(string: "null")!
        }
    }
    
    /// Main Body
    var body: some View {
        KFImage(url)
            .placeholder { placeholder }
            .resizable()
            .padding(.horizontal, 10)
            .modifier(LogoModifier(size: size))
    }
    
    /// Placeholder
    var placeholder: some View {
        Group {
            if let initials = vessel.initials() {
                Text(initials)
                    .font(.system(size: size.size / 2.2))
                    .fontDesign(.rounded)
                    .bold()
                    .foregroundColor(.white)
                    .modifier(LogoModifier(size: size))
            } else {
                switch vessel.type {
                case .sailing:
                    Image(systemName: "sailboat")
                        .resizable()
                        .modifier(LogoModifier(size: size))
                default:
                    Image(systemName: "ferry")
                        .resizable()
                        .modifier(LogoModifier(size: size))
                }
            }
        }
    }
    
    /// AvatarModifier
    struct LogoModifier: ViewModifier {
        var size: LogoSize = .medium
        func body(content: Content) -> some View {
            content
                .foregroundColor(.white)
                .aspectRatio(contentMode: .fill)
                .frame(width: size.size * 1.618, height: size.size)
//                .background(Color.secondary.opacity(0.4))
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: size.size/6.0))
        }
    }
}

#Preview {
    YachtLogo(vessel: Vessel.samples[1], size: .small)
    YachtLogo(vessel: Vessel.samples[1], size: .medium)
    YachtLogo(vessel: Vessel.samples[1], size: .large, withShadow: true)
}
