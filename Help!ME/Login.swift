//
//  Home.swift
//  App
//
//  Created by Alexandre Andres-Robert & Gaetan Finiels on 29/03/2024.
//

import SwiftUI
import AuthenticationServices
import FirebaseAuth

struct Login: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State private var emailUser = ""
    @State private var passwordUser = ""
    @State private var isLoggedIn: Bool = false
    
    @AppStorage("email") var email: String = ""
    @AppStorage("firstName") var firstName: String = ""
    @AppStorage("lastName") var lastName: String = ""
    @AppStorage("userId") var userId: String = ""
    
    @State private var isSignInWithApplePresented = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Help!ME")
                    .font(.largeTitle)
                    .foregroundColor(.orange)
                    .bold()
                    .padding()
                Text("Le réseau social où les parents sont contents de voir les enfants")
                    .font(.footnote)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .italic()
                    .padding()
                
                VStack(spacing: 20) {
                    TextField("Email", text: $emailUser)
                        .foregroundColor(.orange)
                        .padding()
                        .background(Color(.gray))
                        .cornerRadius(10)
                        .padding()
                        .bold()
                    
                    SecureField("Mot de passe", text: $passwordUser)
                        .foregroundColor(.orange)
                        .padding()
                        .background(Color(.gray))
                        .cornerRadius(10)
                        .padding()
                    
                    Button(action: {
                        // Authentifiez l'utilisateur avec Firebase Auth
                        Auth.auth().signIn(withEmail: emailUser, password: passwordUser) { result, error in
                            // Vérifiez s'il y a une erreur lors de l'authentification
                            if let error = error {
                                print("Erreur lors de l'authentification : \(error.localizedDescription)")
                                // Gérez l'erreur, par exemple, affichez un message à l'utilisateur
                            } else {
                                // L'utilisateur a été authentifié avec succès
                                print("Authentification réussie.")
                                // Définissez isLoggedIn sur true pour rediriger l'utilisateur
                                isLoggedIn = true
                            }
                        }
                    }) {
                        Text("Se Connecter")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    .padding(.top, 20)
                    
                    
                    SignInWithAppleButton(.continue) { request in
                        request.requestedScopes = [.email, .fullName]
                    } onCompletion: { result in
                        switch result {
                        case .success(let auth):
                            switch auth.credential {
                            case let credential as ASAuthorizationAppleIDCredential:
                                let userId = credential.user
                                let email = credential.email
                                let firstName = credential.fullName?.givenName
                                let lastName = credential.fullName?.familyName
                                
                                self.email = email ?? ""
                                self.userId = userId
                                self.firstName = firstName ?? ""
                                self.lastName = lastName ?? ""
                                
                                isLoggedIn = true
                            default:
                                break
                            }
                            break
                        case .failure(let error):
                            print(error)
                        }
                        
                    }
                    .signInWithAppleButtonStyle(
                        colorScheme == .dark ? .white : .black
                    )
                    .frame(height: 50)
                    .padding()
                    .cornerRadius(8)
                    
                    Spacer()
                }
                
                
                .fullScreenCover(isPresented: $isLoggedIn) {
                    abcd()
                }
                
            }
            .background(LinearGradient(gradient: Gradient(colors: [Color.black, Color.gray]), startPoint: .top, endPoint: .bottom))
        }
    }
}
    

#Preview {
    Login()
}

