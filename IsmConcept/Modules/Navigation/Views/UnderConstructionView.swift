//
//  UnderConstructionView.swift
//  iChecks
//
//  Created by Christophe Guégan on 08/09/2024.
//

import SwiftUI

struct UnderConstructionView: View {
    var body: some View {
        VStack {
            Image(systemName: "aqi.high")
                .font(.title)
                .padding(.bottom)
                .foregroundStyle(.accent)
            
            Text("Under Construction")
                .font(.headline)
                .padding(.bottom)
        }
        
    }
}

#Preview {
    UnderConstructionView()
}
