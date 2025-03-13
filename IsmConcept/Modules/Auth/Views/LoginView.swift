//
//  LoginView.swift
//  iChecks
//
//  Created by Christophe Guégan on 11/5/24.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct LoginView: View {
    
    /// Environment Objects
    @Environment(AuthService.self) var authService

    /// State Properties
    @State private var manager = SignInManager()
    @State private var showSignupView: Bool = false
        
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
                .fullScreenCover(isPresented: $showSignupView) {
                    SignupView()
                }
        }
    }
}

// MARK: - Subviews

extension LoginView {
    
    /// Login Stack View
    ///
    private var loginStackView: some View {
        VStack {
            Spacer()
            TopLogoView()
            topTitleView
            loginForm
            Spacer()
            loginButton
        }
    }
    
    
    /// Top Title View
    ///
    private var topTitleView: some View {
        Text("Set the highest standards of safety management onboard your yacht with ISM Compliance.")
            .font(.title3)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity)
            .padding()
    }
    
    /// Login Form
    ///
    private var loginForm: some View {
        VStack {
            // Login field
            EmailField( email: $manager.email,
                        isValid: manager.isEmailValid,
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
        }
        .padding(.vertical, 8)
        .background(Color.formBackground)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding()
    }
    
    /// Login Button
    private var loginButton: some View {
        Button {
            Task {
                await manager.signIn(authService: authService)
            }
        } label: {
            HStack {
                Text("Login")
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
            
    /// Signup Button
    ///
    private var signupButton: some View {
        HStack {
            Text("Don't have an account yet?")
                .foregroundColor(.gray)
            
            Button("Signup", action: {
                showSignupView.toggle()
            })
        }
        .padding(.bottom)
        .padding(.trailing)
    }
    
    /// Background View
    ///
    private var backgroundView: some View {
        Color.gray
             .opacity(0.1)
             .edgesIgnoringSafeArea(.all)
    }
    
}


// MARK: - Preview
// ———————————————

#Preview {
    LoginView()
        .environment(AuthService())
}
