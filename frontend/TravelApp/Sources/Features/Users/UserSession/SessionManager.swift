//
//  SessionManager.swift
//  TravelApp
//
//  Created by Chris Jacobs on 11/22/23.
//

import Foundation
import KeychainSwift

struct SessionData: Codable {
    var userData: UserModel
}

class SessionManager {
    static  let shared    = SessionManager()
    private let keychain  = KeychainSwift()
    
    var isLoggedIn: Bool {
        getSessionData() != nil
    }
    
    func saveSession(userData: UserModel) {
        let sessionData = SessionData(userData: userData)
        if let sessionData = try? JSONEncoder().encode(sessionData){
            keychain.set(sessionData, forKey: "userSession")
        }
    }
    
    func getSessionData() -> SessionData? {
        guard let sessionData = keychain.getData("userSession") else { return nil }
        return try? JSONDecoder().decode(SessionData.self, from: sessionData)
    }
    
    func clearSession() {
        keychain.delete("userSession")
    }
    
    private init() {}
}
