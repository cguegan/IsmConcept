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
    @Environment(AuthService.self) var authService

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
                    manager.errorMessage ?? "An Error Occured",
                    isPresented: $manager.showErrorAlert
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
            signupForm
            Spacer()
            signupButton
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
    private var signupForm: some View {
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
        Button {
            Task {
                await manager.signUp(authService: authService)
            }
        } label: {
            HStack {
                Text("Signup")
                Spacer()
                Image(systemName: "arrow.right")
            }
            .frame(maxWidth: .infinity)
            .padding(12)
        }
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
        .environment(AuthService())
}
