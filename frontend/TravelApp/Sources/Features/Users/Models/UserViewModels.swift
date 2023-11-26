//
//  UserViewModel.swift
//  TravelApp
//
//  Created by Chris Jacobs on 11/12/23.


import Foundation
import Combine
import KeychainSwift
import SwiftUI

class UserViewModel: ObservableObject {
    private let api = UserAPI()
    @Environment(\.dismiss) var dismiss
//    @Published var currentUser: UserModel?
    
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
                    SessionManager.shared.saveSession(userData: api_response)
//                  self.currentUser = api_response
                    
                } else {
                    print("Account Creation Failed")
                    return
                }
            }
        }
        
    }
    
    func loginUser(userEmail: String, userPassword: String) {
        
        api.loginUser(userEmail: userEmail, userPassword: userPassword) { loginResponse in
            DispatchQueue.main.async {
                if let loginResponse = loginResponse {
                    SessionManager.shared.saveSession(userData: loginResponse)
                    // self.currentUser = loginResponse.user
                } else {
                    print("Login Failed")
                    return
                }
            }
        }
    }
    
}

 

