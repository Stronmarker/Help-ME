//import Foundation
//import Firebase
//import FirebaseFirestore
//
//func ajouterMessage(utilisateur: String, texte: String) {
//    // Référence à la collection "Message"
//    let db = Firestore.firestore()
//    var ref: DocumentReference? = nil
//
//    // Ajouter un document avec un ID automatiquement généré
//    ref = db.collection("Message").addDocument(data: [
//        "user": utilisateur,
//        "text": texte
//    ]) { err in
//        if let err = err {
//            print("Erreur lors de l'ajout du message: \(err)")
//        } else {
//            print("Message ajouté avec l'ID: \(ref!.documentID)")
//        }
//    }
//}
//
//// Appel de la fonction pour ajouter un message
//ajouterMessage(utilisateur: "utilisateur123", texte: "Ceci est un message de test.")
