import Firebase
import SwiftUI
import FirebaseFirestore

struct Control: View {
    
    // Propriété pour stocker l'état de la connexion Firestore
    @State private var isConnectedToFirestore = false
    
    var body: some View {
        Text("Connection à Firestore: \(isConnectedToFirestore ? "Connecté" : "Déconnecté")")
            .onAppear {
                surveillerChangementsDeConnexion()
            }
    }
    
    // Fonction pour surveiller les changements de connexion Firestore
    func surveillerChangementsDeConnexion() {
        let db = Firestore.firestore()
        
        // Désactive temporairement la connexion réseau à Firestore
        db.disableNetwork { error in
            if let error = error {
                print("Erreur lors de la désactivation du réseau Firestore: \(error)")
                isConnectedToFirestore = false
            } else {
                print("Connexion réseau Firestore désactivée")
                isConnectedToFirestore = false
            }
            
            // Réactive la connexion réseau à Firestore
            db.enableNetwork { error in
                if let error = error {
                    print("Erreur lors de la réactivation du réseau Firestore: \(error)")
                    isConnectedToFirestore = false
                } else {
                    print("Connexion réseau Firestore réactivée")
                    isConnectedToFirestore = true
                }
            }
        }
    }
}

#Preview {
    Control()
}
