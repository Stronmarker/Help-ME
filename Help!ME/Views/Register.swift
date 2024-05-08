//
//  Register.swift
//  Help!ME
//
//  Created by Alexandre Andres-Robert on 30/03/2024.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore

struct Register: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var pseudo = ""
    @State private var errorMessage = ""
    
    var passwordsMatch: Bool {
        return password == confirmPassword
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    private func checkPseudo(pseudo: String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        db.collection("user").whereField("pseudo", isEqualTo: pseudo).getDocuments { snapshot, error in
            if let error = error {
                print("Error checking pseudo: \(error.localizedDescription)")
                completion(false)
                return
            }
            if let snapshot = snapshot, snapshot.documents.isEmpty {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    var body: some View {
        VStack {
            Spacer()
            Text("Inscription")
                .font(.largeTitle)
                .padding()
                .foregroundColor(.orange)
            
            TextField("Pseudo", text: $pseudo)
                .padding()
                .background(Color(.gray))
                .cornerRadius(10)
                .padding()
                .autocapitalization(.none)
            
            
            TextField("Email", text: $email)
                .padding()
                .background(Color(.gray))
                .cornerRadius(10)
                .padding()
                .autocapitalization(.none)
            
            SecureField("Mot de passe", text: $password)
                .padding()
                .background(Color(.gray))
                .cornerRadius(10)
                .padding()
            
            SecureField("Confirmer le mot de passe", text: $confirmPassword)
                .padding()
                .background(Color(.gray))
                .cornerRadius(10)
                .padding()
            
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
                
                checkPseudo(pseudo: pseudo) { isUnique in
                    if isUnique {
                        if isValidEmail(email) {
                            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                                if let error = error {
                                    errorMessage = error.localizedDescription
                                } else {
                                    let db = Firestore.firestore()
                                    if let userId = authResult?.user.uid {
                                        db.collection("users").document(userId).setData([
                                            "pseudo": pseudo
                                        ]) { error in
                                            if let error = error {
                                                errorMessage = "Failed to save user data: \(error.localizedDescription)"
                                            } else {
                                                print("Utilisateur créé avec succès")
                                            }
                                        }
                                    }
                                }
                            }
                        } else {
                            errorMessage = "Veuillez saisir une adresse e-mail valide."
                        }
                    } else {
                        errorMessage = "Ce pseudo est déjà pris."
                    }
                }
            }) {
                Text("S'Inscrire")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
                
            }
            .disabled(!passwordsMatch || email.isEmpty)
            .padding(.top, 20)
            
            
            Spacer()
        }
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: [Color.black, Color.gray]), startPoint: .top, endPoint: .bottom))
        
    }
}

#Preview {
    Register()
}
