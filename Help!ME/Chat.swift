//
//  Chat.swift
//  Help!ME
//
//  Created by Alexandre Andres on 29/04/2024.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift


let backgroundGradient = LinearGradient(
    colors: [Color.black, Color.gray],
    startPoint: .top, endPoint: .bottom)

struct Chat: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var messages: [Message] = []
    @State private var newMessage: String = ""
    @State private var scrollViewProxy: ScrollViewProxy? // Keep a proxy to scroll to the bottom

    var body: some View {
        ZStack {
            backgroundGradient
            .edgesIgnoringSafeArea(.all)

            VStack {
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack {
                            ForEach(messages) { message in
                                MessageView(message: message, isCurrentUser: message.user == authManager.currentUser?.uid)
                                    .id(message.id)  // Set id for scrolling
                            }
                        }
                    }
                    .onAppear {
                        scrollViewProxy = proxy
                    }
                }
                .onChange(of: messages) {
                    scrollViewProxy?.scrollTo(messages.last?.id, anchor: .bottom)
                }




                HStack {
                    TextField("Texte du message", text: $newMessage)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    Button(action: sendMessage) {
                        Image(systemName: "envelope.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.orange)
                    }
                }
//                .padding()
            }
            .navigationTitle("Chat Public")
            .navigationBarHidden(true)
            .onAppear(perform: loadMessages)
        }
    }

    func sendMessage() {
        guard let user = authManager.currentUser?.uid else {
            print("Aucun utilisateur n'est connecté.")
            return
        }

        
        Firestore.firestore().collection("users").document(user).getDocument { document, error in
                if let document = document, let pseudo = document.data()?["pseudo"] as? String {
                    let newDoc = Firestore.firestore().collection("publicMessages").document()
                    let message = Message(id: newDoc.documentID, user: user, pseudo: pseudo, text: newMessage)

                    do {
                        try newDoc.setData(from: message)
                        newMessage = ""
                    } catch {
                        print("Erreur lors de l'ajout du message: \(error)")
                    }
                } else {
                    print("Erreur lors de la récupération du pseudo: \(error?.localizedDescription ?? "Erreur inconnue")")
                }
            }
        }

    func loadMessages() {
        let db = Firestore.firestore()
        db.collection("publicMessages").order(by: "timestamp").addSnapshotListener { snapshot, error in
            guard let documents = snapshot?.documents else {
                print("Erreur lors de la récupération des messages: \(error?.localizedDescription ?? "Erreur inconnue")")
                return
            }

            self.messages = documents.compactMap { try? $0.data(as: Message.self) }
        }
    }
}

struct Message: Identifiable, Codable, Equatable {
    @DocumentID var id: String?
    var user: String
    var pseudo: String
    var text: String
    var timestamp: Date = Date()
}

struct MessageView: View {
    var message: Message
    var isCurrentUser: Bool

    var body: some View {
        HStack {
            if isCurrentUser {
                Spacer()
                VStack(alignment: .trailing) {
                    Text(message.pseudo)
                        .bold()
                        .foregroundColor(.white)
                    Text(message.text)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
            } else {
                VStack(alignment: .trailing) {
                    Text(message.pseudo)
                        .bold()
                        .foregroundColor(.white)
                    Text(message.text)
                        .padding()
                        .background(Color.pink)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                Spacer()
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    Chat().environmentObject(AuthManager())
}

