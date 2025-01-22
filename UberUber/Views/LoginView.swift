//
//  LoginView.swift
//  UberUber
//
//  Created by nezzar dalia on 08/01/2025.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var passwordConfirmation: String = ""
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    @State private var showRegister: Bool = false
    
    // Champs d'inscription
    @State private var firstname: String = ""
    @State private var lastname: String = ""
    @State private var birthdate = Date()
    
    var body: some View {
        ZStack {
            // Fond avec dégradé
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "#19647E"),
                    Color(hex: "#28AFB0"),
                    Color(hex: "#DDCECD")
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Vagues animées
            AnimatedWaves()
                .ignoresSafeArea()
            
            // Contenu
            ScrollView {
                VStack(spacing: 20) {
                    
                    Spacer()
                        .frame(height: 125)
                                        
                    GeometryReader { geometry in
                        VStack {

                            Image("LogoBlack")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 250, height: 300)

                        }
                        .frame(width: geometry.size.width, height: geometry.size.height)
                    }
                    .padding(.bottom, 125)
                    
                    Text(showRegister ? "Créer un compte" : "Connexion")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    VStack(spacing: 16) {
                        ModernTextField(placeholder: "Email", text: $email, systemImage: "envelope")
                        
                        if showRegister {
                            ModernTextField(placeholder: "Prénom", text: $firstname, systemImage: "person")
                                .transition(.move(edge: .top).combined(with: .opacity))
                            
                            ModernTextField(placeholder: "Nom", text: $lastname, systemImage: "person")
                                .transition(.move(edge: .top).combined(with: .opacity))
                            
                            DatePicker("Date de naissance", selection: $birthdate, displayedComponents: .date)
                                .datePickerStyle(.compact)
                                .foregroundStyle(.white)
                                .padding()
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(12)
                                .transition(.move(edge: .top).combined(with: .opacity))
                        }
                        
                        ModernTextField(placeholder: "Mot de passe", text: $password, systemImage: "key", isSecure: true)
                        
                        if showRegister {
                            ModernTextField(
                                placeholder: "Confirmation",
                                text: $passwordConfirmation,
                                systemImage: passwordConfirmation.isEmpty ? "key" : (password == passwordConfirmation ? "checkmark" : "xmark"),
                                isSecure: true
                            )
                        }
                    }
                    .padding(.horizontal)
                    
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding(.horizontal)
                    }
                    
                    // Bouton principal
                    Button(action: {
                        Task {
                            isLoading = true
                            errorMessage = nil
                            
                            if showRegister {
                                guard password == passwordConfirmation else {
                                    errorMessage = "Les mots de passe ne correspondent pas."
                                    isLoading = false
                                    return
                                }
                                
                                await userViewModel.registerUser(
                                    firstname: firstname,
                                    lastname: lastname,
                                    email: email,
                                    password: password,
                                    birthdate: birthdate,
                                    image_url: URL(string:"https://api.dicebear.com/9.x/personas/jpg")!,
                                    is_alive: 1,
                                    allow_criminal_record: 0,
                                    wants_extra_napkins: 1
                                )
                                
                            } else {
                                await userViewModel.getUser(email: email, password: password)
                            }
                            
                            isLoading = false
                            
                            // Gestion des erreurs
                            if case .failed(let error) = userViewModel.state {
                                errorMessage = "Le mot de passe ou l'email est incorrect."
                            } else if case .success = userViewModel.state {
                                errorMessage = nil
                            }
                        }
                    }) {
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text(showRegister ? "S'inscrire" : "Se connecter")
                                    .fontWeight(.semibold)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color(hex: "1C1C1D"), Color(hex: "#19647E")]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                        .foregroundColor(.white)
                    }
                    .disabled(isLoading || email.isEmpty)
                    .padding(.horizontal)

                    
                    // Bouton pour basculer entre connexion et inscription
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            showRegister.toggle()
                        }
                    }) {
                        Text(showRegister ? "Déjà inscrit ? Se connecter" : "Pas de compte ? S'inscrire")
                            .foregroundStyle(showRegister ? Color(hex: "1C1C1D") : .white)
                            .underline()

                    }
                }
                .padding(.bottom, 50)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
#Preview {
    LoginView()
}
