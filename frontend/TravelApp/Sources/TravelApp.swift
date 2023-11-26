//
//  TravelAppApp.swift
//  TravelApp
//
//  Created by Bryshon Sweeney on 10/24/23.
//

import SwiftUI

@main
struct TravelAppApp: App {
    @StateObject var userViewModel = UserViewModel()
    
    var body: some Scene {
        WindowGroup {
            if SessionManager.shared.isLoggedIn {
                HomeScreen(experiences: experiences)
            }
            else {
                SignUpScreen()
            }
        }
    }
}

#Preview {
    HomeScreen(experiences:experiences)
}
