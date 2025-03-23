//
//  FullNameField.swift
//  IsmConcept
//
//  Created by Christophe Guégan on 05/03/2025.
//

import SwiftUI

struct FullNameField: View {
    
    /// Given Property
    @Binding    var name: String
                var isValid: Bool
//    @FocusState var focusedField: LoginFocusField?
    
    /// Computed Property
    var progressColor: Color {
        if name.isEmpty {
            return Color.gray.opacity(0.2)
        } else {
            return isValid ? .green : .red
        }
    }
    
    /// Main Body
    var body: some View {
        ZStack(alignment: .trailing) {
            HStack {
                Image(systemName: "person")
                    .foregroundStyle(.gray)
                    .frame(width: 24, alignment: .leading)
                
                TextField("Full Name", text: $name)
                    .autocorrectionDisabled()
                    .submitLabel(.next)
//                    .focused($focusedField, equals: .fullName)
//                    .onSubmit {
//                        focusedField = .fullName
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
    FullNameField( name: .constant("Christophe Guégan"),
                   isValid: false )
}
