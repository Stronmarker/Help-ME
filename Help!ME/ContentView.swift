//
//  Home.swift
//  App
//
//  Created by Alexandre Andres-Robert on 29/03/2024.
//

import SwiftUI
import AuthenticationServices
import FirebaseAuth

struct Home: View {
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
                    .font(.subheadline)
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
                                
                            default:
                                break
                            }
                            
                            
                        case .failure(let error):
                            print(error)
                        }
                        
                    }
                    .padding(.vertical)
                    .frame(maxWidth: .infinity, maxHeight: 90)
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                .padding()
                .background(Color.black.opacity(0.2))
                .cornerRadius(10)
                .padding()
                
                Spacer()
            }
            
            .fullScreenCover(isPresented: $isLoggedIn) {
                abcd() // Assurez-vous que cette vue existe dans votre projet
            }
            
            .background(LinearGradient(gradient: Gradient(colors: [Color.black, Color.gray]), startPoint: .top, endPoint: .bottom))
        }
    }
}
    
    
    #Preview {
        Home()
    }




          
