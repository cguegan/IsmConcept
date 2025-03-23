//
//  EmailField.swift
//  IsmConcept
//
//  Created by Christophe Guégan on 05/03/2025.
//

import SwiftUI

struct EmailField: View {
    
    /// Given properties
    @Binding    var email: String
                var isValid: Bool
//    @FocusState var focusedField: LoginFocusField?
    
    /// State Properties
    @State private var showPopover = false

    /// Computed Properties
    var progressColor: Color {
        if email.isEmpty {
            return Color.gray.opacity(0.2)
        } else {
            return isValid ? .green : .red
        }
    }
    
    /// Main Body
    var body: some View {
        ZStack(alignment: .trailing) {
            HStack {
                Image(systemName: "envelope")
                    .foregroundStyle(.gray)
                    .frame(width: 24, alignment: .leading)
                
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .submitLabel(.next)
//                    .focused($focusedField, equals: .email)
//                    .onSubmit {
//                        focusedField = .password
//                    }
            }
            
            Image(systemName: "checkmark")
                .padding(.trailing, 8)
                .foregroundColor(progressColor).contentShape(Rectangle())
        }
        .padding([.top, .bottom], 6)
        .padding(.leading)
    }
}


// MARK: - Preview
// ———————————————

#Preview {
    EmailField( email: .constant(""),
                isValid: false )
}
