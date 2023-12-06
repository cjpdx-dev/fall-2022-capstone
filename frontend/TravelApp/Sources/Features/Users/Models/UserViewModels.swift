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
    private let api       = UserAPI()
    private let keychain  = KeychainSwift()
    
    @Published
    var isLoggedIn: Bool  = false
    
    @Published
    var loginErrorMessage: String? = nil
    
    @Published
    var loginErrorShown: Bool = false
    
    @Environment(\.dismiss)
    var dismiss
    
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
        if getSessionData() != nil { self.isLoggedIn = true } else { self.isLoggedIn = false }
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
        self.isLoggedIn = false
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
                    self.loginErrorMessage = "Login failed. Please check your credentials."
                    self.loginErrorShown = true
                    return
                }
            }
        }
    }
    

    // Update User Profile
    func updateUserProfile(displayName: String, 
                           bio: String, 
                           homeCity:String,
                           homeState: String,
                           profileVisibility: Bool,
                           expVisibility: Bool,
                           tripsVisibility: Bool,
                           locationVisibility: Bool,
                           completion: @escaping (Bool) -> Void) {
        
        guard var sessionData = getSessionData() else {
            completion(false)
            return
        }
        
        var updatedUserData = sessionData.userData

        updatedUserData.displayName             = displayName
        updatedUserData.userBio                 = bio
        updatedUserData.homeCity                = homeCity
        updatedUserData.homeState               = homeState
        updatedUserData.profileIsPublic         = profileVisibility
        updatedUserData.experiencesArePublic    = expVisibility
        updatedUserData.tripsArePublic          = tripsVisibility
        updatedUserData.locationIsPublic        = locationVisibility


        self.api.updateUserProfile(userData: updatedUserData) { updatedUser in
            DispatchQueue.main.async {
                if let updatedUser = updatedUser {
                    self.saveSession(userData: updatedUserData)
                    completion(true)
                    print("Update successful")
                    
                } else {
                    print("API failed to update user profile")
                    completion(false)
                }
            }
        }
        return
    }
    
    func deleteUser(completion: @escaping (Bool) -> Void) {
        guard let userData = getSessionData()?.userData else {
            completion(false)
            return
        }
        
        api.deleteUser(userID: userData.id, userToken: userData.token) { success, error in
            DispatchQueue.main.async {
                if success {
                    self.clearSession() // Clear session if delete is successful
                    completion(true)
                } else {
                    print("Error deleting user: \(error?.localizedDescription ?? "Unknown error")")
                    completion(false)
                }
            }
        }
    }
    
}

 

