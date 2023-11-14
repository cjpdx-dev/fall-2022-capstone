//
//  TravelAppApp.swift
//  TravelApp
//
//  Created by Bryshon Sweeney on 10/24/23.
//

import SwiftUI

@main
struct TravelAppApp: App {
    var body: some Scene {
        WindowGroup {
            HomeScreen(experiences: experiences)
        }
    }
}

#Preview {
    HomeScreen(experiences:experiences)
}
