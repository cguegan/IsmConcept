//
//  SignupView.swift
//  iChecks
//
//  Created by Christophe Guégan on 11/5/24.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct SignupView: View {
    
    /// Environment Objects
    @Environment(\.dismiss) var dismiss
    //@Environment(UserPreferences.self) var userPreferences

    /// State manager
    @State private var manager = SignupManager()
        
    /// Focus Fields
    @FocusState private var focusedField: LoginFocusField?
    
    /// Main Body
    var body: some View {
        ZStack {
            backgroundView
            loginStackView
                .frame(maxWidth: 370)
                .alert(
                    manager.errorMessage,
                    isPresented: $manager.showAlert
                ) {
                    Button("OK", role: .cancel) {}
                }
        }
    }
}


// MARK: - Subviews
// ————————————————

extension SignupView {
    
    /// Login Stack View
    ///
    private var loginStackView: some View {
        VStack {
            Spacer()
            TopLogoView()
            topTitleView
            loginForm
            Spacer()
            LoginButton( title: "Signup",
                         disabled: !manager.isFormValid,
                         action: { manager.signUp() })
            backtoLoginButton
        }
    }
    
    
    /// Top Title View
    ///
    private var topTitleView: some View {
        Text("Set the highest standards of safety management onboard your yacht with iChecks ISM Compliance.")
            .font(.title3)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity)
            .padding()
    }
    
    /// Signup Form
    ///
    private var loginForm: some View {
        VStack {
            EmailField( email: $manager.email,
                        isValid: manager.isEmailValid,
                        focusedField: _focusedField )
                
            // Divider
            Divider().edgesIgnoringSafeArea(.all)
                .padding(.leading)
            
            // Full name field
            FullNameField( name: $manager.name,
                           isValid: manager.isNameValid,
                           focusedField: _focusedField )
            
            // Divider
            Divider().edgesIgnoringSafeArea(.all)
                .padding(.leading)
            
            // Password field
            PasswordField( placeholder: "Password",
                           password: $manager.password,
                           isValid: manager.isPasswordValid,
                           focusField: .password,
                           focusedField: _focusedField )
            
            // Divider
            Divider().edgesIgnoringSafeArea(.all)
                .padding(.leading)
            
            // Confirm Password field
            PasswordField( placeholder: "Confirm Password",
                           password: $manager.confirmPassword,
                           isValid: manager.isConfirmPasswordValid,
                           focusField: .confirmPassword,
                           focusedField: _focusedField )

        }
        .padding(.vertical,8)
        .background(Color.formBackground)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding()
    }
    
    /// Signup Button
    ///
    private var signupButton: some View {
        Button(action: {
            //createUser()
        }, label: {
            HStack {
                Text("Signup")
                Spacer()
                Image(systemName: "arrow.right")
            }
            .frame(maxWidth: .infinity)
            .padding(12)
        })
        .buttonStyle(.borderedProminent)
        .padding()
        .disabled(!manager.isFormValid)
    }
    
    /// Back to login Button
    ///
    private var backtoLoginButton: some View {
        HStack {
            Button("Login", action: {
                dismiss()
            })
            Text("if you already have an account?")
                .foregroundColor(.gray)
        }
        .padding(.horizontal)
        .padding(.bottom)
        
    }
    
    /// Background View
    ///
    private var backgroundView: some View {
        Color
            .gray
            .opacity(0.1)
            .edgesIgnoringSafeArea(.all)
    }
    
}


// MARK: - Preview
// ———————————————

#Preview {
    SignupView()
}
