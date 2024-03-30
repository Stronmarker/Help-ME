//
//  Register.swift
//  Help!ME
//
//  Created by Alexandre Andres-Robert on 30/03/2024.
//

import Foundation
import SwiftUI
import Firebase

struct LandmarkRegister: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var errorMessage = ""
    
    var passwordsMatch: Bool {
        return password == confirmPassword
    }
    
    private func isValidEmail(_ email: String) -> Bool {
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
        }
    
    var body: some View {
        VStack {
            Text("Inscription")
                .font(.title)
                .padding()
            
            TextField("Email", text: $email)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                .autocapitalization(.none)
            
            SecureField("Mot de passe", text: $password)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
            
            SecureField("Confirmer le mot de passe", text: $confirmPassword)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
            
            if !passwordsMatch {
                Text("Les mots de passe ne correspondent pas")
                    .foregroundColor(.red)
            }
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding(.top, 10)
            }
            
            Button(action: {
                guard passwordsMatch else { return }
                
                if isValidEmail(email) {
                    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                        if let error = error {
                            errorMessage = error.localizedDescription
                        } else {
                            print("Utilisateur créé avec succès")
                        }
                    }
                } else {
                    errorMessage = "Veuillez saisir une adresse e-mail valide."
                }
            }) {
                Text("S'Inscrire")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .disabled(!passwordsMatch || email.isEmpty)
            .padding(.top, 20)
            

            Spacer()
        }
        .padding()
    }
}

#Preview {
    LandmarkRegister()
}
