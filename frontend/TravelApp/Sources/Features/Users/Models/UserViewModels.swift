//
//  UserViewModel.swift
//  TravelApp
//
//  Created by Chris Jacobs on 11/12/23.


import Foundation
import Combine
import KeychainSwift
import SwiftUI

struct SessionData: Codable {
    var userData: UserModel
}

class UserViewModel: ObservableObject {
    private let api =       UserAPI()
    private let keychain  = KeychainSwift()
    @Published var isLoggedIn: Bool = false
    @Environment(\.dismiss) var dismiss
    
    // ----------------------------------------------------------------------------------
    // User Session Functions
    // ----------------------------------------------------------------------------------
    
    // Save A User Session
    // ----------------------------------------------------------------------------------
    func saveSession(userData: UserModel) {
        let sessionData = SessionData(userData: userData)
        if let sessionData = try? JSONEncoder().encode(sessionData){
            keychain.set(sessionData, forKey: "userSession")
        }
        if getSessionData() != nil { isLoggedIn = true } else { isLoggedIn = false }
    }
    
    
    // Get Data From A User Session
    // ----------------------------------------------------------------------------------
    func getSessionData() -> SessionData? {
        guard let sessionData = keychain.getData("userSession") else { return nil }
        return try? JSONDecoder().decode(SessionData.self, from: sessionData)
    }
    
    
    // Delete A User Session
    func clearSession() {
        keychain.delete("userSession")
        isLoggedIn = false
    }
    
    // ----------------------------------------------------------------------------------
    // User View Model Functions
    // ----------------------------------------------------------------------------------
    
    // Create User
    // ----------------------------------------------------------------------------------
    func createUser(userEmail:    String,
                    displayName:  String,
                    birthDate:    String,
                    userPassword: String) {
        
        let newUser = CreateUserModel( userEmail:    userEmail,
                                       displayName:  displayName,
                                       birthDate:    birthDate,
                                       userPassword: userPassword )
        
        api.createUser(user: newUser) { api_response in
            DispatchQueue.main.async {
                if let api_response = api_response {
                    self.saveSession(userData: api_response)
                } else {
                    print("Account Creation Failed")
                    return
                }
            }
        }
    }
    
    // Login User
    // ----------------------------------------------------------------------------------
    func loginUser(userEmail: String, userPassword: String) {
        
        api.loginUser(userEmail: userEmail, userPassword: userPassword) { loginResponse in
            DispatchQueue.main.async {
                if let loginResponse = loginResponse {
                    self.saveSession(userData: loginResponse)
                } else {
                    print("Login Failed")
                    return
                }
            }
        }
    }
}

 

