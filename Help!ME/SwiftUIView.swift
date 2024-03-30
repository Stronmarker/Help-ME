//
//  SwiftUIView.swift
//  Help!ME
//
//  Created by Alexandre Andres on 29/03/2024.
//

import AuthenticationServices
import SwiftUI

struct SwiftUIView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State private var isLoggedIn: Bool = false
    
    @AppStorage("email") var email: String = ""
    @AppStorage("firstName") var firstName: String = ""
    @AppStorage("lastName") var lastName: String = ""
    @AppStorage("userId") var userId: String = ""
    
    
    var body: some View {
        NavigationStack {
            VStack {
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
            }
            .navigationTitle("Sign In")
            .background(LinearGradient(gradient: Gradient(colors: [Color.black, Color.gray]), startPoint: .top, endPoint: .bottom))
        }
        
        
        .fullScreenCover(isPresented: $isLoggedIn) {
            abcd()
        }
    }
}


#Preview {
    SwiftUIView()
}
