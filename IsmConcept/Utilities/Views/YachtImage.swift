//
//  YachtImage.swift
//  IsmConcept
//
//  Created by Christophe Guégan on 22/03/2025.
//

import SwiftUI
import Kingfisher

struct YachtImage: View {
    
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
        if let imageUrl = vessel.imageUrl,
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
            .modifier(LogoModifier(size: size))
            .modifier(WithShadow(withShadow: withShadow, size: size))
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
                    .modifier(WithShadow(withShadow: withShadow))
            } else {
                switch vessel.type {
                case .sailing:
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .modifier(LogoModifier(size: size))
                        .modifier(WithShadow(withShadow: withShadow))
                default:
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .modifier(LogoModifier(size: size))
                        .modifier(WithShadow(withShadow: withShadow))
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
                .frame(width: size.size * 1.613, height: size.size)
                .background(Color.secondary.opacity(0.4))
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: size.size/6.0))
        }
    }
    
    /// withShadow
    struct WithShadow: ViewModifier {
        var withShadow: Bool = false
        var size: LogoSize = .medium
        func body(content: Content) -> some View {
            if withShadow {
                content
                    .overlay(RoundedRectangle(cornerRadius: size.size/6.0)
                                .stroke(Color.white, lineWidth: 3))
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 2, y: 4)
                    .shadow(color: .black.opacity(0.2), radius: 4, y: 2)
            } else {
                content
            }
        }
    }
}

#Preview {
    YachtImage(vessel: Vessel.samples[1], size: .small)
    YachtImage(vessel: Vessel.samples[1], size: .medium)
    YachtImage(vessel: Vessel.samples[1], size: .large, withShadow: true)
}
