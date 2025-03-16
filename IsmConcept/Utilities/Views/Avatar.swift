//
//  Avatar.swift
//  IsmConcept
//
//  Created by Christophe Guégan on 15/03/2025.
//

import SwiftUI
import Kingfisher

struct Avatar: View {
    
    /// AvatarSize Enum
    enum AvatarSize {
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
    
    /// State properties
    var user: User
    var size: AvatarSize = .medium
    var withShadow: Bool = false
    
    /// Computed properties
    var url: URL {
        if let imageUrl = user.imageUrl,
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
            .modifier(AvatarModifier(size: size))
            .modifier(WithShadow(withShadow: withShadow))
    }
    
    /// Placeholder
    var placeholder: some View {
        Group {
            if let initials = user.initials() {
                Text(initials)
                    .font(.system(size: size.size / 2.2))
                    .fontDesign(.rounded)
                    .bold()
                    .foregroundColor(.white)
                    .modifier(AvatarModifier(size: size))
                    .modifier(WithShadow(withShadow: withShadow))
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .modifier(AvatarModifier(size: size))
                    .modifier(WithShadow(withShadow: withShadow))
            }
        }
    }
    
    /// AvatarModifier
    struct AvatarModifier: ViewModifier {
        var size: AvatarSize = .medium
        func body(content: Content) -> some View {
            content
                .foregroundColor(.white)
                .aspectRatio(contentMode: .fill)
                .frame(width: size.size, height: size.size)
                .background(Color.secondary.opacity(0.4))
                .background(Color.white)
                .clipShape(Circle())
        }
    }
    
    /// withShadow
    struct WithShadow: ViewModifier {
        var withShadow: Bool = false
        func body(content: Content) -> some View {
            if withShadow {
                content
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 2, y: 4)
                    .shadow(color: .black.opacity(0.2), radius: 4, y: 2)
            } else {
                content
            }
        }
    }
        
}

#Preview {
    Avatar(user: User.samples[0], size: .small)
    Avatar(user: User.samples[0], size: .medium)
    Avatar(user: User.samples[0], size: .large, withShadow: true)
}
