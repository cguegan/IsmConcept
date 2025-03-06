//
//  PasswordField.swift
//  IsmConcept
//
//  Created by Christophe Guégan on 05/03/2025.
//

import SwiftUI

struct PasswordField: View {
    
    /// Given Properties
    let placeholder: String
    @Binding    var password: String
                var isValid: Bool
                var focusField: LoginFocusField
    @FocusState var focusedField: LoginFocusField?

    /// State Properties
    @State private var checkMinChar = false
    @State private var checkLetter = false
    @State private var checkSpecialChar = false
    @State private var checkNumber = false
    @State private var showPassword = false
    @State private var showPopover = false
    
    var progressColor: Color {
        if password.isEmpty {
            return Color.gray.opacity(0.2)
        } else {
            return isValid ? .green : .red
        }
    }
    
    /// Main Body
    var body: some View {
        HStack {
            Image(systemName: showPassword ? "key.slash" :"key")
                .foregroundStyle(.gray)
                .frame(width: 24, alignment: .leading)
                .contentShape(Rectangle())
                .contentTransition(.symbolEffect)
                .onTapGesture {
                    withAnimation {
                        showPassword.toggle()
                    }
                }
            
            ZStack(alignment: .trailing) {
                ZStack(alignment: .leading) {
                    SecureField(placeholder, text: $password)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .submitLabel(.next)
                        .focused($focusedField, equals: focusField)
                        .onSubmit { focusedField = nil }
                        .opacity(showPassword ? 0 : 1)
                    
                    TextField(placeholder, text: $password)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .submitLabel(.next)
                        .focused($focusedField, equals: .password)
                        .onSubmit { focusedField = focusField }
                        .opacity(showPassword ? 1 : 0)
                }
                
                Image(systemName: "checkmark")
                    .padding(.trailing, 8)
                    .foregroundColor(progressColor).contentShape(Rectangle())
            }
        }
        .padding([.top, .bottom], 6)
        .padding(.leading)
    }

}

// MARK: - Preview
// ———————————————

#Preview {
    PasswordField( placeholder: "Password",
                   password: .constant("123456"),
                   isValid: false,
                   focusField: .password )
}
