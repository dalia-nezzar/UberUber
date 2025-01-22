//
//  Account.swift
//  UberUber
//
//  Created by nezzar dalia on 11/12/2024.
//

import SwiftUI

struct AccountView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var isEditing = false
    @State private var editedFirstName = ""
    @State private var editedLastName = ""
    @State private var editedEmail = ""
    @State private var editedBirthdate = Date()
    @State private var isAlive = true
    @State private var allowCriminalRecord = false
    @State private var wantsExtraNapkins = false
    
    private let headerHeight: CGFloat = 180
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(hex: "#28AFB0"),
                        Color(hex: "#DDCECD")
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                

                
                if case let .success(user) = userViewModel.state {
                    ScrollView {
                        VStack(spacing: 0) {
                            
                            Rectangle()
                                .fill(Color.clear)
                                .frame(height: 60)
                            
                            AsyncImage(url: user.image_url) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                Color.gray
                            }
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .padding(.top, 20)
                            
                            VStack(spacing: 20) {
                                if !isEditing {
                                    AccountInfoCard(title: "Informations Personnelles") {
                                        InfoRow(title: "Nom", value: "\(user.firstname) \(user.lastname)")
                                        InfoRow(title: "Email", value: user.email)
                                        InfoRow(title: "Date de naissance", value: formatDate(user.birthdate))
                                    }
                                    
                                    AccountInfoCard(title: "Préférences") {
                                        ToggleRow(title: "En vie", isOn: .constant(user.is_alive == 1))
                                        ToggleRow(title: "Tolère casier judiciaire", isOn: .constant(user.allow_criminal_record == 1))
                                        ToggleRow(title: "Serviettes supplémentaires", isOn: .constant(user.wants_extra_napkins == 1))
                                    }
                                } else {
                                    AccountInfoCard(title: "Modifier les informations") {
                                        TextField("Prénom", text: $editedFirstName)
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                        TextField("Nom", text: $editedLastName)
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                        TextField("Email", text: $editedEmail)
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                        DatePicker("Date de naissance", selection: $editedBirthdate, displayedComponents: .date)
                                        
                                        Toggle("En vie", isOn: $isAlive)
                                        Toggle("Autorise casier judiciaire", isOn: $allowCriminalRecord)
                                        Toggle("Serviettes supplémentaires", isOn: $wantsExtraNapkins)
                                    }
                                }
                                
                                VStack(spacing: 12) {
                                    if isEditing {
                                        Button(action: saveChanges) {
                                            Text("Enregistrer les modifications")
                                                .frame(maxWidth: .infinity)
                                                .padding()
                                                .background(Color(hex: "#28AFB0"))
                                                .foregroundColor(.white)
                                                .cornerRadius(10)
                                        }
                                    } else {
                                        Button(action: { isEditing = true }) {
                                            Text("Modifier le profil")
                                                .frame(maxWidth: .infinity)
                                                .padding()
                                                .background(Color(hex: "#28AFB0"))
                                                .foregroundColor(.white)
                                                .cornerRadius(10)
                                        }
                                    }
                                    
                                    Button(action: logout) {
                                        HStack {
                                            Image(systemName: "figure.walk.circle")
                                                .font(.title2) // Taille de l'icône
                                            Text("Déconnexion")
                                                .font(.headline) // Taille du texte
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color(hex: "#7058a3"))
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                    }
                                }
                                .padding(.horizontal)
                            }
                            .padding()
                        }
                    }
                    .background(Color(hex: "#DDCECD").opacity(0.1))
                    .onAppear {
                        initializeEditingFields(with: user)
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            ZStack {
                                Color.white
                                    .frame(width: 800, height: 150)
                                
                                Image("TonCompte")
                                    .resizable()
                                    .scaledToFit()
                                    .padding(.trailing, 190)
                                    .frame(height: 25)
                            }
                            .ignoresSafeArea(.all)
                        }
                    }
                }
 
            }
        }
    }
    
    private func formatDate(_ isoDateString: String) -> String {
        let customFormatter = DateFormatter()
        customFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = customFormatter.date(from: isoDateString) {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.timeStyle = .none
            formatter.locale = Locale(identifier: "fr_FR")
            return formatter.string(from: date)
        }
        return "Date invalide"
    }
    
    private func initializeEditingFields(with user: User) {
        editedFirstName = user.firstname
        editedLastName = user.lastname
        editedEmail = user.email
        
        // Correction du format de date pour ISO8601
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        if let date = isoFormatter.date(from: user.birthdate) {
            editedBirthdate = date
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            editedBirthdate = formatter.date(from: user.birthdate) ?? Date()
        }
        
        isAlive = user.is_alive == 1
        allowCriminalRecord = user.allow_criminal_record == 1
        wantsExtraNapkins = user.wants_extra_napkins == 1
    }

    private func getModifiedFields(user: User) -> [String: Any] {
        var modifiedFields: [String: Any] = [:]
        
        if editedFirstName != user.firstname {
            modifiedFields["firstname"] = editedFirstName
        }
        
        if editedLastName != user.lastname {
            modifiedFields["lastname"] = editedLastName
        }
        
        if editedEmail != user.email {
            modifiedFields["email"] = editedEmail
        }
        
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let currentDateString = isoFormatter.string(from: editedBirthdate)
        
        if let apiDate = isoFormatter.date(from: user.birthdate) {
            let apiDateString = isoFormatter.string(from: apiDate)
            if currentDateString != apiDateString {
                modifiedFields["birthdate"] = editedBirthdate
            }
        }
        
        let currentIsAlive = isAlive ? 1 : 0
        if currentIsAlive != user.is_alive {
            modifiedFields["is_alive"] = currentIsAlive
        }
        
        let currentAllowCriminalRecord = allowCriminalRecord ? 1 : 0
        if currentAllowCriminalRecord != user.allow_criminal_record {
            modifiedFields["allow_criminal_record"] = currentAllowCriminalRecord
        }
        
        let currentWantsExtraNapkins = wantsExtraNapkins ? 1 : 0
        if currentWantsExtraNapkins != user.wants_extra_napkins {
            modifiedFields["wants_extra_napkins"] = currentWantsExtraNapkins
        }
        
        return modifiedFields
    }

    private func saveChanges() {
        if case let .success(user) = userViewModel.state {
            let modifiedFields = getModifiedFields(user: user)
            
            if !modifiedFields.isEmpty {
                Task {
                    await userViewModel.editUser(
                        id_client: user.id_client,
                        firstname: modifiedFields["firstname"] as? String ?? user.firstname,
                        lastname: modifiedFields["lastname"] as? String ?? user.lastname,
                        email: modifiedFields["email"] as? String ?? user.email,
                        password: modifiedFields["password"] as? String ?? user.password,
                        birthdate: modifiedFields["birthdate"] as? Date ?? (DateFormatter().date(from: user.birthdate) ?? Date()),
                        image_url: user.image_url,
                        is_alive: modifiedFields["is_alive"] as? Int ?? user.is_alive,
                        allow_criminal_record: modifiedFields["allow_criminal_record"] as? Int ?? user.allow_criminal_record,
                        wants_extra_napkins: modifiedFields["wants_extra_napkins"] as? Int ?? user.wants_extra_napkins
                    )
                }
            }
            isEditing = false
        }
    }
    
    private func logout() {
        userViewModel.state = .notAvailable
    }
}

