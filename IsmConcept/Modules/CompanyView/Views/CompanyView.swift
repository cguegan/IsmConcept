//
//  CompanyView.swift
//  iChecks
//
//  Created by Christophe Guégan on 07/09/2024.
//

import SwiftUI

struct CompanyView: View {
    
    /// Environment Objects
    @Environment(\.horizontalSizeClass) private var sizeClass
    @Environment(PreferencesManager.self) var preferences

    var remoteService = RemoteConfigService()
    
    // MARK: - Main Body
    // —————————————————
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .center, spacing: 24) {
                
                TopLogoView()
                
                Text(.init(remoteService.welcomeMessage))
                    .font(.system(size: sizeClass == .compact ? 16 : 20))
                    .padding(.bottom)
                    .frame(maxWidth: .infinity)
                
                // Name of the DPA
                HStack(spacing: 20) {
                    IconView("person")
                    
                    VStack(alignment: .leading) {
                        Text(remoteService.dpaOnWatch)
                            .font(.headline)
                            .bold()
                        Text("Current DPA on watch")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 8.0))
                
                // Phone number
                HStack(spacing: 20) {
                    IconView("phone")
                    
                    VStack(alignment: .leading) {
                        Text(remoteService.emergencyNumber)
                            .font(.headline)
                        
                        Text("(24/7)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 8.0))
                
                // Email address
                HStack(spacing: 20) {
                    IconView("paperplane")
                    
                    VStack(alignment: .leading) {
                        Text(remoteService.email)
                            .font(sizeClass == .compact ? .subheadline : .headline)
                            .bold()
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 8.0))
                
                // Company Address
                HStack(alignment: .top, spacing: 20) {
                    IconView("location.fill")
                    
                    VStack(alignment: .leading) {
                        Text("Company Address")
                            .font(.headline)
                        
                        Text(remoteService.companyAddress)
                        
                    }
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 8.0))
                
                
                // IMO Company Number
                HStack(spacing: 20) {
                    IconView("number")
                    
                    HStack(alignment: .center) {
                        Text("Company IMO Number: ")                            .font(.headline)
                        Text(remoteService.companyIMONumber)
                    }
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 8.0))
                
                // Copyright
                HStack(alignment: .top, spacing: 20) {
                    Text("©")
                        .font(.system(size: 42, weight: .semibold))
                        .foregroundColor(.accentColor)
                        .padding(.horizontal, sizeClass == .regular ? 16 : 0)
                    
                    HStack(alignment: .center) {
                        Text(.init(remoteService.copyright))
                    }
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 8.0))
                
                Spacer()
            }
            .toolbar(removing: .none)
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            .frame(maxWidth: 660)
        }
        .frame(maxWidth: .infinity)
    }
}

extension CompanyView {
    func IconView(_ systemImage: String) -> some View {
        Image(systemName: systemImage)
            .resizable()
            .scaledToFit()
            .frame(width: 32)
            .foregroundColor(.accentColor)
            .padding(.horizontal, sizeClass == .regular ? 20 : 0)
    }
}
            
          

#Preview {
    CompanyView()
        .environment(PreferencesManager())
}
