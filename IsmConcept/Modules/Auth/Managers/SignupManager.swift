//
//  SignupManager.swift
//  IsmConcept
//
//  Created by Christophe Guégan on 05/03/2025.
//

import Foundation

@Observable
class SignupManager {
    
    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    var name: String = ""
    var isButtonDisabled: Bool = true
    var showAlert: Bool = false
    var errorMessage: String = ""
    
    
    // MARK: - Methods
    // ———————————————
    func signUp() {
        Task {
            do {
                try await AuthManager.shared.createUser(withEmail: email, password: password, name: name)
            } catch {
                errorMessage = error.localizedDescription
                showAlert = true
            }
        }
    }
    
    func signUp(for vessel: Vessel) async -> User? {
        do {
            return try await AuthManager.shared.createUser(for: vessel, withEmail: email, password: password, name: name)
        } catch {
            errorMessage = error.localizedDescription
            showAlert = true
            return nil
        }
    }
    
    
    // MARK: - Form validation
    // ————————————————————————
    var isFormValid: Bool {
        isEmailValid && isPasswordValid && isNameValid && isConfirmPasswordValid
    }
    
    
    // MARK: - Email Validation
    // ————————————————————————
    var isEmailValid: Bool {
        if email.isEmpty {
            return false
        } else {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailPred.evaluate(with: email)
        }
    }
    
    
    // MARK: - Password Validation
    // ———————————————————————————
    
    var checkMinChar: Bool {
        return password.count >= 8
    }
    var checkLetter: Bool {
        return password.rangeOfCharacter(from: .letters) != nil
    }
    var checkSpecialChar: Bool {
        return password.rangeOfCharacter(from: CharacterSet(charactersIn: "[{!@#$%^&*}]")) != nil
    }
    var checkNumber: Bool {
        return password.rangeOfCharacter(from: .decimalDigits) != nil
    }
    var isPasswordValid: Bool {
        if checkLetter && checkNumber && checkSpecialChar && checkMinChar {
            return true
        } else if checkLetter && !checkNumber && !checkSpecialChar {
            return false
        } else if checkNumber && !checkLetter && !checkSpecialChar {
            return false
        } else if checkSpecialChar && !checkLetter && !checkNumber {
            return false
        } else if checkLetter && checkNumber && !checkSpecialChar {
            return false
        } else if checkSpecialChar && checkLetter && checkNumber {
            return false
        } else {
            return false
        }
    }
    var isConfirmPasswordValid: Bool {
        if confirmPassword.isEmpty { return false }
        return confirmPassword == password
    }
    
    
    // MARK: - Name Validation
    // ———————————————————————
    
    var isNameValid: Bool {
        return name.count > 3
    }
    
}
