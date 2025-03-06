//
//  TopLogoView.swift
//  IsmConcept
//
//  Created by Christophe Guégan on 05/03/2025.
//

import SwiftUI

struct TopLogoView: View {
    
    /// Main Body
    var body: some View {
        VStack {
            /// Logo
            Image("corail-square")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 180, height: 180)
                .padding(.bottom)
            /// App Title
            Text("ISM Concept")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
        }
    }
}


// MARK: - Preview
// ———————————————

#Preview {
    TopLogoView()
}
