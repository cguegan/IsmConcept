//
//  LoadingView.swift
//  IsmConcept
//
//  Created by Christophe Guégan on 11/03/2025.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView()
            Text("Loading...")
                .padding(.top)
        }
    }
}
