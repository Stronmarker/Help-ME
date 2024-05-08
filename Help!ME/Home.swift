import SwiftUI
import Firebase
import FirebaseFirestore

struct Home: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var isLoggedOut = false

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.black, Color.gray]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)

                VStack {
                    Text("Bienvenue sur Help!ME")
                        .font(.largeTitle)
                        .padding(.bottom, 80)
                        .foregroundColor(.orange)
                        .bold()
                    
                    NavigationLink(destination: Chat()) {
                        Text("Chat Public")
                            .font(.title2)
                            .bold()
                            .frame(minWidth: 0, maxWidth: 200)
                            .padding()
                            .background(Color.orange.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 10)
                    
                    NavigationLink(destination: MP()) {
                        Text("Messages Privés")
                            .font(.title2)
                            .bold()
                            .frame(minWidth: 0, maxWidth: 200)
                            .padding()
                            .background(Color.orange.opacity(0.7))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 10)
                    
                    NavigationLink(destination: Profile()) {
                        Text("Profil")
                            .font(.title2)
                            .bold()
                            .frame(minWidth: 0, maxWidth: 200)
                            .padding()
                            .background(Color.orange.opacity(0.6))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
        }
    }
}


#Preview {
    Home()
        .environmentObject(AuthManager())
}
