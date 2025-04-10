//
//  AddUserSheet.swift
//  iChecks
//
//  Created by Christophe Guégan on 11/5/24.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct AddUserSheet: View {
    
    /// Environment Objects
    @Environment(\.dismiss) private var dismiss
    @Environment(VesselStore.self) private var vesselStore
    @Environment(AuthService.self) private var authService

    /// State manager
    @State private var manager = SignupManager()
    @Binding var vessel: Vessel
        
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
                .navigationTitle("Add User")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                }
        }
        
    }
}


// MARK: - Subviews
// ————————————————

extension AddUserSheet {
    
    /// Login Stack View
    ///
    private var loginStackView: some View {
        VStack {
            Spacer()
            topTextView
            loginForm
            loginStrengthView
            Spacer()
            signupButton
        }
    }
    
    /// Top Text View
    ///
    private var topTextView: some View {
        Text("Create an a new crew user account for the vessel **\(vessel.name)**")
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
                        isValid: manager.isEmailValid )
                
            // Divider
            Divider().edgesIgnoringSafeArea(.all)
                .padding(.leading)
            
            // Full name field
            FullNameField( name: $manager.name,
                           isValid: manager.isNameValid )
            
            // Divider
            Divider().edgesIgnoringSafeArea(.all)
                .padding(.leading)
            
            // Password field
            PasswordField( placeholder: "Password",
                           password: $manager.password,
                           isValid: manager.isPasswordValid )
            
            // Divider
            Divider().edgesIgnoringSafeArea(.all)
                .padding(.leading)
            
            // Confirm Password field
            PasswordField( placeholder: "Confirm Password",
                           password: $manager.confirmPassword,
                           isValid: manager.isConfirmPasswordValid )

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
    
    /// Login Strength View
    ///
    private var loginStrengthView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: manager.isEmailValid ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(manager.isEmailValid ? .green :.secondary)
                
                Text("Valid Email Address")
                    .font(.subheadline)
                    .foregroundColor(manager.isEmailValid ? .primary :.secondary)
            }
            HStack {
                Image(systemName: manager.isNameValid ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(manager.isNameValid ? .green :.secondary)
                
                Text("Valid User Name")
                    .font(.subheadline)
                    .foregroundColor(manager.isEmailValid ? .primary :.secondary)
            }
            HStack {
                Image(systemName: manager.checkMinChar ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(manager.isNameValid ? .green :.secondary)
                
                Text("Password Length: 8 characters")
                    .font(.subheadline)
                    .foregroundColor(manager.checkMinChar ? .primary :.secondary)
            }
            HStack {
                Image(systemName: manager.checkLetter ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(manager.checkLetter ? .green :.secondary)
                
                Text("Password Contains Letters")
                    .font(.subheadline)
                    .foregroundColor(manager.checkLetter ? .primary :.secondary)
            }
            HStack {
                Image(systemName: manager.checkSpecialChar ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(manager.checkSpecialChar ? .green :.secondary)
                
                Text("Password Contains [{!@#$%^&*}]")
                    .font(.subheadline)
                    .foregroundColor(manager.checkSpecialChar ? .primary :.secondary)
            }
            HStack {
                Image(systemName: manager.checkNumber ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(manager.checkNumber ? .green :.secondary)
                
                Text("Password Numbers")
                    .font(.subheadline)
                    .foregroundColor(manager.checkNumber ? .primary :.secondary)
            }
            HStack {
                Image(systemName: manager.isConfirmPasswordValid ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(manager.isConfirmPasswordValid ? .green :.secondary)
                
                Text("Password Confirmation")
                    .font(.subheadline)
                    .foregroundColor(manager.isConfirmPasswordValid ? .primary :.secondary)
            }
        }
        .frame(maxWidth: 300, alignment: .leading)
    }
    
    /// Background View
    ///
    private var backgroundView: some View {
        Color
            .gray
            .opacity(0.1)
            .edgesIgnoringSafeArea(.all)
    }
    
    private func createUser() {
        Task {
            // TODO: - BUG HERE !!!
            await manager.signUpWithVessel(for: vessel, authService: authService)
            if let userId = authService.authenticatedUser?.uid {
                vessel.users.append(userId)
                vesselStore.update(vessel)
                dismiss()
            }
        }
    }
    
}


// MARK: - Preview
// ———————————————

#Preview {
    AddUserSheet(vessel: .constant(Vessel.samples[0]))
        .environment(VesselStore())
        .environment(AuthService())
}
